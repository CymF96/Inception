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

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

CMD ["sh", "-c", "/start_mariadb.sh", "rm -f /start_mariadb.sh /init.sql"]
