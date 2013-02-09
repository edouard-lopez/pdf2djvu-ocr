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

pattern="${1:-"*.pdf"}/*.pdf"

# printf "pattern: %s\n" "$pattern"

for f in $(eval echo "$pattern");
do
    focr="${f/.pdf/.pdf.ocr}"
    fdjvu="${focr/.pdf.ocr/.djvu}"

    # printf "OCR filename: %s\n" "$focr"
    # printf "DJVU+OCR filename: %s\n" "$fdjvu"

    # generates PDF with OCR text,
    /usr/bin/pdfsandwich -sloppy_text \
        -tesseract "$(which tesseract)" \
        -tesso -l fra \
        "$f" -o "$focr"

    [[ -f "$focr" ]] && printf "Failed to create %s\n" "$focr"

    # creates DjVu files from PDF files
    pdf2djvu -o "$fdjvu" "$focr"
done