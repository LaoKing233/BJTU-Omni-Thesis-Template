#!/bin/bash

# File: ref_export.sh
# Usage: bash scripts/ref_export.sh
# 从编译好的 main.pdf 中提取参考文献，每条合并为一行，输出纯文本，便于复制粘贴
# 依赖 pdftotext（TeX Live / poppler 自带）

PDF="main.pdf"
OUTPUT="outputs/references.txt"
TMP="outputs/.refs_raw.txt"

if [ ! -f "$PDF" ]; then
    echo "❌ 未找到 $PDF，请先编译生成 PDF 后再运行此脚本"
    exit 1
fi

echo "📚 从 $PDF 提取参考文献"
echo "--------------------------------------"

# -layout 保留版面，便于按编号切分；提取全文到临时文件
pdftotext -layout -enc UTF-8 "$PDF" "$TMP"

# 提取"参考文献"标题之后、后置章节（附录/独创性声明等）之前的条目，
# 并将每条折行合并为一行（以 [数字] 开头判定为新条目）
awk '
    # 清理单条文献：还原断字连字符 + 去除 URL 内部空格
    function clean(s,    head, url) {
        # 1) 还原排版断字：小写字母 + "- " + 小写字母 → 直接相连（informa- tion → information）
        #    保守只处理小写两侧，避免误伤页码(566-571)、型号(R-CNN)等
        while (match(s, /[a-z]- [a-z]/)) {
            s = substr(s, 1, RSTART) substr(s, RSTART + 3)
        }
        # 2) URL 在条目末尾：从 http 起到行尾删除所有空格（URL 内不含合法空格）
        if (match(s, /https?:\/\//)) {
            head = substr(s, 1, RSTART - 1)
            url  = substr(s, RSTART)
            gsub(/ /, "", url)
            s = head url
        }
        return s
    }

    /^[[:space:]]*参考文献[[:space:]]*$/ { inref=1; next }
    inref {
        if ($0 ~ /^[[:space:]]*(附[[:space:]]*录|独创性声明|作者简历|学位论文数据集|致谢|索引)/) { inref=0; next }

        line=$0
        sub(/^[[:space:]]+/, "", line)
        sub(/[[:space:]]+$/, "", line)
        if (line == "") next
        if (line ~ /^[0-9]+$/) next   # 跳过页眉/页脚孤立页码

        if (line ~ /^\[[0-9]+\]/) {
            if (buf != "") print clean(buf)
            buf=line
        } else if (buf != "") {
            buf=buf " " line
        }
    }
    END { if (buf != "") print clean(buf) }
' "$TMP" > "$OUTPUT"

rm -f "$TMP"

COUNT=$(grep -c '^\[[0-9]\+\]' "$OUTPUT")
echo "✅ 共提取 $COUNT 条参考文献"
echo "--------------------------------------"
echo "ℹ️  结果已保存至 $OUTPUT（每行一条，可直接复制）"
