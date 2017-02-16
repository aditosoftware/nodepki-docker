#!/bin/bash

### Configure client
cd /root/nodepki-client
cp config.default.yml config/config.yml

echo "Setting API credentials: ${API_USERNAME} ${API_PASSWORD}"
sed -ie "s/api_username/$API_USERNAME/" config/config.yml
sed -ie "s/api_password/$API_PASSWORD/" config/config.yml



## Create PKI
cd /root/nodepki
cp config.default.yml config/config.yml
nodejs genpki.js
nodejs nodepkictl useradd --username $API_USERNAME --password $API_PASSWORD
