# Variables
COMPOSE = docker compose -f srcs/docker-compose.yaml
PROJECT_NAME = inception

# Build and start the containers
up:
	@echo "building containers from $(Project_NAME)"
	@mkdir -p /home/cofische/data/mariadb
	@mkdir -p /home/cofische/data/wordpress
	@$(COMPOSE) -p $(PROJECT_NAME) up --build -d

# Stop and remove the containers
stop:
	@echo "stopping containers from $(Project_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) stop

# Restart the services
restart: down up
	@echo "restarting containers from $(Project_NAME)"

# Show running containers
ps:
	@echo "showing running containers"
	@$(COMPOSE) -p $(PROJECT_NAME) ps

# View logs of services
logs:
	@echo "showing containers' logs"
	@$(COMPOSE) -p $(PROJECT_NAME) logs -f

# Run a shell inside the Nginx container
sh-nginx:
	@echo "accessing nginx"
	@docker exec -it nginx bash

sh-db:
	@echo "accessing mariadb"
	@docker exec -it mariadb bash

sh-wp:
	@echo "accessing wordpress"
	@docker exec -it wordpress bash

# Clean unused images and containers
clean:
	@echo "removing containers from $(Project_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) down

fclean: clean
	@echo "removing containers' unused images and cleaning volumes"
	@rm -rf /home/cofische/data/*
	@docker system prune -a --volumes -f

.PHONY: up down stop restart ps logs sh-nginx sh-db sh-wp clean fclean