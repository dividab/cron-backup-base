# cron-backup-base

Dumping a backup file and transfer it via FTP or NFS (supports periodic backups and health checking)

# Settings

The container will either run the dump and transfer once and exit, or if the `SCHEDULE` variable is set, start [go-cron](https://github.com/odise/go-cron/releases) to schedule periodic backup.

This is just a base image that handles the transfer and scheduling. It contains a dummy `dump.sh` script that will create a dummy file. In order to use it you will need to create your own `Dockerfile` that is based on this image and adds a real `dump.sh` script, for example one that dumps a database to a file.

These settings can be passed as environment variables to the container:

| Name                      | Description                                  | Required | Default              |
| ------------------------- | -------------------------------------------- | ---------|---------- |
| BACKUP_FILE_PREFIX        | Prefix of the backup file, eg. database name | No       | `backup` |
| BACKUP_KEEP_DAYS          | The number of days to keep file dups locally | No       | `**None**` |
| BACKUP_FTP_URL            | The URL to FTP the database dump to          | No       | `**None**` |
| BACKUP_SCHEDULE           | Cron schedule string, see below              | No       | `**None**` |

## BACKUP_FILE_PREFIX

The prefix of the created backupfile. It will have a suffix of `_$(date +%Y-%m-%d_%H_%M_%N)` automatically added. Use it to prefix the file with for example a database name.

## BACKUP_KEEP_DAYS

The number of days to keep the files that are dumped locally within the container. By default the local file is deleted directly after successful transfer.

## BACKUP_FTP_URL

The FTP_URL is in `curl` format, for example: `ftp://user:pass@ftp.mysite.com:2021/backups/myapp/`. Note the slash at the end!

## BACKUP_SCHEDULE

```
## * * * * * command to be executed
## - - - - -
## | | | | |
## | | | | +----- day of week (0 - 6) (Sunday=0)
## | | | +------- month (1 - 12)
## | | +--------- day of month (1 - 31)
## | +----------- hour (0 - 23)
## +------------- min (0 - 59)

## Field name     Mandatory?   Allowed values    Allowed special characters
## ----------     ----------   --------------    --------------------------
## Seconds        No           0-59              * / , -
## Minutes        Yes          0-59              * / , -
## Hours          Yes          0-23              * / , -
## Day of month   Yes          1-31              * / , - L W
## Month          Yes          1-12 or JAN-DEC   * / , -
## Day of week    Yes          0-6 or SUN-SAT    * / , - L #
## Year           No           1970–2099         * / , -

# EXAMPLE: Every day at 01:00

0 1 * * * backup.sh

# EXAMPLE: Test to run every 5 seconds

# */5 * * * * * * echo "hello"
```

# How to create a image based on this image

To base an image of this image you just need to add a `dump.sh` script file which will be called by this image's script. This image will set the variables `$BACKUP_DIR` and `$BACKUP_FILE` before calling the `dump.sh` script. The job for the `dump.sh` script is to create a file at the path `$BACKUP_DIR/$BACKUP_FILE`. The file at this path will then be transfered to the specified destinations by this image's script.

Example Dockerfile:

```
FROM cron-backup-base

ADD dump.sh
```

# Health checking

Health checking is supported through [go-cron](https://github.com/odise/go-cron/releases). TODO: Enable it!

# Manually triggering backup

To manually trigger a backup you can exec a shell in the container and run this command:

```
$ backup.sh
```

