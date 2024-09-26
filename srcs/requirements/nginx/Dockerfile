#FROM : Witch OS to run
FROM debian:buster

# update and install nginx and vim
RUN apt update && apt upgrade -y
RUN apt install nginx -y
# RUN apt install vim -y

# tool for manage certif ssl (openssl)
RUN apt install openssl -y

# dir for certif and key
RUN mkdir -p /etc/nginx/ssl

# generate certif ssl (tool ssl for certif TSL)
# "req" for auto-sign certif
# "-x509" for certif type
# "-nodes" for certif without password
# "-out" "-keyout" for store certif and key
# "-subj" for pre fill certif info
RUN openssl req -newkey rsa:4096 -days 365 -x509 -nodes \
-out /etc/nginx/ssl/inception.crt \
-keyout /etc/nginx/ssl/inception.key \
-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=tmaillar.42.fr/UID=tmaillar"

# dir for store config file de nginx
# RUN mkdir -p /var/run/nginx

# storage of nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# rights for root and main user
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html


# command to execute when docker is launch.
# -g: config directives to nginx.
# daemon off: not exe on daemon mode, it will execute nginx on foreground, run in the same process as docker
CMD ["nginx", "-g", "daemon off;"]