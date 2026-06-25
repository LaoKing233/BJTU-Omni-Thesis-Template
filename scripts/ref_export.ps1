# File: ref_export.ps1
# Usage: scripts\ref_export.ps1
# 从编译好的 main.pdf 中提取参考文献，每条合并为一行，输出纯文本，便于复制粘贴
# 依赖 pdftotext（TeX Live / poppler 自带）

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$PDF = "main.pdf"
$OUTPUT = "outputs\references.txt"

if (-not (Test-Path $PDF)) {
    Write-Host "❌ 未找到 $PDF，请先编译生成 PDF 后再运行此脚本"
    exit 1
}

Write-Host "📚 从 $PDF 提取参考文献"
Write-Host "--------------------------------------"

# -layout 保留版面，便于按编号切分；提取全文（"-" 输出到 stdout）
$raw = & pdftotext -layout -enc UTF-8 $PDF - | Out-String
$lines = $raw -split "`r?`n"

# 清理单条文献：还原断字连字符 + 去除 URL 内部空格
function Clean-Entry([string]$s) {
    # 1) 还原排版断字：小写字母 + "- " + 小写字母 → 直接相连（informa- tion → information）
    #    保守只处理小写两侧，避免误伤页码(566-571)、型号(R-CNN)等
    while ($s -match '[a-z]- [a-z]') {
        $s = [regex]::Replace($s, '([a-z])- ([a-z])', '$1$2', 1)
    }
    # 2) URL 在条目末尾：从 http 起到行尾删除所有空格（URL 内不含合法空格）
    $m = [regex]::Match($s, 'https?://')
    if ($m.Success) {
        $head = $s.Substring(0, $m.Index)
        $url  = $s.Substring($m.Index) -replace ' ', ''
        $s = $head + $url
    }
    return $s
}

$stopHeadings = @("附录", "附 录", "独创性声明", "作者简历", "学位论文数据集", "致谢", "索引")
$entries = New-Object System.Collections.Generic.List[string]
$buf = ""
$inRef = $false

foreach ($line in $lines) {
    $stripped = $line.Trim()

    if (-not $inRef) {
        if ($stripped -eq "参考文献") { $inRef = $true }
        continue
    }

    # 已在参考文献区段内：遇到后置章节标题停止
    $stop = $false
    foreach ($h in $stopHeadings) {
        if ($stripped.StartsWith($h)) { $stop = $true; break }
    }
    if ($stop) { break }
    if ($stripped -eq "") { continue }
    if ($stripped -match '^\d+$') { continue }   # 跳过页眉/页脚孤立页码

    if ($stripped -match '^\[\d+\]') {
        if ($buf -ne "") { $entries.Add((Clean-Entry $buf)) }
        $buf = $stripped
    }
    elseif ($buf -ne "") {
        $buf = "$buf $stripped"
    }
}
if ($buf -ne "") { $entries.Add((Clean-Entry $buf)) }

# 写出 UTF-8（无 BOM），每行一条
[System.IO.File]::WriteAllLines((Resolve-Path -LiteralPath ".").Path + "\" + $OUTPUT, $entries, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "✅ 共提取 $($entries.Count) 条参考文献"
Write-Host "--------------------------------------"
Write-Host "ℹ️  结果已保存至 $OUTPUT（每行一条，可直接复制）"
