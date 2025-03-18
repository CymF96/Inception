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

# Install WordPress and set permissions
RUN cd /tmp \
    && curl -LO https://wordpress.org/latest.tar.gz \
    && tar xzvf latest.tar.gz \
    && mkdir -p /var/www/cofische \
    && cp -a /tmp/wordpress/. /var/www/cofische \
    && chown -R www-data:www-data /var/www/cofische \
    && chmod -R 755 /var/www/cofische

# Copy configuration files
COPY wp-config.php /var/www/cofische/wp-config.php
RUN chown www-data:www-data /var/www/cofische/wp-config.php && chmod +x /var/www/cofische/wp-config.php
COPY www.conf /etc/php/8.2/pool.d/www.conf
COPY setup_wp.sh /tmp/setup_wp.sh
RUN chmod +x /tmp/setup_wp.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

# Define volume for WordPress files
VOLUME ["/var/www/cofische"]

ENTRYPOINT ["/tmp/setup_wp.sh"]
