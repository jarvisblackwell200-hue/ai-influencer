#!/bin/bash
# AI Influencer Pipeline — Initial Setup Script

set -e

echo "=== AI Influencer Pipeline Setup ==="
echo ""

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed."
    echo "Install Docker Desktop from https://www.docker.com/products/docker-desktop/"
    exit 1
fi
echo "Docker found: $(docker --version)"

# Check Docker Compose
if ! docker compose version &> /dev/null; then
    echo "ERROR: Docker Compose is not available."
    exit 1
fi
echo "Docker Compose found: $(docker compose version)"

# Check for credentials file
if [ ! -f "n8n/credentials.env" ]; then
    echo ""
    echo "WARNING: n8n/credentials.env not found."
    echo "Copy the example and fill in your API keys:"
    echo "  cp n8n/credentials.env.example n8n/credentials.env"
    echo "  nano n8n/credentials.env"
    echo ""
    read -p "Would you like to create it from the template now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp n8n/credentials.env.example n8n/credentials.env
        echo "Created n8n/credentials.env — please fill in your API keys before starting."
    fi
fi

# Start n8n
echo ""
echo "Starting n8n..."
cd n8n
docker compose up -d
cd ..

echo ""
echo "n8n is starting at http://localhost:5678"
echo ""
echo "Next steps:"
echo "  1. Fill in API keys in n8n/credentials.env"
echo "  2. Set up Cloudflare Tunnel or ngrok for webhook access"
echo "  3. Create Telegram bot via @BotFather"
echo "  4. Run scripts/test-apis.sh to verify connections"
echo ""
echo "=== Setup Complete ==="
