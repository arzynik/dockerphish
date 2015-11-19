FROM php:7.0-fpm
MAINTAINER Devin Smith <docker@arzynik.com>

ENV DOCKER=1

EXPOSE 80

RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
        php-pear \
        curl \
        git \
		nginx \
		zlib1g-dev \
    && docker-php-ext-install iconv mcrypt \
	&& docker-php-ext-install pdo pdo_mysql \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install zip

ENV PHPREDIS_VERSION php7

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install redis

ADD nginx.conf /etc/nginx/sites-available/default
RUN echo "cgi.fix_pathinfo = 0;" >> /usr/local/etc/php/conf.d/fix_pathinfo.ini
RUN echo " \n\
listen = 127.0.0.1:9000 \n\
security.limit_extensions = .php .scss \n\
" >> /usr/local/etc/php-fpm.conf

# would be nice to get this to work
# RUN sed -i 's/^# server_tokens off;$/server_tokens off;/' /etc/nginx/nginx.conf

ADD run.sh /run.sh

RUN rm -fr /app
RUN php -v

ONBUILD ADD . /app

ENTRYPOINT ["/run.sh"]
CMD nginx && php-fpm
