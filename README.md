# pdf2djvu-ocr

## IMPORTANT (QUALITY) DISCLAIMER

This script is still young and the resulting `.djvu` files are not so good, often **bigger** than the original and with **medium to low** quality.
I hope people will help me improve this.
So before converting huge amount of documents **do some performance/quality benchmarking**.

## Description

This Script follow the [discussion on SuperUser](http://superuser.com/q/280530/174465) to help convert from scanned PDF to DjVu+OCR.

## Dependencies

* [stylerc](https://github.com/edouard-lopez/stylerc): bash output style ;
* [pdfsandwich](http://www.tobias-elze.de/pdfsandwich/) ;
* [tesseract-ocr](https://code.google.com/p/tesseract-ocr/) ;
* [pdf2djvu](http://freecode.com/projects/pdf2djvu).

## Usage

The default behavior, i.e. call without arguments, will look for PDF files in the current working repository (glob: `./*.pdf`) :

    pdf2djvu-ocr

Otherwise you can specify a path

    pdf2djvu-ocr /path/to/files/**/*.pdf
