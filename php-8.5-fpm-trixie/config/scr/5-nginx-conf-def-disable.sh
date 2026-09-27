#!/bin/bash
# Убирает стандартный сайт Debian-Nginx.
# Иначе он перехватит порт 80, и наш конфиг WordPress не заработает.

log info "Отключаю стандартный виртуальный хост Nginx…"
rm -f /etc/nginx/sites-enabled/default
log success "Остался только конфиг сайта"
