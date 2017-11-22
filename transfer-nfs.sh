#!/bin/sh

set -e
set -o pipefail
set -x

if [ "${NFS_MOUNT_PATH}" != "**None**" ]; then

    echo "NFS Transfer: Transfering backup file to NFS path $NFS_MOUNT_PATH"

    # Mount
    NFS_MOUNTPOINT=./tmp-mount
    mkdir $NFS_MOUNTPOINT
    # Busybox is not capable of mounting NFS shares with locking enabled. Use the option -o nolock for NFS mounts.
    # Maybe CONFIG_NFS_V3 can be used instead of vers=2
    mount -o nolock,vers=2 -t nfs $NFS_MOUNT_OPTIONS $NFS_MOUNT_PATH $NFS_MOUNTPOINT

    # Copy
    cp $BACKUP_FILE $NFS_MOUNTPOINT

    # Cleanup
    if [ "${NFS_KEEP_DAYS}" != "**None**" ]; then
        echo "NFS Transfer: Cleaning up NFS backup files older than $NFS_KEEP_DAYS days..."
        find $NFS_MOUNT_LOCAL_DIR -type f -prune -mtime +$NFS_KEEP_DAYS -exec rm -f {} \;
    fi

    # Unmount
    umount $NFS_MOUNTPOINT
    rm -rf $NFS_MOUNTPOINT

else
    echo "NFS Transfer: NFS_MOUNT_PATH not specified, skipping NFS transfer"
fi
