# NodePKI API server Docker Image

## Installation

* Install docker-engine: https://docs.docker.com/engine/installation/linux/ubuntu/
* Download and install docker-compose: https://docs.docker.com/compose/install/
* Download this Git repo

```
git clone git@github.com:ThomasLeister/nodepki-docker.git
cd nodepki-docker
```

## Configure docker image

Set API_USERNAME and API_PASSWORD variables in docker-compose.yml. These credentials will be used to access the NodePKI-API.


## Build Docker image

    chmod u+x prepare.sh
    ./prepare.sh
    sudo docker-compose build

These commands will download NodePKI and NodePKI-Client from GitHub and build the container image.


## Prepare container and create persistent data

To create the persistent config files, run the following command:

    sudo docker-compose run nodepki /bin/bash /root/setup.sh


## Configure NodePKI and NodePKI-Client

Now configure NodePKI and NodePKI-Client by editing the config.yml files in data/[nodepki/nodepki-client]/config/ on the host.


## Create CA

When you are ready, create your CA:

    sudo docker-compose run nodepki nodejs /root/nodepki/genpki.js

You should now backup your configuration files and PKI by copying the data/ directory on the host.


## Start Docker container

    sudo docker-compose up


## Use integrated client

(in another shell instance)

    sudo docker-compose exec nodepki /bin/bash
    cd ../nodepki-client/
    nodejs client

Request a certificate

    nodejs client request --out out/

The created cert.pem and key.pem are located in the "certs" directory on the host and in the "out" directory in the container. For further information see [NodePKI-Client README](https://github.com/ThomasLeister/nodepki-client/blob/master/README.md).


## Use external client

You can use external [NodePKI-Client](https://github.com/ThomasLeister/nodepki-client/) instances to retrieve certificates by adding another API user account. The external client must be configured to send requests to the container host.

### Add new API user

    sudo docker-compose run nodepki nodejs /root/nodepki/nodepkictl.js useradd --username user1 --password pass

### Remove API user

    sudo docker-compose run nodepki nodejs /root/nodepki/nodepkictl.js userdel --username user1



## Exposed ports and volumes

Ports:
* 8080 (Public HTTP)
* 8081 (API)
* 2561 (OCSP server)

Volumes:
* data: Contains persistent container data (mounted to /root/nodepki/data/ and /root/nodepki-client/data/)
* certs: Can be used to transfer and store cert files. (mounted to /root/nodepki-client/out/)
