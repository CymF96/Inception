FROM debian:buster

RUN apt-get update -y && apt-get install -y \
mariadb-server \
mariadb-client \
vim \
curl \
dnsutils \
iputils

COPY start_mariadb.sh /tmp/start_mariadb.sh
RUN  chmod +x /tmp/start_mariadb.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 

EXPOSE "3306"

ENTRYPOINT ["bash", "/tmp/start_mariadb.sh"]

CMD ["mysqld"]