# pdf2djvu-ocr

## Description

This Script follow the [discussion on SuperUser](http://superuser.com/q/280530/174465) to help convert from scanned PDF to DjVu+OCR.

## Dependencies

* pdfsandwich
* tesseract
* pdf2djvu

## Usage

The default behavior, i.e. call without arguments, will look for PDF files in the current working repository (glob: ./*.pdf) :

    pdf2djvu-ocr

Otherwise you can specify a path

    pdf2djvu-ocr /path/to/files/**/*.pdf