#!/bin/sh

# start mySQL
service mysql start;

# table creation name = SQL_DATABASE who is store in .env
mysql -e "CREATE DATABASE IF NOT EXISTS \ '${SQL_DATABASE}\';"

# user creation with name and pass, who are store in .env
mysql -e "CREATE USER IF NOT EXISTS \'${SQL_USER}\'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"


# give the privileges to this user
mysql -e "GRANT ALL PRIVILEGES ON \'${SQL_DATABASE}\'.* TO \'${SQL_USER}\'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# modif user root with SQL_ROOT_PASSWORD
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWAORD}';"

# refresh
mysql -e "FLUSH PRIVILEGES;"

# shutdown mySQL
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# start in safemode
exec mysald_safe

