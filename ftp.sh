#!/bin/sh
HOST='100.100.10.1'
USER='sample'
PASSWD='sample'
FILE='sample.crt sample.key'

cd /etc/apache2/ssl/
ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
cd certs
prompt
mget $FILE
quit
END_SCRIPT
exit 0