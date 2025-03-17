FROM debian:bookworm

RUN	apt update && apt install -y \
bash \
vim \
mariadb-server \
mariadb-client \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld

RUN chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld
RUN chown -R 999:999 /var/lib/mysql \
&& chmod 777 /var/lib/mysql

COPY init.sql /usr/local/bin/
COPY start_mariadb.sh /usr/local/bin
RUN	chmod +x /usr/local/bin/start_mariadb.sh
RUN	chmod +x /usr/local/bin/init.sql

#ENV DB_ADMIN_ID=InceptionMaster
#ENV DB_ID=RandomUser

RUN --mount=type=secret,id=db_admin_pwd \
export DB_ADMIN_PWD=$(cat /.secrets/db_admin_pwd.txt)
RUN --mount=type=secret,id=db_pwd \
export DB_PWD=$(cat /.secrets/db_pwd.txt)

EXPOSE 3306

ENTRYPOINT ["bash","/usr/local/bin/start_mariadb.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]
