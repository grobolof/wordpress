#!/bin/bash
# Запускает supervisord на переднем плане — он держит Nginx и PHP-FPM.
# Это основной процесс контейнера: без него веб-сервер не стартует.

log success "Контейнер готов — запускаю Nginx и PHP-FPM"
exec supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
