#!/bin/bash
# PDF compression script using Ghostscript
# Usage: ./compress_pdf.sh

command gs \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/ebook \
    -dNOPAUSE \
    -dQUIET \
    -dBATCH \
    -sOutputFile=dissertation.pdf \
    main.pdf
