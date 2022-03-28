#!/bin/bash

if [[ $UPDATE_GEOIP == "yes" ]]; then
    [ -e /usr/local/var/ntop/geoip-age ] || echo 0 > /usr/local/var/ntop/geoip-age
    if [ $(( $(date +%s) - $(cat /usr/local/var/ntop/geoip-age) )) -gt 604800 ]; then
        echo "*** Trying to update GeoIP files, please wait..."
        if wget https://mailfud.org/geoip-legacy/GeoIPCity.dat.gz -O /tmp/GeoIPCity.dat.gz ; then
            zcat /tmp/GeoIPCity.dat.gz > /usr/local/var/ntop/GeoLiteCity.dat
            rm /tmp/GeoIPCity.dat.gz
        fi
        if wget https://mailfud.org/geoip-legacy/GeoIPASNum.dat.gz -O /tmp/GeoIPASNum.dat.gz ; then
            zcat /tmp/GeoIPASNum.dat.gz > /usr/local/var/ntop/GeoIPASNum.dat
            rm /tmp/GeoIPASNum.dat.gz
        fi
        date +%s > /usr/local/var/ntop/geoip-age
    else
        echo "*** Not updating GeoIP files (last download less than a week ago)"
        echo "*** (to force, run \"echo 0 > /usr/local/var/ntop/geoip-age\" and restart container)"
    fi
fi

/usr/local/bin/ntop --set-admin-password="$NTOP_PASSWD"
/usr/local/bin/ntop $NTOP_ARGS
