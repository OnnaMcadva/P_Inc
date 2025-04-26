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


# FROM alpine:3.16
# RUN apk add --no-cache nginx openssl

# COPY tools/docker-entrypoint.sh /docker-entrypoint.sh
# COPY conf /etc/nginx/conf.d       # Копируем wp.conf и cat.conf
# COPY static /var/www/cat          # Копируем сайт с котиком

# EXPOSE 443

# ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
# CMD ["nginx", "-g", "daemon off;"]
