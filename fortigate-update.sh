#!/bin/bash

FGT_HOST=https://ADMIN_INTERFACE_IP
FGT_SECRET=REST_API_TOKEN

CERTDOM=${CERTBOT_DOMAIN/'*.'/}
CERTNAME="${CERTDOM:-"le-cert"}-$(date +%F)"

PAYLOAD=

if [ -f /etc/letsencrypt/live/"${CERTDOM}"/fullchain.pem ]; then
        if [ -f /etc/letsencrypt/live/"${CERTDOM}"/privkey.pem ]; then
                PAYLOAD="{\"type\":\"regular\",\"scope\":\"global\",\"certname\":\"${CERTNAME}\",\"file_content\":\"$(base64 -w0 /etc/letsencrypt/live/"${CERTDOM}"/fullchain.pem)\",\"key_file_content\":\"$(base64 -w0 /etc/letsencrypt/live/"${CERTDOM}"/privkey.pem)\"}"
        fi
fi

if [ -z "${PAYLOAD}" ]; then
        echo "Cannot read cert files"
        echo "aborting"
        exit 1
fi

curl -k -X POST -H "Authorization: Bearer ${FGT_SECRET}" -d "${PAYLOAD}" ${FGT_HOST}/api/v2/monitor/vpn-certificate/local/import && \
curl -k -X PUT -H "Authorization: Bearer ${FGT_SECRET}" -d "{\"servercert\": \"${CERTNAME}\"}" ${FGT_HOST}/api/v2/cmdb/vpn.ssl/settings
