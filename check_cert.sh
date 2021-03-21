#!/bin/bash
# Purpose: Check expiration date of SSL in timeframe

CERT_PATH="/etc/apache2/ssl/"
CERT_NAME="sample.crt"

PEM="$CERT_PATH$CERT_NAME"

# 7 days in seconds
DAYS="604800"
# DAYS="10520000"

echo "Checking SSL expiration date.."

_openssl="/usr/bin/openssl"
$_openssl x509 -enddate -noout -in "$PEM"  -checkend "$DAYS" | grep -q 'Certificate will expire'

# Send email and push message to my mobile
if [ $? -eq 0 ]
then
    echo "Cert will expire within 7 days. Checking for new certificate.."
    sh ./ftp.sh
    expirationdate=$(openssl x509 -enddate -noout -in "$PEM"  -checkend "$DAYS")
    echo -e "Cert retrieved: \n$expirationdate"
else
    echo "Expiration date not yet reached"
fi