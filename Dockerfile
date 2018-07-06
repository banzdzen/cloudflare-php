FROM php:7.0-apache

RUN apt-get update \
 && apt-get install -y git zlib1g-dev

RUN docker-php-ext-install zip \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-enabled/000-default.conf \
 && mv /var/www/html /var/www/public

RUN apt-get install -y autoconf pkg-config libssl-dev libmcrypt-dev libpng12-dev libfreetype6-dev libjpeg62-turbo-dev librabbitmq-dev libsasl2-dev \
  && docker-php-ext-install iconv mcrypt


RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-install opcache

RUN echo "display_errors=off" > /usr/local/etc/php/php.ini
RUN echo "log_errors = On" >> /usr/local/etc/php/php.ini
RUN echo "error_log = /dev/stderr" >> /usr/local/etc/php/php.ini

RUN rm /var/log/apache2/access.log
RUN rm /var/log/apache2/other_vhosts_access.log

RUN ln -sf /dev/null /var/log/apache2/access.log
RUN ln -sf /dev/null /var/log/apache2/other_vhosts_access.log


WORKDIR /var/www

RUN curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer

