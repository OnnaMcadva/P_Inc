# Имя проекта
NAME = inception
LOGIN ?= anmakaro  # логин по умолчанию

# Цели, которые не являются файлами
.PHONY: all build down stop start re clean fclean

# Цель по умолчанию: запуск конфигурации
all:
	@printf "Launching configuration ${NAME}...\n"
	@test -f srcs/requirements/wordpress/tools/make_dir.sh || (echo "Error: make_dir.sh not found" >&2; exit 1)
	@bash -e srcs/requirements/wordpress/tools/make_dir.sh || exit 1
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d || exit 1

# Сборка и запуск конфигурации
build:
	@printf "Building configuration ${NAME}...\n"
	@test -f srcs/requirements/wordpress/tools/make_dir.sh || (echo "Error: make_dir.sh not found" >&2; exit 1)
	@bash -e srcs/requirements/wordpress/tools/make_dir.sh || exit 1
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build || exit 1

# Остановка конфигурации
down:
	@printf "Stopping configuration ${NAME}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down || exit 1

# Остановка контейнеров
stop:
	@printf "Stopping configuration ${NAME}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env stop || exit 1

# Запуск остановленных контейнеров
start:
	@printf "Starting configuration ${NAME}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env start || exit 1

# Пересборка конфигурации
re: down
	@printf "Rebuilding configuration ${NAME}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build || exit 1

# Чистка конфигурации
clean: down
	@printf "Cleaning configuration ${NAME}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env rm -f -v || exit 1
	@docker image prune -f --filter "label=project=${NAME}" || exit 1
	@docker network prune -f --filter "label=project=${NAME}" || exit 1
	@rm -rf /home/${LOGIN}/data/wordpress/* /home/${LOGIN}/data/mariadb/* || exit 1

# Полная очистка Docker
fclean:
	@printf "Performing total clean of Docker configurations...\n"
	@docker stop $$(docker ps -qa 2>/dev/null) 2>/dev/null || true
	@docker system prune --all --force --volumes 2>/dev/null || true
	@docker network prune --force 2>/dev/null || true
	@docker volume prune --force 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q 2>/dev/null) 2>/dev/null || true
	@rm -rf /home/${LOGIN}/data/wordpress/* /home/${LOGIN}/data/mariadb/* || exit 1

# Проверка прав доступа перед удалением файлов
check_permissions:
	@test -w /home/${LOGIN}/data/wordpress || (echo "Error: No write permission for /home/${LOGIN}/data/wordpress" >&2; exit 1)
	@test -w /home/${LOGIN}/data/mariadb || (echo "Error: No write permission for /home/${LOGIN}/data/mariadb" >&2; exit 1)

clean: check_permissions
fclean: check_permissions
