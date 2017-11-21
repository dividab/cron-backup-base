FROM alpine:3.5

# Set default variable values
ENV BACKUP_FILE_PREFIX backup
ENV BACKUP_KEEP_DAYS **None**
ENV BACKUP_FTP_URL **None**
ENV BACKUP_SCHEDULE **None**

# Run install
ADD install.sh install.sh
RUN sh install.sh && rm install.sh

# Create backup dir
RUN mkdir /backup

# Add scripts
ADD run.sh run.sh
ADD backup.sh backup.sh

# The dump script is just a dummy
ADD dump.sh dump.sh

# Run once or start gp-cron
CMD ["sh", "run.sh"]
