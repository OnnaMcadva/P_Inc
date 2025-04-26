FROM alpine:3.16
RUN apk add --no-cache nginx openssl

COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
COPY conf/wp.conf /etc/nginx/conf.d/wp.conf
COPY conf/cat.conf /etc/nginx/conf.d/cat.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY static /var/www/cat

EXPOSE 443

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

