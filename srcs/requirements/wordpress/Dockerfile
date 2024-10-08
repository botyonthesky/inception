#FROM : Witch OS to run
FROM alpine:3.19

# Update alpine
# curl: for download WP-CLI
# php-fpm: Extension for nginx server
# php-curl: Extension php for HTTP request via curl
# php-mysql: Extension php for MariaDB/mySQL
# php-phar : Extension php for php archive (wp-cli)
# php-mbstrring : Extension php for web site multilingual
RUN apk update && apk add --no-cache \
	curl \
	mariadb-client \
	php \
	php-fpm \
	php-curl \
	php-mysqli \
	php-phar \
	php-mbstring


# Creates the directories needed to host WordPress and PHP-FPM
RUN mkdir -p /var/www/wordpress /run/php

# Use curl for download WP-CLI (+ add permissions)
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Creates a system group (-S option) named nginx. 
# Groups are used to define shared permissions between users.
RUN addgroup -S nginx && adduser -S nginx -G nginx

#Configure php-fpm
RUN sed -i 's/listen = 127.0.0.1:9000/listen = wordpress:9000/' /etc/php82/php-fpm.d/www.conf

# Expose port
EXPOSE 9000

# Copy the custom initialization script to handle environment variables
COPY conf/auto_config.sh /usr/local/bin/

# Ensure the script is executable
RUN chmod +x /usr/local/bin/auto_config.sh

# Start wordpress with initialization script
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

# Start PHP-FPM
CMD ["php-fpm82", "-F"]
