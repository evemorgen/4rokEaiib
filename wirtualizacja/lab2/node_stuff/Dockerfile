FROM node:0.10
MAINTAINER Jan Kowalski <jkowalski@fajnymail.com>
LABEL "ocena"="5 gwiazdek" "klasa"="pierwsza"
USER root
ENV AP /data/app
ENV SCPATH /etc/supervisor/conf.d
RUN apt -y update
RUN apt -y install supervisor
RUN mkdir -p /var/log/supervisor
ADD .supervisor/conf.d/* $SCPATH
ADD *.js* $AP/
WORKDIR $AP
RUN npm install
CMD ["supervisord", "-n"]
