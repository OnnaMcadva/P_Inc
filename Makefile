ENV_FILE := ./srcs/.env
SSL_FOLDER := ./secrets/ssl
SSL_FILES = $(SSL_FOLDER)/chain.pem \
			$(SSL_FOLDER)/fullchain.pem \
			$(SSL_FOLDER)/privkey.pem
COMPOSE_FILE := ./srcs/docker-compose.yml
LOG_FILE := ./build_log.txt

GREEN = \033[0;32m
YELLOW = \033[1;33m
RESET = \033[0m
RED = \033[0;31m

all: $(ENV_FILE) $(SSL_FILES) run

$(ENV_FILE):
	@cp ~/.for_inception/.env ./srcs

$(SSL_FILES):
	@mkdir -p secrets
	@cp -r ~/.for_inception/ssl ./secrets

build:
	@echo -e "$(YELLOW)Building containers...$(RESET)"
	@docker-compose -f $(COMPOSE_FILE) build > $(LOG_FILE) 2>&1
	@grep -q 'Successfully built' $(LOG_FILE) && echo -e "$(GREEN)Containers built successfully!$(RESET)" || echo -e "$(YELLOW)Error building containers. Check the logs.$(RESET)"

run:
	@echo -e "$(YELLOW)Starting containers... 🐣 🐣 🐣$(RESET)"
	@docker-compose -f $(COMPOSE_FILE) up -d >> $(LOG_FILE) 2>&1
	@echo -e "$(GREEN)Containers started! 🦕$(RESET)"

stop:
	@docker-compose -f $(COMPOSE_FILE) down

clean: stop
	@docker system prune -f

fclean: clean
	@echo -e "$(YELLOW)Removing containers...$(RESET)"
	@for container in $(shell docker ps -aq); do \
		if docker rm -fv $$container; then \
			echo -e "$(GREEN)Container $$container removed successfully!$(RESET)"; \
		else \
			echo -e "$(RED)🍄 $$container$(RESET)"; \
		fi \
	done

	@echo -e "$(YELLOW)Removing images...$(RESET)"
	@for image in $(shell docker image ls -q); do \
		if docker rmi $$image; then \
			echo -e "$(GREEN)Image $$image removed successfully!$(RESET)"; \
		else \
			echo -e "$(RED)🍄 $$image$(RESET)"; \
		fi \
	done

	@echo -e "$(YELLOW)Removing volumes...$(RESET)"
	@for volume in $(shell docker volume ls -q); do \
		if docker volume rm $$volume; then \
			echo -e "$(GREEN)Volume $$volume removed successfully!$(RESET)"; \
		else \
			echo -e "$(RED)🍄 $$volume$(RESET)"; \
		fi \
	done

	@echo -e "$(YELLOW)Removing networks...$(RESET)"
	@for network in $(shell docker network ls -q); do \
		if docker network rm $$network; then \
			echo -e "$(GREEN)Network $$network removed successfully!$(RESET)"; \
		else \
			echo -e "$(RED)🍄 $$network$(RESET)"; \
		fi \
	done

	@rm -rf secrets ./srcs/wp-content ./srcs/.env $(LOG_FILE)

.PHONY: all build run stop clean fclean

.SILENT: fclean

# ENV_FILE := ./srcs/.env
# SSL_FOLDER := ./secrets/ssl
# SSL_FILES = $(SSL_FOLDER)/chain.pem \
# 			$(SSL_FOLDER)/fullchain.pem \
# 			$(SSL_FOLDER)/privkey.pem
# COMPOSE_FILE := ./srcs/docker-compose.yml

# all: $(ENV_FILE) $(SSL_FILES) run


# $(ENV_FILE):
# 	@cp ~/.for_inception/.env ./srcs

# $(SSL_FILES):
# 	@mkdir -p secrets
# 	@cp -r ~/.for_inception/ssl ./secrets

# build:
# 	@docker-compose -f $(COMPOSE_FILE) build

# run:
# 	@docker-compose -f $(COMPOSE_FILE) up -d

# stop:
# 	@docker-compose -f $(COMPOSE_FILE) down

# clean: stop
# 	@docker system prune -f

# fclean: clean
# 	-@docker rm -fv $(shell docker ps -aq)
# 	-@docker rmi $(shell docker image ls -q)
# 	-@docker volume rm $(shell docker volume ls -q)
# 	-@docker network rm $(shell docker network ls -q)
# 	-@rm -rf secrets ./srcs/wp-content ./srcs/.env


# .PHONY: all build run stop clean fclean

# .SILENT: fclean
