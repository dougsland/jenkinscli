.DEFAULT_GOAL := build
VERSION=$(shell git describe --tags --always --long)
SOURCE_GO=jenkinsctl.go
EXECUTABLE=jenkinsctl
WINDOWS=$(EXECUTABLE)_windows_amd64.exe
LINUX=$(EXECUTABLE)_linux_amd64
DARWIN=$(EXECUTABLE)_darwin_amd64

windows: createmod $(WINDOWS) ## Build for Windows

linux: createmod $(LINUX) ## Build for Linux

darwin: createmod $(DARWIN) ## Build for Darwin (macOS)

BIN_ALL_PLATFORMS=$(WINDOWS) $(LINUX) $(DARWIN)

$(WINDOWS):
	rm -f $(EXECUTABLE)
	env GOOS=windows GOARCH=amd64 go build -v -o $(WINDOWS) -ldflags="-s -w -X main.version=$(VERSION)"  $(SOURCE_GO)

$(LINUX):
	rm -f $(EXECUTABLE)
	env GOOS=linux GOARCH=amd64 go build -v -o $(LINUX) -ldflags="-s -w -X main.version=$(VERSION)"  $(SOURCE_GO)

$(DARWIN):
	rm -f $(EXECUTABLE)
	env GOOS=darwin GOARCH=amd64 go build -v -o $(DARWIN) -ldflags="-s -w -X main.version=$(VERSION)" $(SOURCE_GO)

createmod: clean
	cd jenkins && go mod init
	cd jenkins && go mod tidy
	go mod init
	go mod tidy

all: createmod build

clean:
	rm -f go.sum go.mod $(BIN_ALL_PLATFORMS)
	cd jenkins && rm -f go.mod go.sum
	go clean --modcache

build: createmod windows linux darwin ## Build binaries
	@echo version: $(VERSION)
