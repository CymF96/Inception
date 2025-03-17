FROM debian:bookworm

RUN	apt update && apt install -y \
bash \
vim \
mariadb-server \
mariadb-client \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

COPY init.sql /usr/bin/
COPY start_mariadb.sh /usr/bin
RUN	chmod +x /usr/bin/start_mariadb.sh
RUN	chmod +x /usr/bin/init.sql

#ENV DB_ADMIN_ID=InceptionMaster
#ENV DB_ID=RandomUser

RUN --mount=type=secret,id=db_admin_pwd \
export DB_ADMIN_PWD=$(cat /.secrets/db_admin_pwd.txt)
RUN --mount=type=secret,id=db_pwd \
export DB_PWD=$(cat /.secrets/db_pwd.txt)

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

#ENTRYPOINT ["printenv"]
