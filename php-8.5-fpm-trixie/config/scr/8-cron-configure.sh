#!/bin/bash
# При WORDPRESS_CRON_ENABLED=1 вешает поминутный wp cron event run и отключает псевдо-cron.
# При 0 системный крон не ставится: задачи выполняются при заходе на сайт, как в обычном WordPress.

if [[ ! -f "$WP_ROOT/wp-load.php" ]]; then
  log warning "WordPress не найден — крон пропускаю"
elif [[ ! -f "$APP_PATH/wp-config.php" && ! -f "$WP_ROOT/wp-config.php" ]]; then
  log warning "wp-config.php не найден — крон пропускаю"
elif [[ $WORDPRESS_CRON_ENABLED != 1 ]]; then
  wp config set DISABLE_WP_CRON false --raw --path="$WP_ROOT"
  crontab -r 2>/dev/null || true
  log warning "Крон выключен — задачи WordPress будут запускаться при открытии сайта"
else
  log info "Включаю планировщик WordPress: wp cron event run каждую минуту…"
  wp config set DISABLE_WP_CRON true --raw --path="$WP_ROOT"
  { env; echo "*/1 * * * * cd ${APP_PATH} && /usr/local/bin/wp cron event run --due-now --path=${WP_ROOT} --quiet >> /dev/null 2>&1"; } | crontab -
  log success "Крон настроен"
fi
