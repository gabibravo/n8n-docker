#!/bin/bash

# 🚀 Helper script: Deploy n8n to Digital Ocean Droplet
# Usage: ./deploy-to-droplet.sh DROPLET_IP

set -e

if [ -z "$1" ]; then
    echo "❌ Error: Droplet IP not provided"
    echo ""
    echo "Usage: ./deploy-to-droplet.sh DROPLET_IP"
    echo "Example: ./deploy-to-droplet.sh 123.45.67.89"
    exit 1
fi

DROPLET_IP=$1
PROJECT_DIR="/root/n8n-docker"

echo "🚀 Starting n8n deployment to Droplet at $DROPLET_IP"
echo ""

# Function to run remote command
run_remote() {
    local desc="$1"
    local cmd="$2"
    
    echo "⏳ $desc..."
    ssh -o StrictHostKeyChecking=no root@$DROPLET_IP "$cmd"
    echo "✅ $desc"
    echo ""
}

# Step 1: Update system
run_remote "Updating system" \
    "apt-get update && apt-get upgrade -y"

# Step 2: Install Docker
run_remote "Installing Docker" \
    "curl -fsSL https://get.docker.com | sh"

# Step 3: Install Docker Compose
run_remote "Installing Docker Compose" \
    "curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)' \
    -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose"

# Step 4: Clone repository
run_remote "Cloning repository" \
    "git clone https://github.com/gabibravo/n8n-docker.git $PROJECT_DIR"

# Step 5: Copy environment file
echo "⏳ Setting up environment file..."
ssh root@$DROPLET_IP "cp $PROJECT_DIR/.env.example $PROJECT_DIR/.env"
echo "✅ Environment file created"
echo ""

# Step 6: Instructions for manual env setup
echo "🔑 IMPORTANT: Set up environment variables"
echo "   Connect to your Droplet and edit .env:"
echo ""
echo "   ssh root@$DROPLET_IP"
echo "   nano $PROJECT_DIR/.env"
echo ""
echo "   Change as minimum:"
echo "   - DB_PASSWORD=GenerarSuContraseña123!"
echo "   - N8N_BASIC_AUTH_PASSWORD=GenerarOtraContraseña456!"
echo ""
read -p "Press Enter once you've updated .env file and saved it..."

# Step 7: Start services
run_remote "Starting Docker Compose services" \
    "cd $PROJECT_DIR && docker-compose up -d"

# Step 8: Wait for services
echo "⏳ Waiting for services to start (30 seconds)..."
sleep 30

# Step 9: Check health
echo "⏳ Checking service health..."
ssh root@$DROPLET_IP "cd $PROJECT_DIR && docker-compose ps"

echo ""
echo "========================================="
echo "✅ Deployment Complete!"
echo "========================================="
echo ""
echo "🎉 n8n is running at:"
echo "   http://$DROPLET_IP:5678"
echo ""
echo "📝 Credentials:"
echo "   Username: admin"
echo "   Password: The one you set in .env"
echo ""
echo "📱 Next steps:"
echo "   1. Access n8n at http://$DROPLET_IP:5678"
echo "   2. (Optional) Configure domain and SSL in DEPLOY_DIGITAL_OCEAN.md"
echo "   3. (Optional) Set up backups with: ssh root@$DROPLET_IP 'cd $PROJECT_DIR && ./scripts/backup.sh'"
echo ""
echo "📚 Documentation:"
echo "   - DEPLOY_DIGITAL_OCEAN.md - Full deployment guide"
echo "   - SOLUTION_SUMMARY.md - Problem & solution overview"
echo "   - DIGITAL_OCEAN_FIX.md - Troubleshooting"
echo ""
