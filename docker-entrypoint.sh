#!/bin/bash
set -e

if [ ! -e '/var/www/html/version.php' ]; then
    tar cf - --one-file-system -C /usr/src/nextcloud . | tar xf -
    mkdir /var/www/html/apps2
    chown -R www-data /var/www/html
fi


if [ ! -f /var/www/html/config.php ]; then
    # New installation, run the setup
    /usr/local/bin/setup.sh
else
    occ upgrade
    if [ \( $? -ne 0 \) -a \( $? -ne 3 \) ]; then
        echo "Trying ownCloud upgrade again to work around ownCloud upgrade bug..."
        occ upgrade
        if [ \( $? -ne 0 \) -a \( $? -ne 3 \) ]; then exit 1; fi
        occ maintenance:mode --off
        echo "...which seemed to work."
    fi
fi

chown -R www-data:www-data /var/www/html

exec "$@"
