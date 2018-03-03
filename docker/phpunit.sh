#!/bin/bash
set -e

PHP_ERROR_REPORTING=${PHP_ERROR_REPORTING:-"E_ALL"}
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/apache2/php.ini
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/cli/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php/7.0/apache2/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php/7.0/cli/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php/7.0/apache2/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php/7.0/cli/php.ini

cd /var/www/ && [ -f /var/www/xmlrpc.php ] || wp --allow-root core download
[ -f /var/www/wp-config.php ] || wp --allow-root config create --dbhost=$WORDPRESS_DB_HOST --dbname=wordpress --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD
#chown -R www-data:www-data /var/www

echo "Starting Apache"
apachectl -D FOREGROUND
