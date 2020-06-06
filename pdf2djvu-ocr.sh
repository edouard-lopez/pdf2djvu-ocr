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
RES=300 # default resolution


# Create new PDF file (to the filesystem) after doing an OCR recognition
# @param    {string}    source filename
# @param    {string}    destination filename
# @return   {void}
function addOcr2Pdf() {
    local f="$1"
    local fpdfocr="$2"

    if [[ ! -e "$fpdfocr" || $FORCE == 'true' ]]; then
        printf "%s OCRing PDF\n" "$_i"

        /usr/bin/pdfsandwich -sloppy_text \
            -lang fra \
            -resolution "$RES"x"$RES" \
            -nthreads "$THREAD_COUNT" \
            -o "$fpdfocr" \
            -quiet \
        "$f"
            # -verbose \
    else
        printf "\t%s Skipping PDF+OCR file already existing\n" "$_i"
    fi
}

# Convert PDF+OCR into B&W DjVu file (to the filesystem)
# @param    {string}    source filename
# @param    {string}    destination filename
# @return   {void}
function convert2djvu() {
    local fpdfocr="$1"
    local fdjvu="$2"

    if [[ ! -e "$fdjvu" || $FORCE == 'true' ]]; then # we need a source
        printf "%s Converting to DjVu\n" "$_i"

        pdf2djvu \
            --bg-subsample=6 \
            --jobs="$THREAD_COUNT" \
            --fg-colors=web \
            --dpi="$RES" \
            --quiet \
            -o "$fdjvu" \
        "$fpdfocr"
    else
        printf "\t%s Skipping DjVu file already existing\n" "$_i"
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
    # printf '%s\n' "${#pattern[@]}" # array size
    # printf '%s\n' "${pattern[@]}" # each item of the array

    for f in "${pattern[@]}"
    do
        local fpdfocr="${f/.pdf/.pdf.ocr}"
        local fdjvu="${fpdfocr/.pdf.ocr/.djvu}"

        # printf "%s filename: %s\n" "$_i" "$(_value "$f")"
        # printf "%s OCR filename: %s\n" "$_i" "$(_value "$fpdfocr")"
        printf "%s DjVu filename: %s\n" "$_i" "$(_value "$fdjvu")"

        # RES="$(getResolution "$f")"

        # generates PDF with OCR text
        addOcr2Pdf "$f" "$fpdfocr"

        # creates DjVu files from PDF files
        convert2djvu "$fpdfocr" "$fdjvu"

        printf "%s\n" "--"
    done
}

time run "${pattern[@]}"; # start script