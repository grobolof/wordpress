#!/bin/bash
# Скачивает актуальное ядро WordPress в public/, если wp-load.php ещё нет.
# Локаль в индекс ядра больше не входит: язык ставится отдельно после установки.
# wp-config.php создаётся в корне репозитория — на уровень выше корня сайта,
# поэтому он не отдаётся Nginx. docker-compose.yml, makefile, .env и README не трогаем.

log success "WP-CLI $(wp --version 2>/dev/null | awk '{print $2}') готов"

if [[ -f "$WP_ROOT/wp-load.php" ]]; then
  log success "WordPress уже есть в $WP_ROOT — скачивать не нужно"
else
  log info "Скачиваю WordPress, это может занять несколько минут…"
  mkdir -p "$WP_ROOT"
  wp core download --path="$WP_ROOT"
  log success "WordPress скачан в $WP_ROOT"
fi

if [[ -f "$APP_PATH/wp-config.php" || -f "$WP_ROOT/wp-config.php" ]]; then
  log success "wp-config.php уже есть — создавать не нужно"
else
  log info "Создаю wp-config.php вне корня сайта…"
  wp config create \
    --path="$WP_ROOT" \
    --dbname="$DB_DATABASE" \
    --dbuser="$DB_USERNAME" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="${DB_HOST}:${DB_PORT}" \
    --dbcharset=utf8mb4 \
    --dbprefix="$WP_TABLE_PREFIX" \
    --skip-check

  wp config set WP_DEBUG true --raw --path="$WP_ROOT"
  wp config set WP_DEBUG_LOG "${APP_PATH}/debug.log" --path="$WP_ROOT"
  wp config set WP_DEBUG_DISPLAY false --raw --path="$WP_ROOT"
  wp config set WP_ENVIRONMENT_TYPE local --path="$WP_ROOT"
  wp config set FS_METHOD direct --path="$WP_ROOT"
  if [[ $WP_LOCALE != en_US ]]; then
    wp config set WPLANG "$WP_LOCALE" --path="$WP_ROOT"
  fi

  mv "$WP_ROOT/wp-config.php" "$APP_PATH/wp-config.php"
  log success "wp-config.php создан в $APP_PATH"
fi
