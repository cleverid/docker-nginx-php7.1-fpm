#!/bin/bash

set -euo pipefail

NGINX_ROOT=${NGINX_ROOT:=/var/www}

# Tweak nginx to match the workers to cpu's
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes.*/worker_processes $procs;/" /etc/nginx/nginx.conf

# Again set the right permissions (needed when mounting from a volume)
set +e
chown -Rf www-data:www-data $NGINX_ROOT
set -e

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf