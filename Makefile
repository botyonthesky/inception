# Variables
DOCKER_COMPOSE = sudo docker-compose -f srcs/docker-compose.yml
PROJECT_NAME = inception

# Default target
.PHONY: all
all: up

# Build the Docker images
.PHONY: build
build:
	mkdir -p /home/tmaillar/data/mariadb
	mkdir -p /home/tmaillar/data/wordpress
	$(DOCKER_COMPOSE) build

# Start the Docker Compose services
.PHONY: up
up:
	$(DOCKER_COMPOSE) up -d

# Stop the Docker Compose services
.PHONY: down
down:
	$(DOCKER_COMPOSE) down

# Restart the Docker Compose services
.PHONY: restart
restart: down up

# View the logs of the Docker Compose services
.PHONY: logs
logs:
	$(DOCKER_COMPOSE) logs

# Clean up Docker Compose services and volumes
.PHONY: clean
clean:
	$(DOCKER_COMPOSE) down -v
	sudo rm -rf /home/tmaillar/data/mariadb
	sudo rm -rf /home/tmaillar/data/wordpress

# Remove all containers, networks, and images
.PHONY: prune
prune:	down
	@if [ -n "$$(sudo docker ps -aq)" ]; then sudo docker rm -vf $$(sudo docker ps -aq); fi
	@if [ -n "$$(sudo docker images -aq)" ]; then sudo docker rmi -f $$(sudo docker images -aq); fi
	sudo docker network prune
	sudo docker system prune -a -f

# Show the status of the Docker Compose services
.PHONY: status
status:
	$(DOCKER_COMPOSE) ps

# Execute a shell in the nginx container
.PHONY: shell-nginx
shell-nginx:
	$(DOCKER_COMPOSE) exec nginx /bin/sh -c "trap 'echo Session ended' EXIT; exec /bin/sh"

# Execute a shell in the wordpress container
.PHONY: shell-wordpress
shell-wordpress:
	$(DOCKER_COMPOSE) exec wordpress /bin/sh -c "trap 'echo Session ended' EXIT; exec /bin/sh"

# Execute a shell in the mariadb container
.PHONY: shell-mariadb
shell-mariadb:
	$(DOCKER_COMPOSE) exec mariadb /bin/sh -c #"trap 'echo Session ended' EXIT; exec /bin/sh"
