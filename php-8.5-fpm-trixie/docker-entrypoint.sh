#!/usr/bin/env bash
# Готовит окружение WordPress и запускает Nginx + PHP-FPM.
set -e

source /tmp/scr/1-text-decoration.sh
log info "Готовлю контейнер WordPress…"

source /tmp/scr/2-variables-declaring.sh
source /tmp/scr/3-composer-install.sh
source /tmp/scr/4-variables-change.sh
source /tmp/scr/5-nginx-conf-def-disable.sh
source /tmp/scr/6-wordpress-download.sh
source /tmp/scr/7-composer-install-packages.sh
source /tmp/scr/8-cron-configure.sh
source /tmp/scr/9-mailpit-configure.sh
source /tmp/scr/10-wordpress-install.sh
source /tmp/scr/11-wordpress-permissions.sh
source /tmp/scr/12-final-supervisor-run.sh
