#!/bin/bash

set -e

CONTAINER="postgres"
DB_NAME="appdb"
DB_USER="postgres"

echo "Creating database if not exists: $DB_NAME"

docker exec -i $CONTAINER psql -U $DB_USER -tc "
SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';
" | grep -q 1 || \
docker exec -i $CONTAINER psql -U $DB_USER -c "CREATE DATABASE $DB_NAME;"

echo "Database ready."