#!/bin/bash

# File: word_count.sh
# Usage: bash scripts/word_count.sh
# 统计正文字数（汉字 + 西文单词），递归展开所有 \include/\input 的章节文件

MAIN_TEX="main.tex"
OUTPUT="outputs/main.wordcnt"

echo "📑 字数统计，主文件：$MAIN_TEX"
echo "--------------------------------------"

texcount -utf8 -inc -sum -nocolor "$MAIN_TEX" > "$OUTPUT"

echo "📋 统计摘要："
echo "--------------------------------------"
sed -n '/^Sum of files:/,/^Subcounts:/p' "$OUTPUT"
sed -n '/^Subcounts:/,$p' "$OUTPUT" | grep '^  '
echo "--------------------------------------"
echo "ℹ️  完整信息已保存至 $OUTPUT"
