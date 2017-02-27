FROM python:3
MAINTAINER Devine Industries

RUN mkdir /nucleus
WORKDIR /nucleus
ADD . /nucleus/

ENTRYPOINT ["/bin/bash", "/nucleus/run.sh"]
