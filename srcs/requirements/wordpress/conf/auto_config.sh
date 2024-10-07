#!/bin/sh

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	cd /var/www/wordpress
	wp core download --allow-root

	MAX_RETRIES=10
	RETRY_COUNT=0

	while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
		if mysqladmin --user=${SQL_USER} --password=${SQL_PASSWORD} --host=mariadb ping; then
			break
		fi
		RETRY_COUNT=$((RETRY_COUNT + 1))
		sleep 2
	done

	if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
		echo "Failed to connect to MariaDB after $MAX_RETRIES attempts."
		exit 1
	fi

	wp config create	--dbname=${SQL_DATABASE} \
						--path="/var/www/wordpress" \
						--dbuser=${SQL_USER} \
						--dbpass=${SQL_PASSWORD} \
						--dbhost=${WORDPRESS_DB_HOST} \
						--dbprefix="wp_" \
						--skip-check \
						--force \
						--allow-root \

	wp core install		--url=${DOMAIN_NAME} \
						--path="/var/www/wordpress" \
						--title=${SITE_TITLE} \
						--admin_user=${WORDPRESS_ADMIN_USER} \
						--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
						--admin_email=${WORDPRESS_ADMIN_EMAIL} \
						--skip-email \
						--allow-root

	wp user create ${WORDPRESS_USER1} ${WORDPRESS_USER1_EMAIL} \
						--role=author \
						--user_pass=${WORDPRESS_USER1_PASSWORD} \
						--allow-root
fi;

exec "$@"
