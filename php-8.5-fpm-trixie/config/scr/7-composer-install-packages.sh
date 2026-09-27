#!/bin/bash
# Ставит PHP-зависимости из composer.json в корне репозитория (APP_PATH).
# Если файла нет — шаг пропускается.

if [[ -f "$APP_PATH/composer.json" ]]; then
  log info "Ставлю PHP-пакеты из composer.json…"
  composer install --no-interaction --working-dir="$APP_PATH"
  log success "Пакеты Composer установлены"
else
  log info "composer.json не найден в $APP_PATH — пакеты пропускаю"
fi
