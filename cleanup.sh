#! /bin/bash

docker-compose down -v --remove-orphans

rm -rf .env
rm -rf docker/php/php-extra.ini
rm -rf docker/mariadb/createdb.sql
rm -rf docker/nginx/templates/*.template

sudo find var/log -type f -name "*.log" -exec rm -rf {} +;