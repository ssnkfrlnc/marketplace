# Adapted from https://github.com/bufbuild/buf-example/blob/main/Makefile

SHELL := /usr/bin/env bash -o pipefail

# This controls the location of the cache.
PROJECT := marketplace-protos

# This controls the version of buf to install and use.
BUF_VERSION := 1.40.0
# If true, Buf is installed from source instead of from releases
BUF_INSTALL_FROM_SOURCE := false

PROTOC_VERSION := 28.0

# Add a variable for the template version.
GEN_YAML_TEMPLATE := buf.v0.gen.yaml # Provide value for GEN_YAML_TEMPLATE in the make command to use another version like so: make genprotos GEN_YAML_TEMPLATE=buf.v2.gen.yaml

### Everything below this line is meant to be static, i.e. only adjust the above variables. ###
UNAME_OS := $(shell uname -s)
UNAME_ARCH := $(shell uname -m)
ifeq ($(UNAME_OS),Darwin)
	PLATFORM := osx
	PROTOC_ARCH := x86_64
else
	PROTOC_ARCH := $(UNAME_ARCH)
endif
ifeq ($(UNAME_OS),Linux)
	PLATFORM := linux
endif
# Buf will be cached to ~/.cache/buf-example.
CACHE_BASE := $(HOME)/.cache/$(PROJECT)
# This allows switching between i.e a Docker container and your local setup without overwriting.
CACHE := $(CACHE_BASE)/$(UNAME_OS)/$(UNAME_ARCH)
# The location where buf will be installed.
CACHE_BIN := $(CACHE)/bin
# Marker files are put into this directory to denote the current version of binaries that are installed.
CACHE_VERSIONS := $(CACHE)/versions

# Update the $PATH so we can use buf directly
export PATH := $(abspath $(CACHE_BIN)):$(PATH)

# BUF points to the marker file for the installed version.
#
# If BUF_VERSION is changed, the binary will be re-downloaded.
BUF := $(CACHE_VERSIONS)/buf/$(BUF_VERSION)
$(BUF):
	 @rm -f $(CACHE_BIN)/buf
	 @mkdir -p $(CACHE_BIN)
 		ifeq ($(BUF_INSTALL_FROM_SOURCE),true)
 			$(eval BUF_TMP := $(shell mktemp -d))
			cd $(BUF_TMP); go install github.com/bufbuild/buf/cmd/buf@v$(BUF_VERSION)
			@rm -rf $(BUF_TMP)
 		else
			curl -sSL \
 				"https://github.com/bufbuild/buf/releases/download/v$(BUF_VERSION)/buf-$(UNAME_OS)-$(UNAME_ARCH)" \
 				-o "$(CACHE_BIN)/buf"
			chmod +x "$(CACHE_BIN)/buf"
 endif
	 @rm -rf $(dir $(BUF))
	 @mkdir -p $(dir $(BUF))
	 @touch $(BUF)

# PROTOC points to the marker file for the installed version.
#
# If PROTOC_VERSION is changed, the binary will be re-downloaded.
PROTOC := $(CACHE_VERSIONS)/protoc/$(PROTOC_VERSION)
 $(PROTOC):
	 @rm -f $(CACHE_BIN)/protoc
	 @mkdir -p $(CACHE_BIN)
	 $(eval PROTOC_TMP := $(shell mktemp -d))
	 curl -sSL \
	 	"https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOC_VERSION)/protoc-$(PROTOC_VERSION)-$(PLATFORM)-$(PROTOC_ARCH).zip" \
	 	-o "$(PROTOC_TMP)/protoc.zip"
	 unzip -o "$(PROTOC_TMP)/protoc.zip" -d "$(CACHE)" bin/protoc
	 unzip -o "$(PROTOC_TMP)/protoc.zip" -d "$(CACHE)" include/*
	 @rm -rf $(PROTOC_TMP)
	 chmod +x "$(CACHE_BIN)/protoc"
	 @rm -rf $(dir $(PROTOC))
	 @mkdir -p $(dir $(PROTOC))
	 @touch $(PROTOC)

.DEFAULT_GOAL := all

.PHONY: all
all: genprotos

# deps allows us to install deps without running any checks.

.PHONY: deps
deps: $(BUF) $(PROTOC)

.PHONY: genprotos
genprotos: $(BUF) $(PROTOC)
	buf dep update --verbose --debug --log-format json
	buf generate --template $(GEN_YAML_TEMPLATE) --verbose --debug --log-format json

.PHONY: cleandep
cleandep:
	rm -rf $(CACHE_BASE)
