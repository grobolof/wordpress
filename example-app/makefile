include .env

# Запустить контейнеры:
up:
	docker compose up -d --build --remove-orphans

# Остановить контейнеры:
stop:
	docker compose stop

# Остановить и удалить контейнеры:
down:
	docker compose down -v

# КОМАНДЫ ДОСТУПНЫ ПРИ УСЛОВИИ ЧТО ПРОЕКТ WORDPRESS УЖЕ СОЗДАН:

## Произвольная команда WP-CLI:
wp: ## Пример: make wp CMD="plugin list"
	docker compose exec -it application wp --path=$(APP_PATH)/public $(CMD)

## Сбросить постоянные ссылки:
rewrite-flush:
	docker compose exec -it application wp --path=$(APP_PATH)/public rewrite flush

## Очистить кэш объекта:
cache-flush:
	docker compose exec -it application wp --path=$(APP_PATH)/public cache flush
