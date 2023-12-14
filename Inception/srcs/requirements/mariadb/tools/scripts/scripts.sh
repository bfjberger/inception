#!/bin/sh

# init Mariadb data directory
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# start mariadb in the background
mysqld --user=mysql --datadir=/var/lib/mysql &

mysql_pid=$!

# Wait for MariaDB to become available
until mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} ping >/dev/null 2>&1; do
    sleep 1
done

ADMIN_PASSWORD=$(openssl passwd -1 "$WP_ADMIN_PASSWORD" | sed 's/\//\\\//g')
PASSWORD=$(openssl passwd -1 "${WP_USER_PASSWORD}" | sed 's/\//\\\//g')

sed -i "s/{WP_ADMIN}/${WP_ADMIN}/g" wordpress.sql
sed -i "s/{WP_ADMIN_PASSWORD}/${ADMIN_PASSWORD}/g" wordpress.sql
sed -i "s/{WP_ADMIN_EMAIL}/${WP_ADMIN_EMAIL}/g" wordpress.sql
sed -i "s/{WP_ADMIN_URL}/${WP_ADMIN_URL}/g" wordpress.sql

sed -i "s/{WP_USER_NAME}/${WP_USER_NAME}/g" wordpress.sql
sed -i "s/{WP_USER_PASSWORD}/${PASSWORD}/g" wordpress.sql
sed -i "s/{WP_EMAIL}/${WP_EMAIL}/g" wordpress.sql
sed -i "s/{WP_USER_LOGIN}/${WP_USER_LOGIN}/g" wordpress.sql
# sed -i "s/{WP_URL}/${WP_URL}/g" wordpress.sql

# Run SQL commands
sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} inception -e "SELECT COUNT(id) FROM wp_users;" > /dev/null

if [ $? -ne 0 ]; then
         sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} $MYSQL_DATABASE < wordpress.sql
fi

kill "$mysql_pid"

# Wait for the MariaDB process to stop completely
wait "$mysql_pid"

# Start MariaDB in the foreground
exec mysqld --user=mysql