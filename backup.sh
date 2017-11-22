#!/bin/sh

# This script calls the dump.sh script and then transfers the resulting file

set -e
set -o pipefail

# Set variables for file
BACKUP_DIR="/backup"
BACKUP_FILE_NAME="$FILE_PREFIX"_$(date +"%Y-%m-%dT%H_%M_%SZ")
BACKUP_FILE=$BACKUP_DIR/$BACKUP_FILE_NAME

# Dump
source ./dump.sh

# Transfer
source ./transfer-local.sh
source ./transfer-ftp.sh
source ./transfer-nfs.sh

# Cleanup the dump
echo "Cleaning up local backup file"
rm $BACKUP_DIR/$BACKUP_FILE_NAME

# Message about success
echo "Dump and transfer completed, filename: $BACKUP_FILE_NAME"
