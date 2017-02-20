FROM ubuntu
MAINTAINER Devine Industries

VOLUME ['/nucleus/results']

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common python3 git

RUN mkdir /nucleus
WORKDIR /nucleus

ADD run.sh /nucleus/run.sh
ADD tests/ /nucleus/tests/

ENTRYPOINT ['/bin/bash', '/nucleus/run.sh']
