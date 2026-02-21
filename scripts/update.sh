#!/bin/bash

# Update and restart services

set -e

SERVICE=${1:-all}

echo "Updating n8n services..."

if [ "$SERVICE" = "all" ] || [ "$SERVICE" = "compose" ]; then
    echo "📦 Pulling latest images..."
    docker-compose pull
fi

if [ "$SERVICE" = "all" ]; then
    echo "🔄 Restarting all services..."
    docker-compose up -d --force-recreate
    
elif [ "$SERVICE" = "n8n" ]; then
    echo "🔄 Restarting n8n..."
    docker-compose restart n8n
    
elif [ "$SERVICE" = "postgres" ]; then
    echo "🔄 Restarting PostgreSQL..."
    docker-compose restart postgres
    
elif [ "$SERVICE" = "redis" ]; then
    echo "🔄 Restarting Redis..."
    docker-compose restart redis
    
else
    echo "Usage: update.sh [all|n8n|postgres|redis]"
    exit 1
fi

echo "✅ Update complete"
