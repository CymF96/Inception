FROM debian:bookworm

RUN apt update && apt install nginx -y
RUN apt install openssl -y

COPY nginx.conf /etc/nginx/nginx.conf
RUN --mount=type=secret,id=env_secret cat /run/secrets/env_secret > /.env
RUN source /.env

ENV DOMAINE=cofische

RUN openssl req \
-newkey rsa:4096 -x509 -sha256 -days 100 -nodes \
-out /etc/nginx/ssl/certs/cert.crt \
-keyout /etc/nginx/ssl/private/key.key \
-subj "/C=UK/ST=ENGLAND/L=LONDON/O=42/OU=INCEPTION/CN=cofische.42.fr"

VOLUME ["/var/www/$DOMAINE"]

EXPOSE 443

CMD ["nginx","-g", "daemon off;"]