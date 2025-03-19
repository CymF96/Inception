FROM debian:bookworm

RUN apt update && apt install -y \
nginx \
curl \
vim \
openssl 

RUN mkdir /etc/nginx/ssl /etc/nginx/ssl/certs /etc/nginx/ssl/private

COPY nginx.conf /etc/nginx/nginx.conf

RUN openssl req \
-newkey rsa:4096 -x509 -sha256 -days 100 -nodes \
-out /etc/nginx/ssl/certs/cert.crt \
-keyout /etc/nginx/ssl/private/key.key \
-subj "/C=UK/ST=ENGLAND/L=LONDON/O=42/OU=INCEPTION/CN=cofische.42.fr"

VOLUME ["/var/www/cofische"]

EXPOSE 443

CMD ["nginx","-g", "daemon off;"]
