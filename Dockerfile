FROM python:3.6-alpine
MAINTAINER Devine Industries

RUN mkdir /nucleus
WORKDIR /nucleus
ADD . /nucleus/

RUN apk update
RUN apk add git bash libffi libffi-dev build-base py3-pillow

ENTRYPOINT ["/bin/bash", "/nucleus/run.sh"]
