IMAGE := roeish/android-base
VERSION ?=

ifeq ($(VERSION),)
$(error VERSION is required: the Android API level, e.g. `make build VERSION=35`)
endif

.PHONY: build push all

all: build push

build:
	docker build --build-arg ANDROID_API=$(VERSION) -t $(IMAGE):$(VERSION) .

push:
	docker push $(IMAGE):$(VERSION)
