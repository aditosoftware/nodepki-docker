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
(as root)

    docker-compose build

## Prepare Docker image
*Runs ```nodejs genpki.js``` to create new PKI in mypki directory.*

    docker-compose run nodepki nodejs genpki.js

The mypki directory is available on the host.

## Start docker container
    docker-compose up
