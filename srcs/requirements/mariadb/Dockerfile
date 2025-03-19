FROM debian:bookworm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    vim \
    mariadb-server

# Ensure proper permissions for MariaDB directories
RUN mkdir -p /var/run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql \
    && chmod 777 /var/run/mysqld

# Copy startup script and give execution permissions
COPY start_mariadb.sh /tmp/start_mariadb.sh
RUN chmod +x /tmp/start_mariadb.sh && chown mysql:mysql /tmp/start_mariadb.sh

# Expose the MariaDB port
EXPOSE 3306

# Define a volume for persistent data
VOLUME ["/var/lib/mysql"]

# Set the default user to mysql for security
USER mysql

# Start MariaDB safely
ENTRYPOINT ["/tmp/start_mariadb.sh"]