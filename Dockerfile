FROM ubuntu:latest

RUN apt update && apt install -y \
    nodejs \
    npm \
    openssl \
    unzip

ADD nodepki-0.2.zip /root/

WORKDIR /root
RUN unzip nodepki-* && rm nodepki*.zip && rename 's/(.*)/nodepki/' nodepki*

### Add nodepki config file
ADD config.yml /root/nodepki

WORKDIR /root/nodepki
RUN npm install

### genpki is executed manually with docker-compose run ...

EXPOSE 8081
EXPOSE 2560
EXPOSE 2561

### Run server
CMD nodejs server.js
