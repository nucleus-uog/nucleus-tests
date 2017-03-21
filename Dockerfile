FROM python:2.7-alpine
MAINTAINER Devine Industries

RUN mkdir /nucleus
WORKDIR /nucleus
ADD . /nucleus/

RUN apk update
RUN apk add git bash
# pip install requirements.
RUN apk add libffi libffi-dev build-base
# Pillow Dependencies
RUN apk add jpeg-dev zlib-dev freetype-dev lcms2-dev openjpeg-dev tiff-dev tk-dev tcl-dev

ENTRYPOINT ["/bin/bash", "/nucleus/run.sh"]
