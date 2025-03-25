FROM debian:bookworm

# Download useful package + php-fpm 
RUN apt update && apt install -y \
    vim \
    curl \
    netcat-openbsd \
    net-tools \
    dnsutils \
    iproute2 \
    iputils-ping \
    php-mysql \
    php-fpm \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-zip \
    && rm -rf /var/lib/apt/lists/*

# Copy WordPress files into the working directory
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY test-db.php /tmp/test-db.php
COPY setup_wp.sh /tmp/setup_wp.sh
RUN chmod +x /tmp/setup_wp.sh

# Exposing 9000 port for docker-network communication
EXPOSE 9000

# Command to execute when starting container
ENTRYPOINT ["/tmp/setup_wp.sh"]

# Command to execute after script -- starting php service
CMD ["/usr/sbin/php-fpm8.2", "-F"]
