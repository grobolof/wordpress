FROM php:8.5-fpm-trixie

# Buildx подставляет архитектуру образа; нужен и для локальной сборки без --platform
ARG TARGETARCH

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    acl \
    apache2-utils \
    cron \
    curl \
    default-mysql-client \
    dos2unix \
    gettext-base \
    git \
    iputils-ping \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
    nano \
    nginx \
    nodejs \
    npm \
    openssl \
    postgresql-client \
    sendmail \
    supervisor \
    unzip \
    wait-for-it \
    wget \
    zip \
    zlib1g-dev; \
	rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN set -eux; \
    curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
    chmod +x /usr/local/bin/wp; \
    wp --version --allow-root
RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    curl -fsSL "https://github.com/axllent/mailpit/releases/latest/download/mailpit-linux-${arch}.tar.gz" \
      | tar -xz -C /usr/local/bin --no-same-owner mailpit; \
    chmod +x /usr/local/bin/mailpit

RUN docker-php-ext-configure intl; \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp --with-xpm; \
    docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    intl \
    mysqli \
    pcntl \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    sockets \
    xml \
    xsl \
    zip

# pecl.php.net is deprecated and often returns 504; install from GitHub instead of `pecl`.
ARG APCU_VERSION=5.1.28
ARG REDIS_VERSION=6.3.0
ARG XDEBUG_VERSION=3.5.0

RUN set -eux; \
    mkdir -p /usr/src/php/ext/apcu; \
    curl -fsSL "https://github.com/krakjoe/apcu/archive/refs/tags/v${APCU_VERSION}.tar.gz" \
      | tar -xz -C /usr/src/php/ext/apcu --strip-components=1; \
    docker-php-ext-install -j"$(nproc)" apcu

RUN set -eux; \
    mkdir -p /usr/src/php/ext/redis; \
    curl -fsSL "https://github.com/phpredis/phpredis/archive/refs/tags/${REDIS_VERSION}.tar.gz" \
      | tar -xz -C /usr/src/php/ext/redis --strip-components=1; \
    docker-php-ext-install -j"$(nproc)" redis

RUN set -eux; \
    mkdir -p /usr/src/php/ext/xdebug; \
    curl -fsSL "https://github.com/xdebug/xdebug/archive/refs/tags/${XDEBUG_VERSION}.tar.gz" \
      | tar -xz -C /usr/src/php/ext/xdebug --strip-components=1; \
    docker-php-ext-install -j"$(nproc)" xdebug

COPY docker-entrypoint.sh /usr/local/bin/
COPY config/conf/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY config/conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/ini/php.ini /usr/local/etc/php/conf.d/php.ini
COPY config/scr /tmp/scr

RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    sed -i 's/\r$//' /tmp/scr/*.sh; \
    chmod +x /tmp/scr/*

CMD ["docker-entrypoint.sh"]
