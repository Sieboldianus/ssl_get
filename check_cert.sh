#!/bin/bash
# Purpose: Check expiration date of SSL in timeframe

SCRIPT=`readlink -f "$0"`
SCRIPTPATH=`dirname "$SCRIPT"`

get_expiration_date () {
    PEM=$1
    DAYS=$2
    /usr/bin/openssl x509 -enddate -noout -in "$PEM"  -checkend "$DAYS" | grep -v 'Certificate will not expire'
}

# Bourne shell(sh) syntax to source
. "$SCRIPTPATH/.env"

# get first entry,
# split by space character
CERT_NAME=${CERT_FILES%% *}

PEM="$CERT_PATH$CERT_NAME"

echo "$PEM"
# 7 days in seconds
# DAYS="604800"
# 14 days in seconds
DAYS="1209600"

echo "Checking SSL expiration date of $CERT_NAME.."

# check if exists
# and if outdated
if [ -f "$PEM" ];
then
    /usr/bin/openssl x509 -enddate -noout -in "$PEM"  -checkend "$DAYS" | grep -q 'Certificate will expire'
else
    ret_val=true
fi

# check result and optionally retrieve new
if [ $? -eq 0 ]
then
    echo "Cert not exists or will expire within $(($DAYS / 60 /60 / 24)) days. Checking for new certificate.."
    . "$SCRIPTPATH/ftp.sh"
    sleep 1
    expirationdate=$(get_expiration_date $CERT_NAME $DAYS)
    echo "Cert retrieved: $expirationdate"
    echo "Reloading service.."
    /bin/bash -c "${RESTART_CMD:-/usr/sbin/service nginx reload}"
else
    echo $PEM
    expirationdate=$(get_expiration_date $PEM $DAYS)
    echo "Expiration date not yet reached ($expirationdate)"
fi
