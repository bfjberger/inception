FROM debian:buster

RUN apt-get update && apt-get install -y nginx openssl

COPY /conf/nginx.conf /etc/nginx/nginx.conf
COPY /conf/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY /conf/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

COPY /tools/nginx-entrypoint.sh /
RUN chmod +x /nginx-entrypoint.sh
ENTRYPOINT [ "/nginx-entrypoint.sh" ]



EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]

