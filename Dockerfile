# Use the official PHP 8.1 image
FROM php:8.1.20-fpm

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    openssl \
    libssl-dev \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && rm -r /var/lib/apt/lists/*

# Configure PHP extensions
RUN docker-php-ext-install pdo_mysql zip gd

# Install Apache
RUN apt-get update && apt-get install -y apache2

# Enable Apache modules
RUN a2enmod rewrite proxy proxy_fcgi

# Copy Apache configuration
COPY apache/php-fpm.d/www.conf /usr/local/etc/php-fpm.conf
COPY apache/apache2.conf /etc/apache2/apache2.conf
COPY apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Change ownership of the document root
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache and PHP-FPM
CMD /etc/init.d/apache2 start && php-fpm
