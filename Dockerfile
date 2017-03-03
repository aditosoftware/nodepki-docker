FROM ubuntu:xenial

RUN apt update \
    && apt install -y \
        nodejs \
        npm \
        openssl \
        curl \
        supervisor \
    && rm -rf /var/cache/apt

## Add supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

### Add setup script to create persistent content
ADD setup.sh /root/

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
CMD /usr/bin/supervisord
