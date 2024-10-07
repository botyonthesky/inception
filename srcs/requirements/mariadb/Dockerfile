#FROM : Witch OS to run
FROM alpine:3.19

# update and install mariadb
RUN apk update && apk --no-cache add mariadb mariadb-client mariadb-server-utils


RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql 

COPY conf/my.cnf /etc/my.cnf

#RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

EXPOSE 3306

COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

RUN chmod +x /usr/local/bin/auto_config.sh

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--console"] 


