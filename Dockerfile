FROM php:7.2-apache

MAINTAINER Uwe Kleinmann <u.kleinmann@kellerkinder.de>

RUN apt-get update -yqq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    libpq-dev \
    openssh-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-6.q16-dev \
    imagemagick-6.q16 \
    ghostscript \
    libmcrypt-dev \
    libssl-dev \
    libxml2-dev \
    libicu-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN pecl install imagick mailparse && \
    docker-php-ext-enable imagick && \
    docker-php-ext-install -j$(nproc) pdo_pgsql && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install -j$(nproc) intl && \
    docker-php-ext-install -j$(nproc) zip && \
    docker-php-ext-install -j$(nproc) soap && \
    docker-php-ext-enable mailparse

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

ENV APACHE_DOCUMENT_ROOT /var/www/html/web

ENTRYPOINT ["docker-php-entrypoint"]

CMD ["apache2-foreground"]
