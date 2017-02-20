# NodePKI Docker Image

```   
_   _           _      ____  _  _____
| \ | | ___   __| | ___|  _ \| |/ /_ _|
|  \| |/ _ \ / _` |/ _ \ |_) | ' / | |
| |\  | (_) | (_| |  __/  __/| . \ | |
|_| \_|\___/ \__,_|\___|_|   |_|\_\___|

By ADITO Software GmbH
```

This Docker container contains the [NodePKI API Server](https://github.com/aditosoftware/nodepki/) as well as the [NodePKI reference client](https://github.com/aditosoftware/nodepki-client/).

## Installation

* Install docker-engine: https://docs.docker.com/engine/installation/linux/ubuntu/
* Download and install docker-compose: https://docs.docker.com/compose/install/
* Download this Git repo:

```
git clone git@github.com:aditosoftware/nodepki-docker.git
cd nodepki-docker
```


## Build Docker image

    sudo docker-compose build

These commands will download NodePKI and NodePKI-Client from GitHub and build the container image.


## Configure docker container environment

Set API_USERNAME and API_PASSWORD variables in docker-compose.yml. These initial credentials will be used to access the NodePKI-API.


## Create configuration files

To create the persistent config files, run the following command:

    sudo docker-compose run nodepki bash /root/setup.sh


## Configure NodePKI and NodePKI-Client

Now configure NodePKI and NodePKI-Client by editing the config.yml files in data/[nodepki/nodepki-client]/config/ on the host.

**Note: PKI settings such as CRL URL, OCSP server URL and CA data cannot be changed during usage! Once you've set these attributes and started using your CA, they will be kept until you create a complete new PKI! Think well about your CA configuration!**

Set domains and urls in data/nodepki/config/config.yml:

    server:
        ip: 0.0.0.0
        http:
            domain: ca.adito.local
            port: 8080
        ocsp:
            domain: ocsp.adito.local
            port: 2560

```
ca > intermediate > ocsp > url: "http://ocsp.adito.local"
ca > intermediate > crl > url: "http://ca.adito.local/public/intermediate.crl.pem"
```

## Configure Nginx proxy

Nginx makes URLs nice and does the TLS / HTTPS job for us.

    server {
        listen 80;
        server_name ca.adito.local;

        location /api {
                rewrite ^ https://$host$request_uri? permanent;
        }

        location /public {
                proxy_pass http://localhost:8080/public;
        }
    }

    server {
        listen 443 ssl;
        server_name ca.adito.local;

        ssl_certificate /etc/nginx/myssl/api.cert.pem;
        ssl_certificate_key /etc/nginx/myssl/api.key.pem;

        location /api {
                proxy_pass http://localhost:8080/api;
        }

        location /public {
                proxy_pass http://localhost:8080/public;
        }
    }

    server {
        listen 80;
        server_name ocsp.adito.local;

        location / {
                proxy_pass http://localhost:2560;
        }
    }

api.cert.pem and api.key.pem are the certificate files from the host directory data/nodepki/mypki/apicert/


## Create CA

When your configuration is finished, create your CA:

    sudo docker-compose run nodepki nodejs /root/nodepki/genpki.js

You should now backup your configuration files and PKI by copying the data/ directory on the host.


## Start Docker container

    sudo docker-compose up


## Using the integrated client

(in another shell instance)

    sudo docker-compose exec nodepki bash
    cd ../nodepki-client/
    nodejs client

Request a certificate

    nodejs client request --out out/

The created cert.pem and key.pem are located in the "certs" directory on the host and in the "out" directory in the container. For further information see [NodePKI-Client README](https://github.com/ThomasLeister/nodepki-client/blob/master/README.md).


## Using an external client

You can use external [NodePKI-Client](https://github.com/ThomasLeister/nodepki-client/) instances to retrieve certificates by adding another API user account. The external client must be configured to send requests to the container host.

### Setting up secure API access

**Configure client** to use TLS: (data/nodepki-client/config/config.yml):

    server:
        hostname: ca.adito.local
        port_plain: 80
        port_tls: 443
        tls: true


### Add new API user

    sudo docker-compose run nodepki nodejs /root/nodepki/nodepkictl.js useradd --username user1 --password pass

### Remove API user

    sudo docker-compose run nodepki nodejs /root/nodepki/nodepkictl.js userdel --username user1



## Exposed ports and volumes

Ports:
* 8080 (API + HTTP server for certificate and CRL retrieval)
* 2560 (OCSP server)

Volumes:
* data: Contains persistent container data (mounted to /root/nodepki/data/ and /root/nodepki-client/data/)
* certs: Can be used to transfer and store cert files. (mounted to /root/nodepki-client/out/)



## Examples

### Certificate for Nginx Webserver

Request root certificate for browser import:

    nodejs client getcacert --ca root --out out/root.cert.pem

Import this file into your webbrowser.

Request new webserver certificate:

    nodejs client request --type server --out out/ --fullchain

(Use domain name as commonName)

Certificates are in certs/[uuid]/ on your host machine. Copy them to your webserver:

    sudo cp key.pem /etc/nginx/myssl/cert.key.pem
    sudo cp cert.pem /etc/nginx/myssl/fullchain.pem

Reload webserver:

    sudo systemctl restart nginx



### OpenVPN certificates

#### For server

Get intermediate certificate + root certificate

    nodejs client getcacert --ca intermediate --chain --out out/intermediate.cert.pem

Create Server certificate and key

    nodejs client request --type server --fullchain --out out/

(Use VPN domain name as common name)
[uuid]/cert.pem and [uuid]/key.pem are server cert and key.


#### For client

Get Root cert for client

    nodejs client getcacert --ca root --out out/root.cert.pem

Get Client certificate and key ...

    nodejs client request --type client --out out/
