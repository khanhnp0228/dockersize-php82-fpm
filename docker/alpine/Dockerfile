FROM php:8.2.19-fpm-alpine

WORKDIR /var/www

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk --no-cache add shadow

ARG UID=1000
ARG GID=1000

RUN groupadd -g "${GID}" dev-user \
  && useradd -m -l -u "${UID}" -g "${GID}" dev-user \
  && usermod -aG www-data dev-user

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install dev-packages
RUN apk add --no-cache $PHPIZE_DEPS openssl-dev git \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install zip \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN apk add icu-dev \
    && docker-php-ext-configure intl && docker-php-ext-install intl

# Install php-yaml
RUN apk add --no-cache yaml-dev
RUN apk add --no-cache --virtual .build-deps \
    g++ make autoconf

RUN pecl channel-update pecl.php.net
RUN pecl install yaml && docker-php-ext-enable yaml

RUN apk del --purge .build-deps

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Intstall database's connection libraries
RUN docker-php-ext-install mysqli pdo pdo_mysql \
	&& docker-php-ext-enable pdo_mysql

# XDEBUG Support
ARG XDEBUG_ENABLE=0
RUN if [ $XDEBUG_ENABLE = "1" ] ; then \
    pecl install xdebug-3.1.5; \
    docker-php-ext-enable xdebug; \
    echo "zend_extension=xdebug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "[xdebug]" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "# For xdebug 3" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.mode=debug,develop" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.log='/tmp/xdebug/xdebug.log'" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.cli_color=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.idekey=docker" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
fi ;

# Error Mode
ARG ERROR_DISPLAY=0
RUN if [ $ERROR_DISPLAY = "1" ] ; then \
    echo "# Error Display Mode" >> /usr/local/etc/php/conf.d/docker-php-ext-error.ini; \
    echo "display_startup_errors=On" >> /usr/local/etc/php/conf.d/docker-php-ext-error.ini; \
    echo "display_errors=On" >> /usr/local/etc/php/conf.d/docker-php-ext-error.ini; \
fi ;

USER dev-user
EXPOSE 9000

ENV PATH="/home/dev-user/.composer/vendor/bin:${PATH}"