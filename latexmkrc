# 设置编译器为 xelatex
$latex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# 设置 biber 为 bib 文件处理器
$biber = 'biber %O %S';

# 编译顺序：xelatex -> biber -> xelatex -> xelatex
$bibtex_use = 2;
$pdf_mode = 1;
$pdflatex = $latex;

# 清理中间文件
@generated_exts = qw(aux bbl bcf blg log out run.xml toc lof lot fdb_latexmk fls nav snm synctex.gz);
