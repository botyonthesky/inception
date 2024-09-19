#FROM : Witch OS to run
FROM debian:buster

#RUN : 
# update and install nginx and vim
RUN apt update
RUN apt install nginx -y
RUN apt install vim -y
# dir for certif and key
RUN mkdir -p /etc/nginx/ssl
# tool for manage certif ssl (openssl)
RUN apt install openssl -y
# generate certif ssl (tool ssl for certif TSL)
# "req" for auto-sign certif
# "-x509" for certif type
# "-nodes" for certif without password
# "-out" "-keyout" for store certif and key
# "-subj" for pre fill certif info
RUN openssl req -x509 -nodes \
-out /etc/nginx/ssl/inception.crt \
-keyout /etc/nginx/ssl/inception.key \
-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=tmaillar.42.fr/UID=tmaillar"
# dir for store config file de nginx
RUN mkdir -p /var/run/nginx
# COPY : File to copy -> Where to copy
# storage of nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html


#EXPOSE : Port to listen for exe
# EXPOSE

#ENTRYPOINT : The command to run when container start
# ENTRYPOINT

CMD ["nginx", "-g", "daemon off;"]