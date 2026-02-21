#!/bin/bash

# Health check script for n8n services

set -e

TIMEOUT=${1:-30}
COUNTER=0

echo "Checking n8n services health..."

# Check PostgreSQL
echo "📊 Checking PostgreSQL..."
while ! docker-compose exec -T postgres pg_isready -U n8n > /dev/null 2>&1; do
    if [ $COUNTER -ge $TIMEOUT ]; then
        echo "❌ PostgreSQL health check failed"
        exit 1
    fi
    COUNTER=$((COUNTER + 1))
    sleep 1
done
echo "✅ PostgreSQL is healthy"

# Check Redis
COUNTER=0
echo "🔴 Checking Redis..."
while ! docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; do
    if [ $COUNTER -ge $TIMEOUT ]; then
        echo "❌ Redis health check failed"
        exit 1
    fi
    COUNTER=$((COUNTER + 1))
    sleep 1
done
echo "✅ Redis is healthy"

# Check n8n
COUNTER=0
echo "⚙️  Checking n8n..."
while ! docker-compose exec -T n8n wget --quiet --tries=1 --spider http://localhost:5678/healthz > /dev/null 2>&1; do
    if [ $COUNTER -ge $TIMEOUT ]; then
        echo "❌ n8n health check failed"
        exit 1
    fi
    COUNTER=$((COUNTER + 1))
    sleep 1
done
echo "✅ n8n is healthy"

echo ""
echo "================================================"
echo "✅ All services are healthy!"
echo "================================================"
