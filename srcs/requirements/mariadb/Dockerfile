FROM debian:bookworm

RUN	apt update && apt install -y \
bash \
vim \
mariadb-server \
mariadb-client \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql
RUN chown -R mysql:mysql /var/run/mysqld \
&& chmod 700 /var/run/mysqld
RUN chown -R 999:999 /var/lib/mysql \
&& chmod 700 /var/lib/mysql

COPY init.sql /usr/local/bin/
COPY start_mariadb.sh /usr/local/bin
RUN	chmod +x /usr/local/bin/start_mariadb.sh
RUN	chmod +x /usr/local/bin/init.sql

EXPOSE 3306

ENTRYPOINT ["bash","/usr/local/bin/start_mariadb.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]
