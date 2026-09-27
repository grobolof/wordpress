#!/bin/bash
# Ставит Composer, если его ещё нет в PATH.
# Нужен, чтобы ставить PHP-зависимости проекта из composer.json.

if ! command -v composer >/dev/null; then
  log info "Composer не найден — ставлю официальный установщик…"
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --quiet
fi

log success "Composer $(composer -V --no-ansi 2>/dev/null | awk '{print $3}') готов"
