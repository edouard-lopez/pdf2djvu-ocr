#!/bin/bash
# DESCRIPTION
#   Convert PDF file to DJVU+OCR
#
# USAGE
#   pdf2djvu-ocr
#   pdf2djvu-ocr /path/or/pattern
#
# DEPENDENCIES
#   pdfsandwich tesseract
#

pattern="${@:-"./*.pdf"}"
THREAD_COUNT=4
RES=300

function addOcr2Pdf() {
    f="$1"
    fpdfocr="$2"

    # generates PDF with OCR text,
    printf "[i] Adding OCR text #1\n"
    /usr/bin/pdfsandwich -sloppy_text \
        -lang fra \
        -nthreads "$THREAD_COUNT" \
        -resolution "$RES"x"$RES" \
        -o "$fpdfocr" \
        -quiet \
    "$f"
}

function convert2djvu() {
    fpdfocr="$1"
    fdjvu="$2"

    # creates DjVu files from PDF files
    pdf2djvu \
        --bg-subsample=6 \
        -o "$fdjvu" \
        --jobs="$THREAD_COUNT" \
        --fg-colors=web \
        --quiet \
    "$fpdfocr"
}


function run() {
    # printf "pattern: %s\n" "$(eval echo "$pattern")"

    for f in $(eval echo "$pattern");
    do
        fpdfocr="${f/.pdf/.pdf.ocr}"
        fdjvu="${fpdfocr/.pdf.ocr/.djvu}"

        # printf "OCR filename: %s\n" "$fpdfocr"
        # printf "DJVU+OCR filename: %s\n" "$fdjvu"

        addOcr2Pdf "$f" "$fpdfocr"

        if [[ -f "$fpdfocr" ]]; then
            printf "Failed to create %s\n" "$fpdfocr"
            continue
        fi
        convert2djvu "$fpdfocr" "$fdjvu"

    done
}

time run; # start script