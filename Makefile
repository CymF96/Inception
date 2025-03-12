# Variables
COMPOSE = docker-compose -f requirements/docker-compose.yaml
PROJECT_NAME = Inception

# Default target: Run everything
all: up

# Build and start the containers
up:
	@echo "building containers from $(Project_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) up --build -d

# Stop and remove the containers
down:
	@echo "removing containers from $(Project_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) down

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

# Clean unused images and containers
clean:
	@echo "removing containers' unused images"
	@docker system prune -af

# Run a shell inside the Nginx container
sh:
	@docker exec -it nginx sh

