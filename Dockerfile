FROM ubuntu:latest

RUN apt update && apt install -y \
    nodejs \
    npm \
    openssl \
    unzip

ADD nodepki* /root/

WORKDIR /root
RUN unzip nodepki-0.1.1.zip
RUN unzip nodepki-client-0.1.0.zip

### Add nodepki config file
ADD config.yml /root/nodepki-0.1.1/

WORKDIR /root/nodepki-0.1.1
RUN npm install

EXPOSE 8081
EXPOSE 2560
EXPOSE 2561

CMD nodejs server.js
