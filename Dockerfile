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

FROM alpine:latest
MAINTAINER Kingsquare <docker@kingsquare.nl>
MAINTAINER bubak4 <mar@centrum.cz>

ENV SSH_AUTH_SOCK /ssh-agent

####
# Install the autossh
RUN apk add --update autossh && rm -rf /var/cache/apk/*

VOLUME ["/ssh-agent"]
ENTRYPOINT ["/usr/bin/autossh", "-M", "0", "-T", "-N", "-oStrictHostKeyChecking=no", "-L"]
