#!/bin/sh

if [ -z ${SCP_KEY+x} ];
then
    for cert in $CERT_FILES
    do
        sshpass -p $SCP_PASSWD scp -v -o PreferredAuthentications="password" \
        $SCP_USER@$SCP_HOST:$SCP_CERTS_DIR/$cert $CERT_PATH/$cert
    done
else
    for cert in $CERT_FILES
    do
        scp -i $SCP_KEY \
            $SCP_USER@$SCP_HOST:$SCP_CERTS_DIR/$cert $CERT_PATH/$cert
    done
fi