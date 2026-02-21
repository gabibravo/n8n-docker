#!/bin/bash

# Stop n8n services

set -e

echo "Stopping n8n services..."
docker-compose down

echo "✅ Services stopped successfully"
