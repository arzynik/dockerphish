FROM php:7.0-fpm

ENV DOCKER=1

EXPOSE 80

RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
        php-pear \
        curl \
        git \
		nginx \
    && docker-php-ext-install iconv mcrypt \
	&& docker-php-ext-install pdo pdo_mysql

ADD nginx.conf /etc/nginx/sites-available/default
RUN echo "cgi.fix_pathinfo = 0;" >> /usr/local/etc/php/conf.d/fix_pathinfo.ini
RUN echo " \n\
listen = 127.0.0.1:9000" >> /usr/local/etc/php-fpm.conf

ADD run.sh /run.sh

RUN rm -fr /app
RUN php -v

ONBUILD ADD . /app

CMD /run.sh
