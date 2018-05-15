FROM node:7-alpine

RUN apk add --no-cache \
    openssl \
    curl \
    supervisor

## Add supervisor config
COPY supervisord.conf /etc/supervisor/supervisord.conf

### Add setup script to create persistent content
RUN mkdir -p /opt/nodepki
COPY setup.sh /opt/nodepki/

WORKDIR /opt/nodepki
RUN curl -L https://github.com/aditosoftware/nodepki/archive/master.tar.gz | tar xz && mv nodepki-master nodepki \
&& curl -L https://github.com/aditosoftware/nodepki-client/archive/master.tar.gz | tar xz && mv nodepki-client-master nodepki-client \
&& curl -L https://github.com/aditosoftware/nodepki-webclient/archive/master.tar.gz | tar xz && mv nodepki-webclient-master nodepki-webclient \
&& cd /opt/nodepki/nodepki-client \
&& npm install \
&& cd /opt/nodepki/nodepki-webclient \
&& npm install \
&& cd /opt/nodepki/nodepki \
&& npm install

RUN adduser -D -g '' nodepki
RUN chown -R nodepki:nodepki /opt/nodepki
USER nodepki

EXPOSE 8080 5000 2560

### Run everything via supervisor
CMD /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
