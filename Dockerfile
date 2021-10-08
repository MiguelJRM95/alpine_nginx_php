FROM alpine:3.13.6

LABEL Mantainer="MiguelJRM95<miguelj.rodriguezmartinez@gmail.com>"
LABEL Description="Simple nginx server for run php files"

RUN apk -U upgrade && apk add --no-cache \
    supervisor nginx php8 php8-fpm
  
RUN adduser -D -g 'phpnginx' phpnginx

RUN ln -s /usr/sbin/php8 /usr/sbin/php

RUN mkdir -p /run/nginx

RUN rm /etc/nginx/conf.d/default.conf

COPY config/supervisord.conf /etc/supervisord.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/php-fpm.conf /etc/php8/php-fpm.d/www.conf

RUN mkdir -p /var/www/html

RUN touch /var/run/nginx.pid && \
  chown -R phpnginx.phpnginx /var/run/nginx.pid && \
  chown -R phpnginx.phpnginx /var/www/html && \
  chown -R phpnginx.phpnginx /run && \
  chown -R phpnginx.phpnginx /var/lib/nginx && \
  chown -R phpnginx.phpnginx /var/log/nginx && \
  chmod -R 755 /var/log/nginx

USER phpnginx

WORKDIR /var/www/html

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n"]