REGISTRY ?= ghcr.io/roeishimron
ANDROID_API ?= 35
VERSION ?= 1.99.1
export REGISTRY

.PHONY: all build

# VERSION = Rust version for rust-slint, e.g. `make all VERSION=1.99.1`
all:
	$(MAKE) -C android-base all VERSION=$(ANDROID_API)
	$(MAKE) -C rust-slint all VERSION=$(VERSION) ANDROID_API=$(ANDROID_API)

build:
	$(MAKE) -C android-base build VERSION=$(ANDROID_API)
	$(MAKE) -C rust-slint build VERSION=$(VERSION) ANDROID_API=$(ANDROID_API)
