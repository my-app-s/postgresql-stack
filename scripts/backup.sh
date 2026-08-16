#!/bin/bash

set -e

CONTAINER="postgres"
DB_NAME="appdb"
DB_USER="postgres"

BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR

DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILE="$BACKUP_DIR/${DB_NAME}_$DATE.sql"

echo "Creating backup: $FILE"

docker exec -i $CONTAINER pg_dump -U $DB_USER $DB_NAME > $FILE

echo "Backup saved."