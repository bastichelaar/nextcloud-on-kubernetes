#!/bin/bash

# Exit on failure
set -e

# Install Nextcloud
occ maintenance:install \
        --database=$DB_TYPE \
        --database-name=$DB_NAME \
        --database-host=$DB_HOST \
        --database-port=$DB_PORT \
        --database-user=$DB_USER \
        --database-pass=$DB_PASSWORD \
        --admin-user=$ADMIN_USER \
        --admin-pass=$ADMIN_PASSWORD \
        --no-interaction

# Disable firstrun
occ app:disable firstrunwizard

# Set the correct values
occ config:system:set trusted_domains 1 --value $TRUSTED_DOMAINS
occ config:system:set overwrite.cli.url --value $NEXTCLOUD_URL
occ config:system:set logtimezone --value $TIMEZONE

# Add Redis caching
occ config:system:set memcache.local --value "\OC\Memcache\Redis"
occ config:system:set redis host --value localhost
occ config:system:set redis port --value 6379

# Enable webcron
occ background:webcron
