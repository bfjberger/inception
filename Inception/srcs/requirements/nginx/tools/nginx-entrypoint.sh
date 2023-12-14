#!/bin/sh

sed -i "s/{DOMAIN_NAME}/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf

# if [ -z "$(ls -A "/etc/ssl/certs")" ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/ssl/private/nginx-selfsigned.key \
		-out /etc/ssl/certs/nginx-selfsigned.crt \
		-subj "/C=CH/ST=Vaud/L=Lausanne/O=42/OU=42/CN=${DOMAIN_NAME}/emailAddress=${WP_ADMIN_EMAIL}"
# fi

exec "$@"