FROM node:7-alpine

RUN apk add --no-cache \
    openssl \
    curl \
    supervisor

## Add supervisor config
COPY supervisord.conf /etc/supervisor/supervisord.conf

### Add setup script to create persistent content
COPY setup.sh /root/

WORKDIR /root
RUN curl -L https://github.com/aditosoftware/nodepki/archive/master.tar.gz | tar xz && mv nodepki-master nodepki \
&& curl -L https://github.com/aditosoftware/nodepki-client/archive/master.tar.gz | tar xz && mv nodepki-client-master nodepki-client \
&& curl -L https://github.com/aditosoftware/nodepki-webclient/archive/master.tar.gz | tar xz && mv nodepki-webclient-master nodepki-webclient \
&& cd /root/nodepki-client \
&& npm install \
&& cd /root/nodepki-webclient \
&& npm install \
&& cd /root/nodepki \
&& npm install

EXPOSE 8080 5000 2560

### Run everything via supervisor
CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
