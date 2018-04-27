# NodePKI Docker Image

```
_   _           _      ____  _  _____
| \ | | ___   __| | ___|  _ \| |/ /_ _|
|  \| |/ _ \ / _` |/ _ \ |_) | ' / | |
| |\  | (_) | (_| |  __/  __/| . \ | |
|_| \_|\___/ \__,_|\___|_|   |_|\_\___|

By ADITO Software GmbH
```

This Docker container contains the following components:
* [NodePKI API Server](https://github.com/aditosoftware/nodepki/)
* [NodePKI Webclient](https://github.com/aditosoftware/nodepki-webclient/)
* [NodePKI reference CLI client](https://github.com/aditosoftware/nodepki-client/)

## Installation

* Install docker-engine: https://docs.docker.com/engine/installation/linux/ubuntu/
* Download and install docker-compose: https://docs.docker.com/compose/install/
* Download this Git repo:

```
git clone https://github.com/aditosoftware/nodepki-docker.git
cd nodepki-docker
```


## Build Docker image

    sudo docker-compose build

These commands will download NodePKI and NodePKI-Client from GitHub and build the container image.


## Configure docker container environment

Set

* API_USERNAME and
* API_PASSWORD

variables in docker-compose.yml. A initial user account for API access will be created with these login credentials.


## Create configuration files

To create the persistent config files, run the following command:

    sudo docker-compose run nodepki /bin/sh /opt/nodepki/setup.sh


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
            domain: ca.adito.local
            port: 2560


Configure OCSP and CRL URLs:

    ca:
        intermediate:
            ocsp:
                url: "http://ca.adito.local/ocsp"
            crl:
                url: "http://ca.adito.local/public/ca/intermediate/crl"

Both URLs correspond to the public URLs as they are defined in the HTTP reverse proxy (See Nginx config). Webbrowsers will use these URLs to check certificate validity.


**Do not forget to change the CA passphrases! (default: yyyy)**

Change the remaining settings according to your needs.


## First start

Start NodePKI for the first time by executing

    sudo docker-compose up

Your CA will be created on the first startup. You can stop the container again by pressing CTRL+C

You should now backup your configuration files and PKI by copying the data/ directory on the host. This is where the important data lives.


## Configure Nginx proxy

Use an external Nginx reverse proxy server to make URLs nice and to offer TLS encryption.

    ###
    ### NodePKI API server (unencrypted)
    ###

    server {
        listen 80;
        server_name ca.adito.local;

        location = / {
                rewrite ^ https://ca.adito.local/webclient/ permanent;
        }

        location /api {
                rewrite ^ https://$host$request_uri? permanent;
        }

        location /public {
                proxy_pass http://nodepki:8080/public;
        }

        location /ocsp {
                proxy_pass http://nodepki:2560;
        }

        location /webclient/ {
                rewrite ^ https://$host$request_uri? permanent;
        }
    }


    ###
    ### NodePKI API server (encrypted)
    ###

    server {
        listen 443 ssl;
        server_name ca.adito.local;

        ssl_certificate /etc/nginx/certs/ca.adito.local.crt;
        ssl_certificate_key /etc/nginx/certs/ca.adito.local.key;

        location = / {
                rewrite ^ https://ca.adito.local/webclient/ permanent;
        }

        location /api {
                proxy_pass http://nodepki:8080/api;
        }

        location /public {
                proxy_pass http://nodepki:8080/public;
        }

        location /webclient/ {
                proxy_pass http://nodepki:5000/;
        }
    }


* api.cert.pem and api.key.pem are the certificate files from the host directory ./data/nodepki/mypki/apicert/
* "nodepki" resolves to the NodePKI docker container, which exposes ports 8080, 5000 and 2560.

Fit the above Nginx configuration to your environment.


## Start Docker container

    sudo docker-compose up

You can start the container in background mode by attaching the ``` -d``` flag


### Stop Docker container

    sudo docker-compose stop


## Using the integrated Web-based GUI client "NodePKI Webclient"

Visit https://ca.adito.local/webclient/ and login with the account which was created via the docker-compose environment variables in the beginning.



## Using the integrated CLI client

(in another shell instance)

    sudo docker-compose exec nodepki /bin/sh
    cd ../nodepki-client/
    node client

Request a certificate

    node client request --out out/

The created cert.pem and key.pem are located in the "certs" directory on the host and in the "out" directory in the container. For further information see [NodePKI-Client README](https://github.com/ThomasLeister/nodepki-client/blob/master/README.md).


## Using an external CLI client

You can use external [NodePKI-Client](https://github.com/ThomasLeister/nodepki-client/) instances to retrieve certificates by adding another API user account. The external client must be configured to send requests to the container host.


### Setting up secure API access

**Configure client** to use TLS: (data/nodepki-client/config/config.yml):

    server:
        hostname: ca.adito.local
        port_plain: 80
        port_tls: 443
        tls: true


## Exposed ports and volumes

Ports:
* 8080 (API + HTTP server for certificate and CRL retrieval)
* 2560 (OCSP server)
* 5000 (NodePKI Webclient - HTTP)

Volumes:
* data: Contains persistent container data (mounted to /opt/nodepki/nodepki/data/ and /opt/nodepki/nodepki-client/data/)
* certs: Can be used to transfer and store cert files. (mounted to /opt/nodepki/nodepki-client/out/)


## Add new API user

    sudo docker-compose run nodepki node /opt/nodepki/nodepki/nodepkictl.js useradd --username user1 --password password


## CLI client Examples

### Certificate for Nginx Webserver

Request root certificate for browser import:

    node client getcacert --ca root --out out/root.cert.pem

Import this file into your webbrowser.

Request new webserver certificate:

    node client request --type server --out out/ --fullchain

(Use domain name as commonName)

Certificates are in certs/[uuid]/ on your host machine. Copy them to your webserver:

    sudo cp key.pem /etc/nginx/myssl/cert.key.pem
    sudo cp cert.pem /etc/nginx/myssl/fullchain.pem

Reload webserver:

    sudo systemctl restart nginx


### OpenVPN certificates

#### For server

Get intermediate certificate + root certificate

    node client getcacert --ca intermediate --chain --out out/intermediate.cert.pem

Create Server certificate and key

    node client request --type server --fullchain --out out/

(Use VPN domain name as common name)
[uuid]/cert.pem and [uuid]/key.pem are server cert and key.


#### For client

Get Root cert for client

    node client getcacert --ca root --out out/root.cert.pem

Get Client certificate and key ...

    node client request --type client --out out/


## Import Root CA certificate on Linux and Windows

See this repo for more information on how to get things working :-) https://github.com/ThomasLeister/root-certificate-deployment
