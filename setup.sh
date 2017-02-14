#!/bin/bash

### Create config for nodekpi
cp /root/nodepki/config.default.yml /root/nodepki/config/config.yml

### Create config for nodekpi-client
cp /root/nodepki-client/config.default.yml /root/nodepki-client/config/config.yml

## Create PKI
cd /root/nodepki
nodejs genpki.js
