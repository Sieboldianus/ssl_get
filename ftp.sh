#!/bin/sh

cd "$CERT_PATH" || exit
ftp -v -n "$FTP_HOST" <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASSWD
binary
cd $FTP_CERTS_DIR
prompt
mget $CERT_FILES
quit
END_SCRIPT
