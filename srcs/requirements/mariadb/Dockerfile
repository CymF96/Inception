FROM debian:bookworm

RUN	apt update && apt install -y \
	vim \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 mysql && useradd -u 1001 -g 1001 mysql
COPY init.sql /usr/local/bin/
COPY start_mariadb.sh /usr/local/bin/
RUN	chmod +x /usr/local/bin/start_mariadb.sh
RUN	chmod +x /usr/local/bin/init.sql

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["bash","/usr/local/bin/start_mariadb.sh"]

CMD ["bash", "start_mariadb.sh"]