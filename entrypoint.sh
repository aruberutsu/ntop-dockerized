#!/bin/bash

if [[ $UPDATE_GEOIP == "yes" ]]; then
    echo "*** Trying to update GeoIP files, please wait..."
    if wget https://mailfud.org/geoip-legacy/GeoIPCity.dat.gz -O /tmp/GeoIPCity.dat.gz ; then
        zcat /tmp/GeoIPCity.dat.gz > /usr/local/etc/ntop/GeoLiteCity.dat
        rm /tmp/GeoIPCity.dat.gz
    fi
    if wget https://mailfud.org/geoip-legacy/GeoIPASNum.dat.gz -O /tmp/GeoIPASNum.dat.gz ; then
        zcat /tmp/GeoIPASNum.dat.gz > /usr/local/etc/ntop/GeoIPASNum.dat
        rm /tmp/GeoIPASNum.dat.gz
    fi
fi

/usr/local/bin/ntop --set-admin-password="$NTOP_PASSWD"
/usr/local/bin/ntop "$NTOP_ARGS"
