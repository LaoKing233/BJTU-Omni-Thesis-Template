# File: word_count.ps1
# Usage: scripts\word_count.ps1
# 统计正文字数（汉字 + 西文单词），递归展开所有 \include/\input 的章节文件

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$MAIN_TEX = "main.tex"
$OUTPUT = "outputs\main.wordcnt"

if (-not (Test-Path $MAIN_TEX)) {
    Write-Host "❌ 未找到主文件：$MAIN_TEX，请在项目根目录下运行此脚本"
    exit 1
}

Write-Host "📑 字数统计，主文件：$MAIN_TEX"
Write-Host "--------------------------------------"

& texcount -utf8 -inc -sum -nocolor $MAIN_TEX | Out-File -Encoding UTF8 $OUTPUT

Write-Host "📋 统计摘要："
Write-Host "--------------------------------------"

$lines = Get-Content $OUTPUT
$start = ($lines | Select-String '^Sum of files:' | Select-Object -First 1).LineNumber - 1
$end   = ($lines | Select-String '^Subcounts:'   | Select-Object -First 1).LineNumber - 1

$lines[$start..$end] | ForEach-Object { Write-Host $_ }
$lines[($end + 1)..($lines.Length - 1)] | Where-Object { $_ -match '^\s{2,}' } | ForEach-Object { Write-Host $_ }

Write-Host "--------------------------------------"
Write-Host "ℹ️  完整信息已保存至 $OUTPUT"
