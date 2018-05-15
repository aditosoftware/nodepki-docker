# NodePKI Docker Image - productive usage

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
* [Traefik loadbalancer](https://traefik.io/)

## Installation

### Setup limitations
- The example setup from the `docker-compose.yml` file does also use a Traefik load balancing service. Remove this service (`traefik`) and publish the ports `8080:8080`, `2560:2560` and `5000:5000` if you would like to access `nodepki` directly.
- Traefik only serves `http` to ease the setup process. Switch to `https` for productive usage!
- The `docker-compose.yml` file works with variable substitution. It's therefore required to start this setup by using Docker Compose. If the `docker-compose.yml` file is used for Docker Swarm Stacks, replace the variables (e.g. `${CA_API_SERVER_URL}`) with real values.
- Set `CA_API_SERVER_PLAIN_PORT` to `80` and `CA_API_SERVER_TLS_ENABLED` to `false` if you are running nodepki behind a reverse proxy which handles the SSL/TLS termination. 

### Prerequisites

Required files and directories (change the base path `/opt/data` according to your setup):
```bash
cd production/
cp .env.tmpl .env

sudo mkdir -p /opt/data/nodepki
sudo mkdir -p /opt/data/nodepki-client
sudo mkdir -p /opt/data/nodepki-webclient
sudo mkdir -p /opt/data/nodepki-certs
```

Now you need to set/change the app variables inside `.env`.

Required host files entries for local development setups:
```bash
127.0.0.1 admin-ca.example.com ca.example.com ocsp.example.com
```
**Notice**: Adjust your `/etc/hosts` entries according to your values inside `.env`.

### Start up
```bash
docker-compose up
```

### Clean up
```bash
docker-compose down
rm -rf /opt/data/nodepki*/*
```
