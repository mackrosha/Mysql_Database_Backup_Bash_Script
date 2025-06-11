#!/bin/bash

# MySQL credentials
MYSQL_USER="root"
MYSQL_PASSWORD="you Database Server Password"
DATABASES=("Database 1" "Database 2" "Database 3" "Database 4") # all Database name
MYSQL_HOST="Mysql Database ip or Localhost"

# FTP details
FTP_HOST="your FTP Server IP"
FTP_PORT="your FTP Server Port"
FTP_USER="your FTP Server User name"
FTP_PASS="your FTP Server Password"
FTP_BASE_DIR="/MySqlDatabaseBackup" #FTP Server Folder

# Date and time
CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_TIME=$(date +"%H-%M-%S")
TEMP_BACKUP_DIR="/tmp/mysql_backup_$CURRENT_DATE"

# Create temporary directory
mkdir -p "$TEMP_BACKUP_DIR"

# Loop through databases and create dumps
for DB in "${DATABASES[@]}"; do
    DUMP_FILE="${DB}_${CURRENT_DATE}_${CURRENT_TIME}.sql"
    echo "Creating backup for database: $DB"
    
    mysqldump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --databases "$DB" > "$TEMP_BACKUP_DIR/$DUMP_FILE"
    
    if [[ $? -eq 0 ]]; then
        echo "$DB database dump complete"
    else
        echo "âŒ Failed to dump $DB"
    fi
done

# Upload to FTP
echo "Uploading backups to FTP..."

lftp -u "$FTP_USER","$FTP_PASS" -p "$FTP_PORT" "$FTP_HOST" <<EOF
set ftp:ssl-allow no
mkdir -p $FTP_BASE_DIR/$CURRENT_DATE
cd $FTP_BASE_DIR/$CURRENT_DATE
mput $TEMP_BACKUP_DIR/*.sql
bye
EOF

# Cleanup local backup
rm -rf "$TEMP_BACKUP_DIR"

echo "âœ… All backups completed and uploaded to FTP."
