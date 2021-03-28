#!/usr/bin/env bash
[ "$1" ] || { echo "usage: ./setup.sh <FQDN>" 1>&2 ; exit 1;  }
[ -f ".env" ] || cp env.setup .env
MYSQL_ROOT_PASSWORD=$(pwgen 16 1)
MYSQL_PASSWORD=$(pwgen 16 1)
sed -i  -e "s/{{VIRTUAL_HOST}}/$1/g" \
        -e "s/{{MYSQL_ROOT_PASSWORD}}/${MYSQL_ROOT_PASSWORD}/g" \
        -e "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}/g" .env
echo -n "continue with startup? " && read dummy
docker-compose -f docker-compose.yml up -d --build
echo -n "show startup logs? " && read dummy
docker-compose -f docker-compose.yml logs -f --tail 1000
