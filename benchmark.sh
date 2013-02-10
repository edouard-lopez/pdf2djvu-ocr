#!/bin/bash

pattern=("${@:-"./*.ocr"}") # default pattern to use
rawSizeFile=/tmp/benchmark-pdf2djvu-ocr.csv
ratioFile=/tmp/ratio-pdf2djvu-ocr.csv

function getSizeInKilo() {
    local file="$1"
    echo $(stat -c "%s" "$file") # in bytes
    # echo "$(( $(stat -c "%s" "$file")/1024 ))" # in kilobyte
}


# Create a csv file containing :
#   * original PDF filesize
#   * PDF+OCR filesize
#   * DjVu+OCR filesize
# @param    {array} list of files to use
# @return   {void}
function getRawSize() {
    local pattern=("$@")

    for f in "${pattern[@]}"
    do
        local ocr="$f"; # dummy just to follow pattern
        local ocrSz="$(getSizeInKilo "$ocr")";

        local pdf="${f/.ocr/}";
        local pdfSz="$(getSizeInKilo "$pdf")";

        local djvu="${f/.pdf.ocr/.djvu}";
        local djvuSz="$(getSizeInKilo "$djvu")";

        printf "%s;%s;%s\n" "$pdfSz" "$ocrSz" "$djvuSz" \
            "$rawSizeFile"
    done
}


function getRatio() {
    awk '{
        pdf2ocr=$2/$1;
        ocr2djvu=$2/$3;
        pdf2djvu=$3/$1;

        print pdf2ocr ";" ocr2djvu ";" pdf2djvu
    }' "$rawSizeFile" >> "$ratioFile"
}

function run() {
    local pattern=("$@")

    getRawSize "${pattern[@]}"

    getRatio
}

time run "${pattern[@]}"; # start script