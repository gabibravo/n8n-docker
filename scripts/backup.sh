#!/bin/bash

# Backup n8n database and data

set -e

BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="n8n_backup_$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

echo "Creating backup: $BACKUP_NAME"

# Backup PostgreSQL database
echo "Backing up PostgreSQL database..."
docker-compose exec -T postgres pg_dump -U n8n n8n > "$BACKUP_DIR/${BACKUP_NAME}_db.sql"

# Backup n8n data
echo "Backing up n8n data..."
docker run --rm -v n8n_data:/data -v "$(pwd)/$BACKUP_DIR":/backup alpine tar czf /backup/${BACKUP_NAME}_n8n.tar.gz /data

# Backup Redis data
echo "Backing up Redis data..."
docker run --rm -v redis_data:/data -v "$(pwd)/$BACKUP_DIR":/backup alpine tar czf /backup/${BACKUP_NAME}_redis.tar.gz /data

echo "✅ Backup completed: $BACKUP_DIR/$BACKUP_NAME*"
