FROM debian:bookworm

RUN	apt update && apt install -y \
	vim \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

# Modify the UID and GID for mysql to match your host system
RUN usermod -u 1001 mysql && groupmod -g 1001 mysql

# Ensure the mysql user and group are present before using them
RUN groupadd -g 1001 mysql && useradd -u 1001 -g mysql mysql

COPY init.sql /usr/local/bin/
COPY start_mariadb.sh /usr/local/bin/
RUN	chmod +x /usr/local/bin/start_mariadb.sh
RUN	chmod +x /usr/local/bin/init.sql

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["start_mariadb.sh"]

USER mysql

#CMD ["bash", "start_mariadb.sh"]