FROM debian:buster

RUN apt-get update -y

RUN apt-get install -y curl && \
    curl https://wordpress.org/latest.zip -o wordpress.zip &&\
    apt-get install unzip -y && \
    unzip wordpress.zip && \
    mkdir -p /var/www

RUN rm -rf /var/www/html && \
    mv wordpress /var/www/html

COPY ./conf/wp-config-docker.php /var/www/html/wp-config.php

RUN apt-get install -y sudo wget
RUN sudo apt update

RUN sudo apt install -y gnupg2 ca-certificates apt-transport-https software-properties-common 

RUN wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -

RUN echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list

RUN apt-get update -y 
RUN apt-get install -y php8.0 php8.0-fpm php8.0-cli php8.0-mysql php8.0-xdebug
RUN service php8.0-fpm start; service php8.0-fpm status
COPY /conf/wordpress.conf /etc/php/8.0/fpm/pool.d/www.conf

COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN  chmod -R 777 /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]

# CMD service php8.0-fpm start

CMD ["php-fpm8.0", "-F"]