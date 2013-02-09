#!/bin/bash
# DESCRIPTION
#   Convert PDF file to DJVU+OCR
#
# USAGE
#
#
# DEPENDENCIES
#   pdfsandwich tesseract
#

pattern="$1/*.pdf"

for f in $(eval "$pattern");
do
    focr="${f/.pdf/.pdf.ocr}"
    fdjvu="${focr/.pdf.ocr/.djvu}"

    # generates PDF with OCR text,
    pdfsandwich -sloppy_text \
        -tesseract "$(which tesseract)" \
        -tesso -l fra \
        "$f" "$focr"

    # creates DjVu files from PDF files
    pdf2djvu -o "$fdjvu" "$focr"
done