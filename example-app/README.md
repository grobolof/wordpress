# Быстрый старт 🚀

- ⬇️ Скачайте [example-app](.) (переименуйте каталог под ваш проект).
- 📄 Скопируйте `.env.example` в `.env` (см. [таблицу с переменными](#env-vars)). СУБД проекта — MariaDB.
- ⚡ Запустите проект выполнив команду из корня репозитория: `make up`.
- 📊 В логах контейнера `application` вам будет доступен процесс создания проекта.
- ✅ Завершением сборки можно считать появление строки `✅ КОНТЕЙНЕР ГОТОВ — ЗАПУСКАЮ NGINX И PHP-FPM`.

<a id="env-vars"></a>

| Название переменной | Описание переменной | Требуется |
| :------------------ | :------------------ | :-------- |
| <a id="APP_HOST"></a>[APP_HOST](#APP_HOST) | Хост вашего проекта (хост необходимо добавить в файл hosts вашей системы, пример: `127.0.0.1   wordpress.docker.local`) | ✅ |
| <a id="APP_PATH"></a>[APP_PATH](#APP_PATH) | Путь внутри контейнера, куда монтируется корень репозитория (`./:${APP_PATH}`) | ✅ |
| <a id="DB_CONNECTION"></a>[DB_CONNECTION](#DB_CONNECTION) | Драйвер базы. Для этого примера — `mariadb`. Допустимо: `mysql`, `mariadb` | ✅ |
| <a id="DB_HOST"></a>[DB_HOST](#DB_HOST) | Хост базы данных (хостом БД является название контейнера СУБД из docker-compose.yml) | ✅ |
| <a id="DB_PORT"></a>[DB_PORT](#DB_PORT) | Порт базы данных. Для MariaDB и MySQL — `3306` | ✅ |
| <a id="DB_DATABASE"></a>[DB_DATABASE](#DB_DATABASE) | Название базы данных | ✅ |
| <a id="DB_USERNAME"></a>[DB_USERNAME](#DB_USERNAME) | Имя пользователя для базы данных | ✅ |
| <a id="DB_PASSWORD"></a>[DB_PASSWORD](#DB_PASSWORD) | Пароль пользователя для базы данных. Тот же пароль задаётся root-пользователю MariaDB | ✅ |
| <a id="WP_TABLE_PREFIX"></a>[WP_TABLE_PREFIX](#WP_TABLE_PREFIX) | Префикс таблиц. Если не задан — `wp_` | ❌ |
| <a id="WP_LOCALE"></a>[WP_LOCALE](#WP_LOCALE) | Локаль ядра и сайта, например `ru_RU` или `en_US` | ✅ |
| <a id="WP_TITLE"></a>[WP_TITLE](#WP_TITLE) | Название сайта при первой установке | ✅ |
| <a id="WP_ADMIN_USER"></a>[WP_ADMIN_USER](#WP_ADMIN_USER) | Логин администратора при первой установке | ✅ |
| <a id="WP_ADMIN_PASSWORD"></a>[WP_ADMIN_PASSWORD](#WP_ADMIN_PASSWORD) | Пароль администратора при первой установке | ✅ |
| <a id="WP_ADMIN_EMAIL"></a>[WP_ADMIN_EMAIL](#WP_ADMIN_EMAIL) | Почта администратора при первой установке | ✅ |
| <a id="WORDPRESS_CRON_ENABLED"></a>[WORDPRESS_CRON_ENABLED](#WORDPRESS_CRON_ENABLED) | Вкл/выкл системный CRON (1 — вкл.; раз в минуту): `wp cron event run --due-now`. Допустимы только `0` или `1`. При `0` задачи запускаются при открытии сайта | ✅ |
| <a id="MAILPIT_ENABLED"></a>[MAILPIT_ENABLED](#MAILPIT_ENABLED) | Вкл/выкл mailpit (1 — вкл.). Если задана — только `0` или `1`; любое другое значение — ошибка при старте контейнера | ❌ |
| <a id="MAILPIT_HOST"></a>[MAILPIT_HOST](#MAILPIT_HOST) | Хост mailpit. Обязательна, если [`MAILPIT_ENABLED`](#MAILPIT_ENABLED)=1 | ❌ |

## Установка WordPress

После успешной сборки проекта можете перейти на страницу `http://APP_HOST` (заменить [**APP_HOST**](#APP_HOST) на хост из `.env` файла). Вы должны увидеть сайт `WordPress`. Вход в админку: `http://APP_HOST/wp-admin` (логин и пароль — [`WP_ADMIN_USER`](#WP_ADMIN_USER) и [`WP_ADMIN_PASSWORD`](#WP_ADMIN_PASSWORD)).

1. Если в `public/` ещё нет `wp-load.php`, контейнер сам скачает актуальную версию WordPress через `wp core download`. Язык из [`WP_LOCALE`](#WP_LOCALE) ставится после установки. Файлы репозитория (`docker-compose.yml`, `makefile`, `.env`, `README.md`) не перезаписываются.
2. При первом запуске в корне репозитория создаётся `wp-config.php` (на уровень выше `public/`, чтобы файл не отдавался сайтом) из доступов к СУБД.
3. Таблицы создаются автоматически после готовности базы (`wp core install`). Повторный запуск установку не повторяет.
4. Для работы с сайтом используйте `wp` (см. [команды](#команды) и `make wp`).
5. 🔥 **WordPress** успешно установлен!

# Дополнительные настройки 🛠️

Дополнительные настройки являются рекомендованными, но необязательными и не препятствуют успешной работе проекта.

## Настройка почты через Mailpit

👇 Если [`MAILPIT_ENABLED`](#MAILPIT_ENABLED)=1, контейнер направит `mail()` PHP в Mailpit. Письма `wp_mail()` смотрите на `http://localhost:8025`.

# Документация и команды 🎨

## Документация

1. [Developer Resources](https://developer.wordpress.org/) — темы, плагины, хуки и база данных.
2. [WP-CLI](https://developer.wordpress.org/cli/commands/) — консольные команды.
3. [Theme Handbook](https://developer.wordpress.org/themes/) — разработка тем.
4. [Plugin Handbook](https://developer.wordpress.org/plugins/) — разработка плагинов.

## Команды

<a id="команды"></a>

### Загрузить БД в контейнер (mariadb)

```bash
docker exec -i $(basename $(pwd))-database-1 sh -c 'mariadb -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' < ./docker/mariadb/db.sql
```

### Выгрузить БД из контейнера (mariadb)

```bash
docker exec $(basename $(pwd))-database-1 sh -c 'mariadb-dump -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' > ./docker/mariadb/db.sql
```
