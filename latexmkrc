$aux_dir = "build";
$out_dir = ".";
$pdf_mode = 1; # ensure PDF build
$bibtex_use = 2; # auto-detect biber/bibtex

$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
