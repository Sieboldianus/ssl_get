#!/bin/bash
# Purpose: Check expiration date of SSL in timeframe

get_expiration_date () { 
    PEM=$1
    DAYS=$2
    openssl x509 -enddate -noout -in "$PEM"  -checkend "$DAYS" | grep -v 'Certificate will not expire'
}

# Bourne shell(sh) syntax to source
. './.env'

# get first entry, 
# split by space character
CERT_NAME=${CERT_FILES%% *}

PEM="$CERT_PATH$CERT_NAME"

# 7 days in seconds
DAYS="604800"
# DAYS="10520000"

echo "Checking SSL expiration date of $CERT_NAME.."

# check if exists
# and if outdated
if [ -f "$PEM" ];
then
    _openssl="/usr/bin/openssl"
    $_openssl x509 -enddate -noout -in "$PEM"  -checkend "$DAYS" | grep -q 'Certificate will expire'
else
    ret_val=true
fi

# check result and optionally retrieve new
if [ $? -eq 0 ]
then
    echo "Cert not exists or will expire within 7 days. Checking for new certificate.."
    . './ftp.sh'
    sleep 1
    expirationdate=$(get_expiration_date $CERT_NAME $DAYS)
    echo "Cert retrieved: $expirationdate"
    echo "Reloading service.."
    eval "$RESTART_CMD"
else
    echo $PEM
    expirationdate=$(get_expiration_date $PEM $DAYS)
    echo "Expiration date not yet reached ($expirationdate)"
fi