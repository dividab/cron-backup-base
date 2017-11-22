#!/bin/sh

# Exit if a command fails
set -e

# Install curl
apk --no-cache add curl

# Install nfs
apk --no-cache add nfs-utils

# Install go-cron
curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
