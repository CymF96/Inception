FROM debian:buster

# installaing useful packages + mariadb
RUN apt-get update -y && apt-get install -y \
mariadb-server \
mariadb-client \
vim \
curl \
dnsutils 

# Copying mariadb_launcher script and giving permisison to execute
COPY start_mariadb.sh /tmp/start_mariadb.sh
RUN  chmod +x /tmp/start_mariadb.sh

# Replace all localhost ip to none in mariadb server config file so it can listen to client request on server
RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 

EXPOSE "3306"

# Executing script when starting container
ENTRYPOINT ["bash", "/tmp/start_mariadb.sh"]

# Starting mariadb in safe mode after script
CMD ["mysqld_safe"]