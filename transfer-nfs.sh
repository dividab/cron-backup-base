#!/bin/sh

set -e
set -o pipefail
set -x

if [ "${NFS_MOUNT_PATH}" != "**None**" ]; then

    echo "NFS Transfer: Transfering backup file to NFS path $NFS_MOUNT_PATH"

    # Mount
    NFS_MOUNT_LOCAL_DIR=./tmp-mount
    mkdir $NFS_MOUNT_LOCAL_DIR
    mount $NFS_MOUNT_OPTIONS $NFS_MOUNT_PATH $NFS_MOUNT_LOCAL_DIR

    # Copy
    cp -a $BACKUP_FILE $NFS_MOUNT_LOCAL_DIR

    # Cleanup
    if [ "${NFS_KEEP_DAYS}" != "**None**" ]; then
        echo "NFS Transfer: Cleaning up NFS backup files older than $NFS_KEEP_DAYS days..."
        find $NFS_MOUNT_LOCAL_DIR -type f -prune -mtime +$NFS_KEEP_DAYS -exec rm -f {} \;
    fi

    # Unmount
    umount $NFS_MOUNT_LOCAL_DIR
    rm -rf $NFS_MOUNT_LOCAL_DIR

else
    echo "NFS Transfer: NFS_MOUNT_PATH not specified, skipping NFS transfer"
fi
