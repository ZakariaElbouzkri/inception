DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

# Define the volumes for the services
VOLUME_DIR = ${HOME}/data
WORDPRESS_VOLUME = ${VOLUME_DIR}/wordpress
MARIADB_VOLUME = ${VOLUME_DIR}/mariadb
ADMINER_VOLUME = ${VOLUME_DIR}/adminer

VENV_DIR = .venv
PIP = $(VENV_DIR)/bin/pip
PYTHON = $(VENV_DIR)/bin/python

DOTENV_FILE = srcs/.env

CERTS_DIR = nginx/conf/certs

# Default target to build everything
.PHONY: all
all: build up

# Build Docker images for all services
.PHONY: build
build:
	@echo "Building Docker images..."
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build

# Start the services using docker-compose
.PHONY: up
up:
	@echo "Starting Docker services..."
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

# Stop the services
.PHONY: down
down:
	@echo "Stopping Docker services..."
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down
	@echo "Docker services stopped."

# Remove generated containers, volumes, networks, and virtual environment
.PHONY: clean
clean:
	@echo "Cleaning up Docker containers, volumes, networks, and .venv..."
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v --rmi all --remove-orphans
	@rm -rf .venv
	@echo "Clean up complete."

# Display logs for all services
.PHONY: logs
logs:
	@echo "Displaying logs for all services..."
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f

# Restart all services
.PHONY: restart
restart: down up

# Show the status of all services
.PHONY: status
status:
	@echo "Showing the status of all services..."
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps

# Generate environment variables and self signed SSL certificates
.PHONY: setup
setup:
	@echo "Setting up environment..."
	@python3 -m venv .venv
	@$(PIP) install --upgrade pip
	@$(PIP) install -r requirements.txt
	@$(PYTHON) ./requirements/tools/make_env.py > $(DOTENV_FILE)
	@echo "Generating certificates..."
	@./requirements/tools/generate_certs.sh $(CERTS_DIR)
	@echo "Certificates generated successfully."

# Help target to display usage information
.PHONY: help
help:
	@echo "Makefile commands:"
	@echo "  all           Build and start all services"
	@echo "  build         Build Docker images for all services"
	@echo "  up            Start Docker services"
	@echo "  down          Stop Docker services"
	@echo "  clean         Clean up Docker containers, volumes, networks, and virtual environment"
	@echo "  logs          Display logs for all services"
	@echo "  restart       Restart all services (stop and then start)"
	@echo "  status        Show the status of all services"
	@echo "  setup         Set up environment and generate SSL certificates"
	@echo "  help          Display this help message"
