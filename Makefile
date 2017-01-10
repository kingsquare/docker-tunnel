# Time-stamp: < Makefile (2017-01-10 09:11) >
BUILD=build
NAME=docker-tunnel
TAG=bubak4
IMAGE=$(NAME):$(TAG)
VOLUME=$(shell echo "$$SSH_AUTH_SOCK:/ssh-agent")
# change to your liking
SSH_CMD=*:5432:localhost:5432 martin@172.17.0.1

.PHONY: all clean clean-container clean-image prepare image container start

all:
	@echo "legal targets: 'clean', 'clean-container', clean-image', 'build-image', 'build-container', 'start'"

clean: clean-container clean-image
	rm -rf $(BUILD)

clean-container:
	rm -f $(BUILD)/container
	docker rm $(NAME)

clean-image:
	rm -f $(BUILD)/image
	docker rmi $(IMAGE)

prepare:
	mkdir -p $(BUILD)

build-image: prepare $(BUILD)/image

$(BUILD)/image: Dockerfile
	docker build -f $< -t $(IMAGE) .
	test `docker images --format '{{.ID}}' $(IMAGE) | wc -l` -eq "1" && touch $@

build-container: build-image $(BUILD)/container

$(BUILD)/container: Dockerfile
	docker run -d --name $(NAME) -v $(VOLUME) $(IMAGE) $(SSH_CMD)
	docker stop $(NAME)
	test `docker ps --all --filter=name=$(NAME) --format '{{.ID}}' | wc -l` -eq "1" && touch $@

start: build-container
	docker start -a -i $(NAME)
