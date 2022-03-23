#!/bin/bash

if [[ $UPDATE_GEOIP == "yes" ]]; then
    [ -e /usr/local/etc/geoip-age ] || echo 0 > /usr/local/etc/geoip-age
    if [ $(( $(date +%s) - $(cat /usr/local/etc/geoip-age) )) -gt 604800 ]; then
        echo "*** Trying to update GeoIP files, please wait..."
        if wget https://mailfud.org/geoip-legacy/GeoIPCity.dat.gz -O /tmp/GeoIPCity.dat.gz ; then
            zcat /tmp/GeoIPCity.dat.gz > /usr/local/etc/ntop/GeoLiteCity.dat
            rm /tmp/GeoIPCity.dat.gz
        fi
        if wget https://mailfud.org/geoip-legacy/GeoIPASNum.dat.gz -O /tmp/GeoIPASNum.dat.gz ; then
            zcat /tmp/GeoIPASNum.dat.gz > /usr/local/etc/ntop/GeoIPASNum.dat
            rm /tmp/GeoIPASNum.dat.gz
        fi
        date +%s > /usr/local/etc/geoip-age
    else
        echo "*** Not updating GeoIP files (last download less than a week ago)"
        echo "*** (to force, run \"echo 0 > /usr/local/etc/geoip-age\" and restart container)"
    fi
fi

/usr/local/bin/ntop --set-admin-password="$NTOP_PASSWD"
/usr/local/bin/ntop $NTOP_ARGS
