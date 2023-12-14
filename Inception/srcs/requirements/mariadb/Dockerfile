FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server mariadb-client sudo openssl 
RUN mkdir -p /run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld; chown -R mysql:mysql /var/lib/mysql

COPY ./conf/conf.cnf /etc/mysql/my.cnf
COPY ./conf/conf.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY ./tools/scripts/scripts.sh .
COPY ./tools/wordpress.sql .



RUN chmod +x scripts.sh

ENTRYPOINT ["/bin/bash", "scripts.sh"]