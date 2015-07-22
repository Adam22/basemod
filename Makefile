PACKAGE = $(shell basename `pwd`)

make:
	dpkg-deb -z9 -Zgzip --build dist $(PACKAGE).deb

