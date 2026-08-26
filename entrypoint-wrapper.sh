#!/bin/bash
set -e

# Disable extra MPMs before starting Apache
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Configure Apache to listen on Railway's PORT
if [ -n "$PORT" ]; then
  sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
  sed -i "s/:80/:$PORT/" /etc/apache2/sites-available/000-default.conf
fi

# Execute the original entrypoint
exec /docker-entrypoint.sh "$@"
