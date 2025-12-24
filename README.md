# Evolution of Cooperation under Environmental Variability

This repository is used for managing my doctoral dissertation project.

## Citation

Inaba, M. (2026). *Evolution of Cooperation under Environmental Variability* [Doctoral dissertation, University of Tsukuba]. (DOI will be assigned)

## File Structure

```text
doctoral-dissertation/
├── main.tex            # Main LaTeX document
├── main.pdf            # LaTeX-generated PDF output
├── summary.tex         # Summary LaTeX document (Japanese)
├── summary.pdf         # Summary PDF output
├── dissertation.pdf    # Compressed PDF for submission
├── chapters/           # Chapter and ancillary files
│   ├── 1_introduction.tex
│   ├── 2_base_model.tex
│   ├── 3_2Lvl_model.tex
│   ├── 4_2D_model.tex
│   ├── 5_conclusion.tex
│   ├── appendix.tex
│   ├── acknowledgments.tex
│   └── summary.tex     # Summary content (included by summary.tex)
├── figures/            # Figure files organized by chapter
│   ├── 2/
│   ├── 3/
│   └── 4/
├── references.bib      # Bibliography database
├── util/               # Utility scripts
│   ├── latexdiff.sh    # Script for generating diff PDF between Git commits
│   └── compress_pdf.sh # PDF compression script
├── latexmkrc           # LaTeX build configuration
├── build/              # Build files directory
├── LICENSE             # License file
└── README.md
```

## Command

```sh
cd doctoral-dissertation

# Clean build files
latexmk -C main.tex
latexmk -C summary.tex

# Compile
latexmk -pdf main.tex
latexmk -xelatex summary.tex

# Compress
./util/compress_pdf.sh
```

## License

Copyright (c) 2025-2026 Masaaki Inaba

This work is licensed under CC-BY 4.0.

See [LICENSE](LICENSE) file for details.
