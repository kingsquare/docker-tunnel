###
#
# A docker image to allow ssh-tunneling via this image
#
# Usage:
# docker run -d --name [$your_tunnel_name] -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:[$exposed_port]:[$destination]:[$destination_port] [$user@][$server]
#
# ie. docker run -d --name example_tunnel -v $SSH_AUTH_SOCK:/ssh-agent kingsquare/tunnel *:2222:127.0.0.1:23152 user@example.com
#
###

FROM ubuntu:14.04
MAINTAINER Kingsquare <docker@kingsquare.nl>

ENV SSH_AUTH_SOCK /ssh-agent

####
# Install the SSH-client + clean APT back up
RUN DEBIAN_FRONTEND=noninteractive apt-get update -q && \
	apt-get install -yq openssh-client && \
	apt-get autoremove --purge -yq
	apt-get clean && \
	rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

VOLUME ["/ssh-agent"]
EXPOSE 2222 
ENTRYPOINT ["/usr/bin/ssh", "-T", "-N", "-o", "StrictHostKeyChecking=false", "-o", "ServerAliveInterval=180", "-L"]