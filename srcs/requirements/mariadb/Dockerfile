#FROM : Witch OS to run
FROM debian:buster

# update and install mariadb
RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

# storage of mariabd config
COPY conf/my.cnf /etc/mysql/mariabd.conf.d/50-server.cnf

COPY conf/auto_config.sh /auto_config.sh

ENTRYPOINT ["bash", "auto_config.sh"]

EXPOSE 3306