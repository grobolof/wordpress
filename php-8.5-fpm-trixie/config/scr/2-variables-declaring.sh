#!/bin/bash
# Читает и проверяет переменные окружения контейнера.
# APP_PATH — корень смонтированного репозитория внутри контейнера (./:${APP_PATH}).
# Без APP_PATH и APP_HOST Nginx не узнает, куда класть сайт и какой домен слушать.
# WP-CLI от root требует WP_CLI_ALLOW_ROOT, иначе команды установки обрываются.

require() {
  [[ -n "${!1}" ]] || { log error "Не задана переменная $1 — укажите её в .env"; exit 1; }
}

require_01() {
  local name=$1
  local value=${!name}
  [[ -n "$value" ]] || { log error "Не задана переменная $name — укажите 0 или 1 в .env"; exit 1; }
  case $value in
    0|1) ;;
    *)
      log error "$name=$value недопустима. Допустимо: 0 или 1"
      exit 1
      ;;
  esac
}

require APP_PATH
require APP_HOST
require DB_CONNECTION
require DB_HOST
require DB_PORT
require DB_DATABASE
require DB_USERNAME
require DB_PASSWORD
require_01 WORDPRESS_CRON_ENABLED
require WP_LOCALE
require WP_TITLE
require WP_ADMIN_USER
require WP_ADMIN_PASSWORD
require WP_ADMIN_EMAIL

: "${WP_TABLE_PREFIX:=wp_}"

case $DB_CONNECTION in
  mysql|mariadb) ;;
  *)
    log error "DB_CONNECTION=$DB_CONNECTION неизвестна. Допустимо: mysql, mariadb"
    exit 1
    ;;
esac

if [[ ${MAILPIT_ENABLED+set} == set ]]; then
  require_01 MAILPIT_ENABLED
  [[ $MAILPIT_ENABLED != 1 ]] || require MAILPIT_HOST
fi

export WP_CLI_ALLOW_ROOT=1
export WP_ROOT="$APP_PATH/public"

log info "Сайт: $APP_PATH  ·  домен: $APP_HOST  ·  СУБД: $DB_CONNECTION  ·  язык: $WP_LOCALE"
mkdir -p "$APP_PATH"
cd "$APP_PATH"
