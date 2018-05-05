#!/bin/sh

if [ ! -f /opt/nodepki-client/data/config/config.yml ]; then

  echo ">>>>>> Setting up NodePKI-Client ..."

  cd /opt/nodepki-client/data

  mkdir config/
  cp ../config.default.yml config/config.yml

  sed -e "s/API_USERNAME/$API_USERNAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/API_PASSWORD/$API_PASSWORD/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/CA_API_SERVER_URL/$CA_API_SERVER_URL/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/COUNTRY_CODE/$COUNTRY_CODE/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/STATE_NAME/$STATE_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/LOCALITY_NAME/$LOCALITY_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/ORGANIZATION_NAME/$ORGANIZATION_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/CERT_LIFETIME_IN_DAYS/$CERT_LIFETIME_IN_DAYS/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml

  cd /opt/nodepki-client/

fi

if [ ! -f /opt/nodepki-webclient/data/config/config.yml ]; then

  echo ">>>>>> Setting up NodePKI-Webclient ..."
  cd /opt/nodepki-webclient/data
  mkdir config/
  cp ../config.default.yml config/config.yml

  sed -e "s#CA_WEBCLIENT_HTTP_URL#$CA_WEBCLIENT_HTTP_URL#" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/CA_API_SERVER_URL/$CA_API_SERVER_URL/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/COUNTRY_CODE/$COUNTRY_CODE/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/STATE_NAME/$STATE_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/LOCALITY_NAME/$LOCALITY_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/ORGANIZATION_NAME/$ORGANIZATION_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml

  cd /opt/nodepki-webclient/

fi

if [ ! -f /opt/nodepki/data/config/config.yml ]; then

  echo ">>>>>> Setting up NodePKI ..."

  cd /opt/nodepki/data
  mkdir config/
  cp ../config.default.yml config/config.yml

  sed -e "s/CA_API_SERVER_URL/$CA_API_SERVER_URL/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/CA_OSCP_SERVER_URL/$CA_OSCP_SERVER_URL/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/ROOT_PASSPHRASE/$ROOT_PASSPHRASE/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/INTERMEDIATE_PASSPHRASE/$INTERMEDIATE_PASSPHRASE/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/OCSP_PASSPHRASE/$OCSP_PASSPHRASE/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/CA_CERT_EXPIRE_IN_DAYS/$CA_CERT_EXPIRE_IN_DAYS/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/COUNTRY_CODE/$COUNTRY_CODE/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/STATE_NAME/$STATE_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/LOCALITY_NAME/$LOCALITY_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/ORGANIZATION_NAME/$ORGANIZATION_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/ROOT_CA_COMMON_NAME/$ROOT_CA_COMMON_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/INTERMEDIATE_CA_COMMON_NAME/$INTERMEDIATE_CA_COMMON_NAME/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s#CA_OSCP_SERVER_HTTP_URL#$CA_OSCP_SERVER_HTTP_URL#" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s#CA_CRL_SERVER_HTTP_URL#$CA_CRL_SERVER_HTTP_URL#" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml
  sed -e "s/CERT_LIFETIME_IN_DAYS/$CERT_LIFETIME_IN_DAYS/" config/config.yml > config/config.yml.tmp && mv config/config.yml.tmp config/config.yml

  cd /opt/nodepki/

  node nodepkictl useradd --username $API_USERNAME --password $API_PASSWORD

  echo ">>>>>> Setup finished."

fi

echo ">>>>>> Setting up NodePKI-Client ..."
# Start the application
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
