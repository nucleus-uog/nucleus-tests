FROM alpine:3.5
MAINTAINER Devine Industries

RUN mkdir /nucleus
WORKDIR /nucleus
ADD . /nucleus/

RUN apk update
RUN apk add python3 alpine-sdk git bash

ENTRYPOINT ["/bin/bash", "/nucleus/run.sh"]
