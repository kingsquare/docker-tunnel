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

FROM alpine:3.2
MAINTAINER Kingsquare <docker@kingsquare.nl>

ENV SSH_AUTH_SOCK /ssh-agent

####
# Install the SSH-client
RUN apk add --update openssh-client && rm -rf /var/cache/apk/*

VOLUME ["/ssh-agent"]
EXPOSE 2222 
ENTRYPOINT ["/usr/bin/ssh", "-T", "-N", "-o", "StrictHostKeyChecking=false", "-o", "ServerAliveInterval=180", "-R"]
