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

# Set secrets for Database and wordpress password
#RUN --mount=type=secret,id=db_admin_pwd \
#    export DB_ADMIN_PWD=$(cat /.secrets/.db_admin_pwd.txt)
#RUN --mount=type=secret,id=wp_admin_pwd \
#    export WP_ADMIN_PWD=$(cat /.secrets/.wp_admin_pwd.txt)
#RUN --mount=type=secret,id=db_pwd \
#    export DB_PWD=$(cat /.secrets/.db_pwd.txt)

# Set secrets for the WordPress-secure keys
#RUN --mount=type=secret,id=auth_key \
#    export AUTH_KEY=$(head -n 1 /.secrets/.wp-key)
#RUN --mount=type=secret,id=secure_auth_key \
#    export SECURE_AUTH_KEY=$(head -n 2 /.secrets/.wp-key)
#RUN --mount=type=secret,id=logged_in_key \
#    export LOGGED_IN_KEY=$(head -n 3 /.secrets/.wp-key)
#RUN --mount=type=secret,id=nonce_key \
#    export NONCE_KEY=$(head -n 4 /.secrets/.wp-key)
#RUN --mount=type=secret,id=auth_salt \
#    export AUTH_SALT=$(head -n 5 /.secrets/.wp-key)
#RUN --mount=type=secret,id=secure_auth_salt \
#    export SECURE_AUTH_SALT=$(head -n 6 /.secrets/.wp-key)
#RUN --mount=type=secret,id=logged_in_salt \
#    export LOGGED_IN_SALT=$(head -n 7 /.secrets/.wp-key)
#RUN --mount=type=secret,id=nonce_salt \
#    export NONCE_SALT=$(head -n 8 /.secrets/.wp-key)

# Define volume for WordPress files
VOLUME ["/var/www/cofische"]

# Copy configuration files
COPY wp-config.php /var/www/cofische/wp-config.php
COPY www.conf /etc/php/8.2/pool.d/www.conf
COPY setup_wp.sh /var/www/cofische/setup_wp.sh

# Install WordPress and set permissions
RUN cd /tmp \
    && curl -LO https://wordpress.org/latest.tar.gz \
    && tar xzvf latest.tar.gz \
    && cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php \
    && cp -a /tmp/wordpress/. /var/www/cofische \
    && mv /var/www/cofische/wp-config.php /var/www/cofische/wp-config-backup.php \
    && chown -R www-data:www-data /var/www/cofische

EXPOSE 9000

CMD ["php-fpm8.2", "cd /var/www/cofische", "./setup_wp.sh"]
