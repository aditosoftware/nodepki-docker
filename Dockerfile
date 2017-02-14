FROM ubuntu:xenial

RUN apt update && apt install -y \
    nodejs \
    npm \
    openssl

ADD nodepki /root/nodepki
ADD nodepki-client /root/nodepki-client

### Add setup script to create persistent content
ADD setup.sh /root/

WORKDIR /root/nodepki-client
RUN npm install

WORKDIR /root/nodepki
RUN npm install

### genpki is executed manually with docker-compose run ...

EXPOSE 8081
EXPOSE 2560
EXPOSE 2561

### Run server
CMD nodejs server.js
