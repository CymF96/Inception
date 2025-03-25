FROM debian:bookworm

# installaing useful packages + mariadb
RUN apt-get update -y && apt-get install -y \
mariadb-server \
mariadb-client \
iproute2 \
net-tools \
iputils-ping \
vim \
sudo \
curl \
dnsutils && rm -rf /var/lib/apt/lists/* 

# Replace all localhost ip to none in mariadb server config file so it can listen to client request on server
RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Create directory for MySQL socket and data
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
	chmod -R 777 /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql && \
	chmod -R 777 /var/lib/mysql

# Copying mariadb_launcher script and giving permisison to execute
COPY start_mariadb.sh /tmp/start_mariadb.sh
RUN  chmod +x /tmp/start_mariadb.sh

EXPOSE "3306"

# Executing script when starting container
ENTRYPOINT ["bash", "/tmp/start_mariadb.sh"]

# Starting mariadb in safe mode after script
CMD ["mysqld_safe"]