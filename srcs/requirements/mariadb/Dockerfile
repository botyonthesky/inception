#FROM : Witch OS to run
FROM alpine:3.19

# Update packages and install MariaDB, MariaDB client and MariaDB server utilities
RUN apk update && apk --no-cache add mariadb mariadb-client mariadb-server-utils

# Creates the directories needed for MariaDB and assigns rights to the 'mysql' user
RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql 

# Copies the custom configuration file my.cnf into the container
COPY conf/my.cnf /etc/my.cnf

# Initialization of the MariaDB data directory without the default test database
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

# Exposes port 3306 to allow connections to MariaDB from outside the container
EXPOSE 3306

# Copies an automatic configuration script into the container
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh

# Make the script executable
RUN chmod +x /usr/local/bin/auto_config.sh

# Declares the script as an entrypoint which will be executed when the container starts up
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

# Default command: Starts the MariaDB server with the 'mysql' user and redirects the logs to the console
CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--console"] 


