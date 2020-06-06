#!/bin/bash
# DESCRIPTION
#   Convert PDF file to DjVu+OCR
#
# USAGE
#   pdf2djvu-ocr # will look for ./*.pdf by default
#   pdf2djvu-ocr /path/or/pattern/**/*.pdf
#
# DEPENDENCIES
#   pdfsandwich tesseract pdf2djvu
#


source "${STYLERC:-./stylerc}" # include style


pattern=("${@:-"./*.pdf"}") # default pattern to use
THREAD_COUNT=4 # number of threads to use
FORCE='true' # force steps
RESOLUTION=300 # default resolution


# Create new PDF file (to the filesystem) after doing an OCR recognition
# @param    {string}    source filename
# @param    {string}    destination filename
# @return   {void}
function addOcr2Pdf() {
    local file="$1"
    local pdf_with_ocr="$2"

    if [[ ! -e "$pdf_with_ocr" || $FORCE == 'true' ]]; then
        echo "OCRing PDF"

        /usr/bin/pdfsandwich -sloppy_text \
            -lang fra \
            -resolution "$RESOLUTION" \
            -nthreads "$THREAD_COUNT" \
            -o "$pdf_with_ocr" \
            -quiet \
        "$file"
            # -verbose \
    else
        printf "\tSkipping PDF+OCR file already existing\n"
    fi
}

# Convert PDF+OCR into B&W DjVu file (to the filesystem)
# @param    {string}    source filename
# @param    {string}    destination filename
# @return   {void}
function convert2djvu() {
    local pdf_with_ocr="$1"
    local djvu_file="$2"

    if [[ ! -e "$djvu_file" || $FORCE == 'true' ]]; then # we need a source
        echo "Converting to DjVu"

        pdf2djvu \
            --bg-subsample=6 \
            --jobs="$THREAD_COUNT" \
            --fg-colors=web \
            --dpi="$RESOLUTION" \
            --quiet \
            -o "$djvu_file" \
        "$pdf_with_ocr"
    else
        printf "\tSkipping DjVu file already existing\n"
    fi
}


# Extract the resolution
# @param    {string}    filename
function getResolution() {
    identify -verbose "$1" \
        | grep -i "Resolution" \
        | cut -d 'x' -f 2
}

# Entry point:
#   1. transliterate filename
#   2. add OCR text,
#   3. convert to DjVu
# @return {void}
function run() {
    local pattern=("$@")
    for file in "${pattern[@]}"
    do
        local pdf_with_ocr="${file/.pdf/.pdf.ocr}"
        local djvu_file="${pdf_with_ocr/.pdf.ocr/.djvu}"

        printf "DjVu filename: %s\n" "$(_value "$djvu_file")"

        # generates PDF with OCR text
        addOcr2Pdf "$file" "$pdf_with_ocr"

        # creates DjVu files from PDF files
        convert2djvu "$pdf_with_ocr" "$djvu_file"

        printf "\n--"
    done
}

time run "${pattern[@]}"; # start script
