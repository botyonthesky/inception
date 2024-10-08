#!/bin/sh

#check if the directory exist
if [ ! -d "var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo "Start temporary MariaDB server, without networking (to avoid external connections)"
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &

echo "Waiting  for MariaDB...."

# Configuration of the maximum number of attempts to connect to MariaDB
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

# Checks whether the SQL user defined already exists in the MariaDB database.
# This SQL query checks whether a user with the name `${SQL_USER}` exists in the `mysql.user` table.

if [ $(echo "SELECT COUNT(*) FROM mysql.user WHERE user = '${SQL_USER}'" | mysql -u root | tail -n1) -eq 0 ]; then
	echo "Set root user and Database"
	mariadb -u root <<-EOSQL

	 -- Temporarily disable the binary log (useful in replication environments)
	SET @@SESSION.SQL_LOG_BIN=0;

	 -- Delete users without usernames (default users are often useless)
	DELETE FROM mysql.user WHERE User='';

	-- Create database and user if they dont exist
	CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;

	-- Create the SQL user defined by the environment variables, if it does not already exist
	CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';

	-- Grant all database privileges to this user
	GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';

	 -- Force reloading of privileges for changes to take effect
	FLUSH PRIVILEGES;

	EOSQL
	if [ $? -ne 0 ]; then
		echo "Error on database setup"
		exit 1
	fi;
fi;

# Stop the temporary MariaDB server once configuration is complete
echo "Shutdown temporary MariaDB server"
mysqladmin shutdown -u root
echo "MariaDB setup completed"

# Start MariaDB normally
exec "$@"
