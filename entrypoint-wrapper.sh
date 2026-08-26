#!/bin/bash
set -e

a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

if [ -n "$PORT" ]; then
  sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
  sed -i "s/:80/:$PORT/" /etc/apache2/sites-available/000-default.conf
fi

mkdir -p /var/lib/php/sessions
chmod 1733 /var/lib/php/sessions
chown www-data:www-data /var/lib/php/sessions

/usr/local/bin/docker-entrypoint.sh /bin/bash -c '
if [ -f /var/www/html/ipconfig.php ]; then
  sed -i "s/^SESS_MATCH_IP=.*/SESS_MATCH_IP=false/" /var/www/html/ipconfig.php
  sed -i "s/^SESS_REGENERATE_DESTROY=.*/SESS_REGENERATE_DESTROY=false/" /var/www/html/ipconfig.php
fi
exec apache2-foreground
'
