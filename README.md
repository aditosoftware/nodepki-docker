# NodePKI API server Docker Image

---

## Installation

* Download and install docker-compose: https://docs.docker.com/compose/install/
* Download this Git repo

    ```
    cd nodepki-docker
    ```

## Build Docker image
(as root)

    docker-compose build

## Prepare Docker image
    docker-compose run nodepki nodejs genpki.js

*Runs ```nodejs genpki.js``` to create new PKI in mypki directory.*

## Start docker container
    docker-compose up
