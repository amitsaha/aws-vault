VERSION=$(shell git describe --tags --candidates=1 --dirty)
FLAGS=-X main.Version=$(VERSION) -s -w
CERT="Developer ID Application: 99designs Inc (NRM9HVJ62Z)"
SRC=$(shell find . -name '*.go')

.PHONY: build install sign release clean

build: $(SRC)
	go build -o aws-vault -ldflags="$(FLAGS)" .

install:
	go install -ldflags="$(FLAGS)" .

sign:
	codesign -s $(CERT) ./aws-vault

aws-vault-linux-amd64: $(SRC)
	GOOS=linux GOARCH=amd64 go build -o $@ -ldflags="$(FLAGS)" .

aws-vault-darwin-amd64: $(SRC)
	GOOS=darwin GOARCH=amd64 go build -o $@ -ldflags="$(FLAGS)" .
	codesign -s $(CERT) $@

aws-vault-windows-386.exe: $(SRC)
	GOOS=windows GOARCH=386 go build -o $@ -ldflags="$(FLAGS)" .

release: aws-vault-linux-amd64 aws-vault-darwin-amd64 aws-vault-windows-386.exe

clean:
	rm -f aws-vault aws-vault-linux-amd64 aws-vault-darwin-amd64 aws-vault-windows-386.exe
