# Time-stamp: < Makefile (2017-01-28 08:51) >
BUILD=build
VOLUME=$(shell echo "$$SSH_AUTH_SOCK:/ssh-agent")

# required argument SSH_CMD (provided by environment variable SSH_CMD)
ifdef $$SSH_CMD
SSH_CMD=$$SSH_CMD
endif

# optional argument NAME
NAME=docker-tunnel
ifdef $$NAME
NAME=$$NAME
endif

# optional argument TAG
TAG=autossh
ifdef $$TAG
TAG=$$TAG
endif

IMAGE=$(NAME):$(TAG)
CONTAINER_BUILD_MARKER=$(BUILD)/container-$(NAME)
IMAGE_BUILD_MARKER=$(BUILD)/image-$(NAME)-$(TAG)

.PHONY: all clean clean-container clean-image prepare image container start

all:
	@echo "legal targets: 'clean', 'clean-container', clean-image', 'build-image', 'build-container', 'start'"
	@echo ""
	@echo "    required argument to Makefile is 'SSH_CMD', ie:"
	@echo ""
	@echo '        make SSH_CMD="*:6379:localhost:6379 redis@172.17.0.1" build-container'
	@echo ""
	@echo "    optional arguments include 'NAME' and 'TAG', ie:"
	@echo ""
	@echo '        make NAME=redis-ssh-tunnel TAG=redis-project SSH_CMD="*:6379:localhost:6379 redis@172.17.0.1" build-container'

clean: clean-container clean-image
	rm -rf $(BUILD)

clean-container:
	rm -f $(CONTAINER_BUILD_MARKER)
	docker rm $(NAME)

clean-image:
	rm -f $(IMAGE_BUILD_MARKER)
	docker rmi $(IMAGE)

prepare:
	mkdir -p $(BUILD)

build-image: prepare $(IMAGE_BUILD_MARKER)

$(IMAGE_BUILD_MARKER): Dockerfile
	docker build -f $< -t $(IMAGE) .
	test `docker images --format '{{.ID}}' $(IMAGE) | wc -l` -eq "1" && touch $@

build-container: build-image $(CONTAINER_BUILD_MARKER)

$(CONTAINER_BUILD_MARKER): $(IMAGE_BUILD_MARKER)
ifeq ($(strip $(SSH_CMD)),)
	$(error please define SSH_CMD, ie: 'make SSH_CMD="*:6379:localhost:6379 redis@172.17.0.1" build-container')
else
	@echo "NAME   =$$NAME"
	@echo "TAG    =$$TAG"
	@echo "SSH_CMD=$$SSH_CMD"
endif
	docker run -d --name $(NAME) -v $(VOLUME) $(IMAGE) $(SSH_CMD)
	docker stop $(NAME)
	test `docker ps --all --filter=name=$(NAME) --format '{{.ID}}' | wc -l` -eq "1" && touch $@

start: build-container
	docker start -a -i $(NAME)
