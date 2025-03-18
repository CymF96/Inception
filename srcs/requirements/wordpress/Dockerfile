FROM debian:bookworm

RUN apt update && apt install -y \
    vim \
    curl \
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

# Set working directory
RUN mkdir -p /var/www/cofische

# Install WordPress
RUN cd /tmp \
    && curl -LO https://wordpress.org/latest.tar.gz \
    && tar xzvf latest.tar.gz \
    && cp -a /tmp/wordpress/. /var/www/cofische/ \
    && chown -R www-data:www-data /var/www/cofische \
    && chmod -R 755 /var/www/cofische \
    && rm -rf /tmp/wordpress/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy WordPress files into the working directory
COPY wp-config.php /tmp/
COPY www.conf /etc/php/8.2/pool.d/www.conf
COPY setup_wp.sh /tmp/setup_wp.sh
RUN chmod +x /tmp/setup_wp.sh /tmp/wp-config.php

EXPOSE 9000

VOLUME ["/var/www/cofische"]

ENTRYPOINT ["/tmp/setup_wp.sh"]

CMD ["/usr/sbin/php-fpm8.2", "-F"]
