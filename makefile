install: 
	curl \
		--location \
		--output ./stylerc \
		https://github.com/edouard-lopez/stylerc/raw/master/stylerc
	apt install \
		pdfsandwich \
		pdf2djvu \
		tesseract-ocr-fra
