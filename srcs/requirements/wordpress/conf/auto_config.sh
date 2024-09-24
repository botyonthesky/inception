#!/bin/sh

# sleep for check if mariaDB is correctly launch
sleep 10

# check if the file already exists
if [ ! -e /var/www/wordpress/wp-config.php ]; then
	wp config create --allow-root \
				--dbname=$SQL_DATABASE \
				--dbuser=$SQL_USER \
				--dbpass=$SQL_PASSWORD \
				--dbhost=mariadb:3306 \
				--path='/var/www/wordpress'

# config of worldpress with info store in .env
wp core install --url=$DOMAIN_NAME \
				--title=$SITE_TITLE \
				--admin_user=$ADMIN_USER \
				--admin_password=$ADMIN_PASS \
				--admin_email=$ADMIN_EMAIL \
				--allow-root \
				--path='/var/www/wordpress'

# creation of the second user (root for publish ang manage his own article) with info store un .env
wp user create	--alow-root --role=author $USER1_LOGIN $USER1_EMAIL \
				--user_pass=$USER1_PASS \
				--path='/var/www/wordpress'
fi

# if run/php does not exist, we create it
if [ ! -d /run/php]; then
	mkdir ./run/php
fi

# execute the process PHP-FPM, -F : mode "forground"(premierplan)
/usr/sbin/php-fpm7.3 -F