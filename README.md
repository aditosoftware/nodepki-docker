# NodePKI API server Docker Image

## Installation

* Install docker-engine: https://docs.docker.com/engine/installation/linux/ubuntu/
* Download and install docker-compose: https://docs.docker.com/compose/install/
* Download this Git repo

```
git clone git@github.com:ThomasLeister/nodepki-docker.git
cd nodepki-docker
```

## Build Docker image

    /bin/bash prepare.sh
    sudo docker-compose build

## Prepare container / Create persistent data

    sudo docker-compose run nodepki /bin/bash /root/setup.sh

Creates config/ and mypki/ dir in host directory.

## Start Docker container

    sudo docker-compose up

## Use integrated client

(in another shell instance)

    sudo docker exec -it nodepkidocker_nodepki_1 /bin/bash
    cd ../nodepki-client/
    nodejs client.js
