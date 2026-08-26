#!/bin/bash
set -e

# Disable extra MPMs before starting Apache
# The base Debian image loads multiple MPMs which causes:
# "AH00534: apache2: Configuration error: More than one MPM loaded."
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Execute the original entrypoint
exec /docker-entrypoint.sh "$@"
