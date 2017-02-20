FROM ubuntu:xenial

RUN apt update && apt install -y \
    nodejs \
    npm \
    openssl \
    curl

WORKDIR /root
RUN curl -L https://github.com/aditosoftware/nodepki/archive/v1.0-rc1.tar.gz | tar xz && mv nodepki-1.0-rc1 nodepki
RUN curl -L https://github.com/aditosoftware/nodepki-client/archive/v1.0-rc1.tar.gz | tar xz && mv nodepki-client-1.0-rc1 nodepki-client

### Add setup script to create persistent content
ADD setup.sh /root/

WORKDIR /root/nodepki-client
RUN npm install

WORKDIR /root/nodepki
RUN npm install

### genpki is executed manually with docker-compose run ...

EXPOSE 8080
EXPOSE 8081
EXPOSE 2560

### Run server
CMD nodejs server.js
