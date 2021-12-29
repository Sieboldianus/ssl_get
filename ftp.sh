#!/bin/sh

cd $CERT_PATH
ftp -v -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASSWD
binary
cd certs
prompt
mget $CERT_FILES
quit
END_SCRIPT
exit 0