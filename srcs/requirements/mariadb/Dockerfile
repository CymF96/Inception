FROM debian:bookworm

RUN	apt-get update && apt-get install -y \
	vim \
	mariadb-server 
	
#&& rm -rf /var/lib/apt/lists/*

# Modify the UID and GID for mysql to match your host system
#RUN usermod -u 1001 mysql && groupmod -g 1001 mysql

#RUN mkdir -p /var/run/mysqld \
#&& chown -R mysql:mysql /var/run/mysqld \
#&& chmod 777 /var/run/mysqld

#COPY init.sql /init.sql
COPY start_mariadb.sh /usr/local/bin/
RUN	chmod +x /usr/local/bin/start_mariadb.sh
#RUN	chmod +x /init.sql

EXPOSE 3306

#VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["bash","start_mariadb.sh"]

#USER mysql

#CMD ["bash", "start_mariadb.sh"]