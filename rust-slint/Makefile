REGISTRY ?= ghcr.io/roeishimron
IMAGE := $(REGISTRY)/rust-slint
VERSION ?=
ANDROID_API ?= 35

ifeq ($(VERSION),)
$(error VERSION is required: the Rust version, e.g. `make build VERSION=1.99.1`)
endif

TAG := $(VERSION)-api$(ANDROID_API)

.PHONY: build push all

all: build push

build:
	docker build --build-arg REGISTRY=$(REGISTRY) --build-arg RUST_VERSION=$(VERSION) --build-arg ANDROID_API=$(ANDROID_API) -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)
