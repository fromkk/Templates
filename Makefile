PREFIX?=/usr/local

TEMPORARY_FOLDER=./tmp_portable_templates
OSNAME=${shell uname -s}

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

test:
	swift test

lint:
	swiftlint

clean:
	swift package clean

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/Templates" "$(PREFIX)/bin/templates"

uninstall:
	rm -r "$(PREFIX)/bin/templates"

portable_zip: build
	mkdir -p "$(TEMPORARY_FOLDER)"
	cp -f ".build/release/Templates" "$(TEMPORARY_FOLDER)/templates"
	cp -f "LICENSE" "$(TEMPORARY_FOLDER)"
	(cd $(TEMPORARY_FOLDER); zip -r - LICENSE templates) > "./portable_templates.zip"
	rm -r "$(TEMPORARY_FOLDER)"

