# Variables
DOCKER_COMPOSE = sudo docker-compose -f srcs/docker-compose.yml
PROJECT_NAME = inception

# Default target
all: up


# Restart the Docker Compose services
restart: down up


# Build the Docker images
build:
	mkdir -p /home/tmaillar/data/mariadb
	mkdir -p /home/tmaillar/data/wordpress
	$(DOCKER_COMPOSE) build


# Start the Docker Compose services
up:
	$(DOCKER_COMPOSE) up -d


# Stop the Docker Compose services
down:
	$(DOCKER_COMPOSE) down


# View the logs of the Docker Compose services
logs:
	$(DOCKER_COMPOSE) logs


# Clean up Docker Compose services and volumes
clean:
	$(DOCKER_COMPOSE) down -v
	sudo rm -rf /home/tmaillar/data/mariadb
	sudo rm -rf /home/tmaillar/data/wordpress


# Remove all containers, networks, and images
prune:	down
	@if [ -n "$$(sudo docker ps -aq)" ]; then sudo docker rm -vf $$(sudo docker ps -aq); fi
	@if [ -n "$$(sudo docker images -aq)" ]; then sudo docker rmi -f $$(sudo docker images -aq); fi
	sudo docker network prune
	sudo docker system prune -a -f


# Show the status of the Docker Compose services
status:
	$(DOCKER_COMPOSE) ps


# Execute a shell in the nginx container
shell-nginx:
	$(DOCKER_COMPOSE) exec nginx /bin/sh -c "trap 'echo Session ended' EXIT; exec /bin/sh"


# Execute a shell in the wordpress container
shell-wordpress:
	$(DOCKER_COMPOSE) exec wordpress /bin/sh -c "trap 'echo Session ended' EXIT; exec /bin/sh"


# Execute a shell in the mariadb container
shell-mariadb:
	$(DOCKER_COMPOSE) exec mariadb /bin/sh -c #"trap 'echo Session ended' EXIT; exec /bin/sh"

# Check TLS
tls:
	openssl s_client -connect tmaillar.42.fr:443 -tls1_2


.PHONY: all build up down restart logs clean prune status shell-nginx shell-wordpress shell-mariadb tls
