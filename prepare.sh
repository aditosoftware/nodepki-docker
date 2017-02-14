#!/bin/bash

###
### prepare.sh download current nodekpi and nodepki-client dir from GitHub
### to be able to build docker container via docker-build
###

echo ">>> Preparing NodePKI files ..."

rm -rf nodepki
rm -rf nodepki-client

git clone git@github.com:ThomasLeister/nodepki.git
git clone git@github.com:ThomasLeister/nodepki-client.git

rm -rf nodepki/.git
rm -rf nodepki-client/.git

echo ">>> NodePKI files prepared."
