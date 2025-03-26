FROM debian:bookworm

RUN apt-get update && apt-get install -y \
vim \
net-tools \
iproute2 \
iputils-ping \
sudo \
curl \
dnsutils \
openssl \
vsftpd

RUN mkdir -p /etc/ssl/private
RUN openssl req \
-x509 \
-nodes \
-days 365 \
-newkey rsa:1024 \
-keyout /etc/ssl/private/vsftpd.pem \
-out /etc/ssl/private/vsftpd.pem \
-subj "/C=UK/ST=ENGLAND/L=LONDON/O=42/OU=INCEPTION/CN=cofische.42.fr"

RUN rm -f /etc/vsftpd.conf
COPY vsftpd.conf /tmp/vsftpd.conf
COPY ftp_start.sh /tmp/ftp_start.sh
RUN chmod +x /tmp/ftp_start.sh

ENTRYPOINT [ "bash","/tmp/ftp_start.sh" ]

CMD ["vsftpd"]