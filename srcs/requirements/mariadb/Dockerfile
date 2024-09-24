#FROM : Witch OS to run
FROM debian:buster

# update and install mariadb
RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

# storage of mariabd config
COPY conf/50-server.conf /etc/mysql/mariabd.conf.d/50.server.conf