FROM debian:bookworm

RUN apt update && apt install -y \
    vim \
    curl \
    dnsutils \
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
COPY setup_wp.sh /tmp/setup_wp.sh
RUN chmod +x /tmp/setup_wp.sh

EXPOSE 9000

ENTRYPOINT ["/tmp/setup_wp.sh"]

CMD ["/usr/sbin/php-fpm8.2", "-F"]
