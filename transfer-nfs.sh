#!/bin/sh

set -e
set -o pipefail

if [ "${NFS_HOST}" != "**None**" ]; then
    echo "Uploading backup file ${BACKUP_FILE_NAME} to FTP..."
    FTP_URL=ftp://$FTP_USER:$FTP_PASSWORD@$FTP_HOST:$FTP_PORT/$FTP_PATH
    curl --ftp-create-dirs -T $BACKUP_DIR/$BACKUP_FILE_NAME $FTP_URL -k --ftp-ssl
else
    echo "NFS_HOST not specified, skipping NFS transfer"
fi
