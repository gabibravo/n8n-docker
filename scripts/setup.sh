#!/bin/bash

# N8N Docker Setup Script
# This script sets up and initializes n8n with Docker

set -e

echo "================================================"
echo "n8n Docker Setup Script"
echo "================================================"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "ℹ️  Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your configuration before starting"
    echo "   Important: Change default passwords!"
    exit 0
fi

# Create SSL directory if not exists
mkdir -p nginx/ssl

# Pull latest images
echo ""
echo "📦 Pulling Docker images..."
docker-compose pull

# Create and start containers
echo ""
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services to be healthy
echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 10

# Check if n8n is responding
echo ""
echo "🔍 Checking n8n health..."
if docker-compose exec -T n8n wget --quiet --tries=1 --spider http://localhost:5678/healthz; then
    echo "✅ n8n is now running!"
else
    echo "⚠️  n8n might still be starting. Check logs with: docker-compose logs -f n8n"
fi

echo ""
echo "================================================"
echo "Setup Complete!"
echo "================================================"
echo ""
echo "Access n8n at: http://localhost:5678"
echo ""
echo "Next steps:"
echo "1. Check logs: docker-compose logs -f"
echo "2. View n8n UI: http://localhost:5678"
echo "3. Stop services: docker-compose down"
echo "4. View volumes: docker volume ls | grep n8n"
echo ""
