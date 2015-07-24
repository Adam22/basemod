PACKAGE = $(shell basename `pwd`)

make:
	dpkg-deb -z9 -Zgzip --build dist $(PACKAGE).deb

install:	
	scp -P 8888 $(PACKAGE).deb dev:/storage/creatuity-deb-repository/amd64/
	ssh  devpl "cd /storage/creatuity-deb-repository && dpkg-scanpackages amd64 | gzip -9c > /storage/creatuity-deb-repository/amd64/Packages.gz"

clean:
	rm $(PACKAGE).deb
