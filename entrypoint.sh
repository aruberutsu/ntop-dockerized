#!/bin/bash

/usr/local/bin/ntop --set-admin-password="$NTOP_PASSWD"
/usr/local/bin/ntop "$NTOP_ARGS"
