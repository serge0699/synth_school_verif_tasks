# Simple 'help' target which diplays all rows
# which contains two '#' simbols simbols in a row

.PHONY: help

help:
	@sed -ne '/@sed/!s/##//p' $(MAKEFILE_LIST)