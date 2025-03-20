FROM debian:bookworm

#downloading usefull package + nginx + openssl for protocol certificate
RUN apt update && apt install -y \
nginx \
curl \
vim \
dnsutils \
openssl 

# Copying nginx.conf server info to container 
COPY nginx.conf /etc/nginx/sites-available/cofische.conf

# Creating folder to store ssl certificates + creating symlink for sites-available/sites-enabled
RUN mkdir /etc/nginx/ssl /etc/nginx/ssl/certs /etc/nginx/ssl/private
RUN ln -s /etc/nginx/sites-available/cofische.conf /etc/nginx/sites-enabled/cofische.conf

# getting an self-signed certificate from openssl
RUN openssl req \
-newkey rsa:4096 -x509 -sha256 -days 100 -nodes \
-out /etc/nginx/ssl/certs/cert.crt \
-keyout /etc/nginx/ssl/private/key.key \
-subj "/C=UK/ST=ENGLAND/L=LONDON/O=42/OU=INCEPTION/CN=cofische.42.fr"

EXPOSE 443

# Running nginx in foreground to prevent stopping docker running
CMD ["nginx","-g", "daemon off;"]
