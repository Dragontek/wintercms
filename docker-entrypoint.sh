#!/bin/bash
set -e

echo 'Create/migrate database...'
php artisan winter:up

echo 'Setting permissions...'
chown -R www-data:www-data /var/www/html/storage
chmod -R 755 /var/www/html/storage

exec "$@"
