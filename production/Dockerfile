FROM node:9.11.1-alpine

RUN apk add --no-cache \
    openssl \
    curl \
    supervisor

WORKDIR /opt
RUN curl -L https://github.com/aditosoftware/nodepki/archive/master.tar.gz | tar xz && mv nodepki-master nodepki \
  && curl -L https://github.com/aditosoftware/nodepki-client/archive/master.tar.gz | tar xz && mv nodepki-client-master nodepki-client \
  && curl -L https://github.com/aditosoftware/nodepki-webclient/archive/master.tar.gz | tar xz && mv nodepki-webclient-master nodepki-webclient \
  && cd /opt/nodepki-client \
  && npm install \
  && cd /opt/nodepki-webclient \
  && npm install \
  && cd /opt/nodepki \
  && npm install

## Add supervisor config
COPY supervisord.conf /etc/supervisor/supervisord.conf

### Add setup script to create persistent content
COPY docker_entrypoint.sh /opt
RUN chmod +x /opt/docker_entrypoint.sh

#RUN adduser -D -g '' nodepki
#RUN chown -R nodepki:nodepki /opt/nodepki*

EXPOSE 8080 5000 2560

ENTRYPOINT ["/opt/docker_entrypoint.sh"]
