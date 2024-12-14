# Makefile for Docker Compose Project

# Color definitions
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RED = \033[0;31m
NC = \033[0m # No Color

# Docker and project configuration
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

# Volume and environment paths
VOLUME_DIR = ${HOME}/data
WORDPRESS_VOLUME = ${VOLUME_DIR}/wordpress
MARIADB_VOLUME = ${VOLUME_DIR}/mariadb
ADMINER_VOLUME = ${VOLUME_DIR}/adminer

VENV_DIR = .venv
PIP = $(VENV_DIR)/bin/pip
PYTHON = $(VENV_DIR)/bin/python

DOTENV_FILE = srcs/.env
CERTS_DIR = srcs/requirements/nginx/conf/certs

# Ensure required directories exist
$(shell mkdir -p $(WORDPRESS_VOLUME) $(MARIADB_VOLUME) $(ADMINER_VOLUME) $(CERTS_DIR))

# Help target to display usage information
.PHONY: help
help:
	@echo "$(BLUE)Makefile Commands:$(NC)"
	@echo "  $(GREEN)all$(NC)       : Setup environment, build, and start all services"
	@echo "  $(GREEN)build$(NC)     : Build Docker images for all services"
	@echo "  $(GREEN)up$(NC)        : Start Docker services"
	@echo "  $(GREEN)down$(NC)      : Stop Docker services"
	@echo "  $(GREEN)clean$(NC)     : Remove all Docker containers, volumes, networks, and virtual environment"
	@echo "  $(GREEN)logs$(NC)      : Display continuous logs for all services"
	@echo "  $(GREEN)restart$(NC)   : Restart all services"
	@echo "  $(GREEN)status$(NC)    : Show the status of all services"
	@echo "  $(GREEN)setup$(NC)     : Set up environment and generate SSL certificates"
	@echo "  $(GREEN)prune$(NC)     : Remove all unused Docker resources"
	@echo "  $(GREEN)help$(NC)      : Display this help message"

# Set up environment, build, and start all services
.PHONY: all
all: setup build up

# Build Docker images for all services
.PHONY: build
build:
	@printf "$(BLUE)==> Building Docker images...$(NC)\n"
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build

# Start the services using docker-compose
.PHONY: up
up:
	@printf "$(GREEN)==> Starting Docker services...$(NC)\n"
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d
	@printf "$(GREEN)==> Services are now running.$(NC)\n"

# Stop the services
.PHONY: down
down:
	@printf "$(RED)==> Stopping Docker services...$(NC)\n"
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down
	@printf "$(RED)==> Docker services stopped.$(NC)\n"

# Remove generated containers, volumes, networks, and virtual environment
.PHONY: clean
clean:
	@printf "$(RED)==> Cleaning up Docker containers, volumes, and networks...$(NC)\n"
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v --rmi all --remove-orphans
	@rm -rf $(VENV_DIR)
	@printf "$(RED)==> Clean up complete.$(NC)\n"

# Display logs for all services
.PHONY: logs
logs:
	@printf "$(YELLOW)==> Displaying logs for all services...$(NC)\n"
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f

# Restart all services
.PHONY: restart
restart:
	@printf "$(BLUE)==> Restarting services...$(NC)\n"
	@$(MAKE) down
	@$(MAKE) up

# Show the status of all services
.PHONY: status
status:
	@printf "$(BLUE)==> Checking service status...$(NC)\n"
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps

# Generate environment variables and self-signed SSL certificates
.PHONY: setup
setup:
	@printf "$(GREEN)==> Setting up development environment...$(NC)\n"
	@python3 -m venv $(VENV_DIR)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r srcs/requirements/tools/requirements.txt
	@$(PYTHON) ./srcs/requirements/tools/make_env.py > $(DOTENV_FILE)
	@printf "$(YELLOW)==> Generating SSL certificates...$(NC)\n"
	@srcs/requirements/tools/generate_certs.sh $(CERTS_DIR)
	@printf "$(GREEN)==> Environment setup complete.$(NC)\n"

# Prune Docker system (remove unused containers, networks, images, volumes)
.PHONY: prune
prune:
	@printf "$(RED)==> Pruning Docker system...$(NC)\n"
	@docker system prune -af --volumes
	@printf "$(RED)==> Docker system pruned.$(NC)\n"
