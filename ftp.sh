#!/bin/sh

cd $CERT_PATH
ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
cd certs
prompt
mget $FILE
quit
END_SCRIPT