#!/bin/sh

#check if the directory exist
if [ ! -d "var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo "Start temporary MariaDB server..."
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &

echo "Waiting  for MariaDB...."

MAX_RETRIES=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
	if mariadb -u root -e "SELECT 1" > /dev/null 2>&1; then
		break
	fi
	RETRY_COUNT=$((RETRY_COUNT + 1))
	sleep 1
done

if [ $RETRY -eq $MAX_RETRIES ]; then
	echo "Failed to connect after 10 attemps."
	exit 1
fi

if [ $(echo "SELECT COUNT(*) FROM mysql.user WHERE user = '${SQL_USER}'" | mysql | tail -n1) -eq 0 ]; then
	echo "Set root user and Database"
	mariadb -u root <<-EOSQL
	SET @@SESSION.SQL_LOG_BIN=0;
	DELETE FROM mysql.user WHERE User='';

	-- Create database and user if thew dont exist
	CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
	FLUSH PRIVILEGES;

	EOSQL
	if [ $? -ne 0 ]; then
		echo "Error on database setup"
		exit 1
	fi;
fi;

echo "Shutdown temporary MariaDB server"
mysqladmin shutdown -u root
echo "MariaDB setup completed"

# Start MariaDB normally
exec "$@"
