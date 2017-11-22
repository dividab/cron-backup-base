# cron-backup-base

Dumping a backup file and transfer it via FTP or NFS (supports periodic backups and health checking)

# Settings

The container will either run the dump and transfer once and exit, or if the `SCHEDULE` variable is set, start [go-cron](https://github.com/odise/go-cron/releases) to schedule periodic backup.

This is just a base image that handles the transfer and scheduling. It contains a dummy `dump.sh` script that will create a dummy file. In order to use it you will need to create your own `Dockerfile` that is based on this image and adds a real `dump.sh` script, for example one that dumps a database to a file.

The settings are divided into a section of general settings that affects the flow and a section for each transfer type that is optional.

## General settings

| Name               | Description                                   | Required  | Default    |
| ------------------ | --------------------------------------------- | --------- | ---------- |
| FILE_PREFIX        | Prefix of the backup file, eg. database name  | No        | `backup`   |
| SCHEDULE           | Cron schedule string, see below               | No        | `**None**` |

### FILE_PREFIX

The prefix of the created backupfile. It will have a suffix of `_$(date +"%Y-%m-%dT%H_%M_%SZ")` automatically added. Use it to prefix the file with for example a database name.

### SCHEDULE

This variable takes a standard `cron` schedule string. See below for details.

```
* * * * * * *
- - - - - - -
| | | | | | |
| | | | | | + ---- year, optional
| | | | | +------- day of week (0 - 6) (Sunday=0)
| | | | +--------- month (1 - 12)
| | | +----------- day of month (1 - 31)
| | +------------- hour (0 - 23)
| +--------------- min (0 - 59)
+----------------- second (0 - 59), optional
```

| Field name     | Mandatory?   | Allowed values    | Allowed special characters |
| -------------- | ------------ | ----------------- | -------------------------- |
| Seconds        | No           | 0-59              | `* / , -`                  |
| Minutes        | Yes          | 0-59              | `* / , -`                  |
| Hours          | Yes          | 0-23              | `* / , -`                  |
| Day of month   | Yes          | 1-31              | `* / , - L W`              |
| Month          | Yes          | 1-12 or JAN-DEC   | `* / , -`                  |
| Day of week    | Yes          | 0-6 or SUN-SAT    | `* / , - L #`              |
| Year           | No           | 1970–2099         | `* / , -`                  |

```
EXAMPLE: Every day at 01:00

0 1 * * *

EXAMPLE: Every 5 seconds

*/5 * * * * * *
```

## LOCAL Transfer Settings

| Name               | Description                                   | Required  | Default    |
| ------------------ | --------------------------------------------- | --------- | ---------- |
| LOCAL_DIR          | Path to local dir to transfer dump file to    | No        | `**None**` |
| LOCAL_KEEP_DAYS    | The number of days to keep file dumps locally | No        | `**None**` |

If these variables are set then the file will be transfered to a local dir accordingly. You can mount a volume into the local dir in order to store it externally.

`LOCAL_KEEP_DAYS`: The number of days to keep the files that are dumped locally within the container. By default the local file is deleted directly after successful transfer.

## FTP Transfer Settings

| Name               | Description                                   | Required  | Default    |
| ------------------ | --------------------------------------------- | --------- | ---------- |
| FTP_HOST           | The FTP host to transfer to                   | No        | `**None**` |
| FTP_PORT           | The FTP port                                  | No        | `21`       |
| FTP_DIR            | The FTP directory                             | No        | `**None**` |
| FTP_USER           | The FTP user name                             | No        | `**None**` |
| FTP_PASSWORD       | The URL to FTP the database dump to           | No        | `**None**` |

If these variables are set then the file will be transfered via FTP accordingly.

Example:

```
FTP_HOST=ftp.mysite.com
FTP_PORT=2021
FTP_DIR=backups/myapp/ # Note the slash at the end!
FTP_USER=myusername
FTP_PASSWORD=mypassword
```

## NFS Transfer Settings

| Name               | Description                                   | Required  | Default    |
| ------------------ | --------------------------------------------- | --------- | ---------- |
| NFS_MOUNT_PATH     | The NFS path to transfer to                   | No        | `**None**` |
| NFS_MOUNT_OPTIONS  | The NFS mount options                         | No        | `''`       |

# How to create a image based on this image

To create an image based on this image you just need to add a `dump.sh` script file.

This image will set the variable `$BACKUP_FILE` and then call the `dump.sh` script. The job for the `dump.sh` script is to create a file at the path `$BACKUP_FILE`. Note that `$BACKUP_FILE` contains the full path to the file (not just the file name). The file at this path will then be transfered to the specified destinations by this image's script.

Example minimum `Dockerfile` based on this image:

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

