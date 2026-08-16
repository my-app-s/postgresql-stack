#!/bin/bash

set -e

CONTAINER="postgres"
DB_NAME="appdb"
DB_USER="postgres"

FILE=$1

if [ -z "$FILE" ]; then
  echo "Usage: ./restore.sh backup_file.sql"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "File not found: $FILE"
  exit 1
fi

echo "Restoring database from $FILE"

docker exec -i $CONTAINER psql -U $DB_USER $DB_NAME < "$FILE"

echo "Restore completed."