#!/bin/bash

###  Set up NodePKI-Client
echo ">>>>>> Setting up NodePKI-Client ..."

cd /root/nodepki-client
mkdir data/config
cp config.default.yml data/config/config.yml

echo "Setting API credentials: ${API_USERNAME} ${API_PASSWORD}"
sed -e "s/api_username/$API_USERNAME/" data/config/config.yml > data/config/config.yml.tmp && mv data/config/config.yml.tmp data/config/config.yml
sed -e "s/api_password/$API_PASSWORD/" data/config/config.yml > data/config/config.yml.tmp && mv data/config/config.yml.tmp data/config/config.yml


### Set up NodePKI
echo ">>>>>> Setting up NodePKI ..."

cd /root/nodepki
mkdir data/config
cp config.default.yml data/config/config.yml
nodejs nodepkictl useradd --username $API_USERNAME --password $API_PASSWORD


echo ">>>>>> Setup finished."
