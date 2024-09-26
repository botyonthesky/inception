#FROM : Witch OS to run
FROM debian:buster

# like usual
RUN apt-get update && apt-get upgrade -y

# install wget for WP
RUN apt-get -y install wget 

# install php7.3 with dependencies for WP
RUN apt-get install -y php7.3\
		php-fpm\
		php-mysql\
		mariadb-client

# use wget for WP install, -P for location ("/var/www" use in NGINX)
RUN wget https://fr.wordpress.org/wordpress-6.6.2-fr_FR.tar.gz -P /var/www

# go on dir and decompress it
RUN cd /var/www && tar -xzf wordpress-6.6.2-fr_FR.tar.gz && rm wordpress-6.6.2-fr_FR.tar.gz

# copy of php conf
COPY ./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf

# give privileges to root for write in the dir
RUN chown -R root:root /var/www/wordpress

# install the CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# give the right
RUN chmod +x wp-cli.phar

# move into /bin
RUN mv wp-cli.phar /usr/local/bin/wp

# copy of .sh
COPY ./conf/auto_config.sh auto_config.sh

# execute auto-config 
ENTRYPOINT ["bash", "auto_config.sh"]