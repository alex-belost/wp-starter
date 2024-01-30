FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache neovim curl

# Set working directory
WORKDIR /var/www/html

# Install PHP extensions
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo pdo_mysql

# Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Bedrock using Composer
RUN composer create-project roots/bedrock /var/www/html

# Set the correct permissions for directories and files
RUN find /var/www/html -type d -exec chmod 755 {} \;
RUN find /var/www/html -type f -exec chmod 644 {} \;

# Ensure scripts are executable
RUN chmod +x /var/www/html

# Set the correct ownership (Adjust 'www-data' if your web server user is different)
# Note: 'www-data' is the default user for Nginx and Apache in many images, but you might need to adjust it based on your specific image
RUN chown -R www-data:www-data /var/www/html

# Run composer install to install dependencies
# RUN composer install
