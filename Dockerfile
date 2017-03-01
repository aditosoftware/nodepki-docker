FROM ubuntu:xenial

RUN apt update && apt install -y \
    nodejs \
    npm \
    openssl \
    curl \
    supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root
RUN curl -L https://github.com/aditosoftware/nodepki/archive/master.tar.gz | tar xz && mv nodepki-master nodepki
RUN curl -L https://github.com/aditosoftware/nodepki-client/archive/master.tar.gz | tar xz && mv nodepki-client-master nodepki-client
RUN curl -L https://github.com/aditosoftware/nodepki-webclient/archive/master.tar.gz | tar xz && mv nodepki-webclient-master nodepki-webclient

### Add setup script to create persistent content
ADD setup.sh /root/

WORKDIR /root/nodepki-client
RUN npm install

WORKDIR /root/nodepki-webclient
RUN npm install

WORKDIR /root/nodepki
RUN npm install

EXPOSE 8080
EXPOSE 5000
EXPOSE 2560

### Run server
CMD /usr/bin/supervisord
