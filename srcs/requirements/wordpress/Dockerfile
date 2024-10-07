FROM alpine:3.19

# Install necessary packages
RUN apk update && apk add --no-cache \
	curl \
	mariadb-client \
	php \
	php-fpm \
	php-curl \
	php-mysqli \
	php-phar \
	php-mbstring


RUN mkdir -p /var/www/wordpress /run/php

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

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
