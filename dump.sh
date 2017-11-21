#!/bin/bash

set -e
set -o pipefail

echo "Dummy dump file" > $BACKUP_DIR/$BACKUP_FILE
