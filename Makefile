SEVERITIES = HIGH,CRITICAL

ifeq ($(ARCH),)
ARCH=$(shell go env GOARCH)
endif

BUILD_META=-build$(shell date +%Y%m%d)
ORG ?= rancher
# last commit on 2021-10-06
<<<<<<< Updated upstream
TAG ?= v3.5.1$(BUILD_META)
=======
TAG ?= v3.4.0$(BUILD_META)
CREATED ?= $(shell date --iso-8601=s -u)
REF ?= $(shell git symbolic-ref HEAD)
>>>>>>> Stashed changes

ifneq ($(DRONE_TAG),)
TAG := $(DRONE_TAG)
endif

ifeq (,$(filter %$(BUILD_META),$(TAG)))
$(error TAG needs to end with build metadata: $(BUILD_META))
endif

.PHONY: image-build
image-build:
	docker build \
		--build-arg ARCH=$(ARCH) \
		--build-arg TAG=$(TAG:$(BUILD_META)=) \
		--build-arg BCI_IMAGE=registry.suse.com/bci/bci-base:latest \
		--label "org.opencontainers.image.url=https://github.com/brooksn/image-build-sriov-network-device-plugin" \
		--label "org.opencontainers.image.created=$(CREATED)" \
		--label "org.opencontainers.image.authors=brooksn" \
		--label "org.opencontainers.image.ref.name=$(REF)" \
		--tag $(ORG)/hardened-sriov-network-device-plugin:$(TAG) \
		--tag $(ORG)/hardened-sriov-network-device-plugin:$(TAG)-$(ARCH) \
	.

.PHONY: image-push
image-push:
	docker push $(ORG)/hardened-sriov-network-device-plugin:$(TAG)-$(ARCH)

.PHONY: image-manifest
image-manifest:
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create --amend \
		$(ORG)/hardened-sriov-network-device-plugin:$(TAG) \
		$(ORG)/hardened-sriov-network-device-plugin:$(TAG)-$(ARCH)
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push \
		$(ORG)/hardened-sriov-network-device-plugin:$(TAG)

.PHONY: image-scan
image-scan:
	trivy --severity $(SEVERITIES) --no-progress --ignore-unfixed $(ORG)/hardened-sriov-network-device-plugin:$(TAG)
