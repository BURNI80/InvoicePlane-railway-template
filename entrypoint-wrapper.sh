#!/bin/bash
set -e

a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

if [ -n "$PORT" ]; then
  sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
  sed -i "s/:80/:$PORT/" /etc/apache2/sites-available/000-default.conf
fi

exec /docker-entrypoint.sh "$@"
