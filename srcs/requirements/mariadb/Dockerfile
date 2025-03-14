FROM debian:bookworm

RUN	apt update && apt install -y \
bash \
vim \
mariadb-server

COPY init.sql /init.sql
COPY start_mariadb.sh /start_mariadb.sh
RUN	chmod +x /start_mariadb.sh

RUN --mount=type=secret,id=db_admin_pwd \
export DB_ADMIN_PWD=$(cat /.secrets/db_admin_pwd.txt)
RUN --mount=type=secret,id=db_pwd \
export DB_PWD=$(cat /.secrets/db_pwd.txt)

RUN /start_mariadb.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["service", "mariadb", "start"]
