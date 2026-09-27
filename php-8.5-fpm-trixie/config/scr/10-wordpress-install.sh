#!/bin/bash
# Ставит сайт через wp core install, когда база уже принимает соединения.
# Повторный запуск ничего не переустанавливает: смотрим wp core is-installed.
# Если СУБД ещё не готова — шаг не роняет контейнер, только предупреждает.

run_install() {
  wp core install \
    --path="$WP_ROOT" \
    --url="http://${APP_HOST}" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --locale="$WP_LOCALE" \
    --skip-email
}

if [[ ! -f "$WP_ROOT/wp-load.php" ]]; then
  log warning "WordPress не найден — установку пропускаю"
elif wp core is-installed --path="$WP_ROOT" >/dev/null 2>&1; then
  log success "WordPress уже установлен"
else
  log info "Жду СУБД $DB_HOST:$DB_PORT и устанавливаю WordPress…"
  if ! wait-for-it "${DB_HOST}:${DB_PORT}" -t 60; then
    log warning "СУБД не отвечает — установку пропускаю"
  else
    installed=0
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      if run_install; then
        installed=1
        break
      fi
      sleep 3
    done
    if [[ $installed == 1 ]]; then
      if ! wp rewrite structure '/%postname%/' --path="$WP_ROOT" \
        || ! wp rewrite flush --path="$WP_ROOT"; then
        log warning "Не удалось включить постоянные ссылки"
      fi
      if [[ $WP_LOCALE != en_US ]]; then
        if ! wp language core install "$WP_LOCALE" --path="$WP_ROOT"; then
          log warning "Не удалось установить язык $WP_LOCALE"
        fi
      fi
      log success "WordPress установлен: http://$APP_HOST"
    else
      log warning "WordPress не установлен — проверьте подключение к БД"
    fi
  fi
fi
