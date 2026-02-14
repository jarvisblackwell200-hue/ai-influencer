#!/bin/bash
# AI Influencer Pipeline — Initial Setup Script

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== AI Influencer Pipeline Setup ==="
echo "Project root: $PROJECT_ROOT"
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
if [ ! -f "$PROJECT_ROOT/n8n/credentials.env" ]; then
    echo ""
    echo "WARNING: n8n/credentials.env not found."
    echo "Copy the example and fill in your API keys:"
    echo "  cp n8n/credentials.env.example n8n/credentials.env"
    echo ""
    read -p "Create it from the template now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$PROJECT_ROOT/n8n/credentials.env.example" "$PROJECT_ROOT/n8n/credentials.env"
        echo "Created n8n/credentials.env — fill in your API keys before starting."
    else
        echo "Skipping. You must create credentials.env before starting n8n."
        exit 1
    fi
fi

# Generate encryption key if not set
if grep -q "your-encryption-key-here" "$PROJECT_ROOT/n8n/credentials.env" 2>/dev/null; then
    echo ""
    echo "Generating n8n encryption key..."
    NEW_KEY=$(openssl rand -hex 32)
    sed -i.bak "s/your-encryption-key-here/$NEW_KEY/" "$PROJECT_ROOT/n8n/credentials.env"
    rm -f "$PROJECT_ROOT/n8n/credentials.env.bak"
    echo "Encryption key set."
fi

# Start n8n
echo ""
echo "Starting n8n..."
docker compose -f "$PROJECT_ROOT/n8n/docker-compose.yml" up -d

# Wait for health check
echo "Waiting for n8n to be ready..."
for i in {1..30}; do
    if curl -sf http://localhost:5678/healthz > /dev/null 2>&1; then
        echo "n8n is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "WARNING: n8n did not become healthy within 30 seconds."
        echo "Check logs with: docker logs ai-influencer-n8n"
    fi
    sleep 1
done

echo ""
echo "=== n8n running at http://localhost:5678 ==="
echo ""
echo "Next steps:"
echo "  1. Open http://localhost:5678 and set up your n8n account"
echo "  2. Fill in API keys in n8n/credentials.env (if not done)"
echo "  3. Set up webhook tunnel:"
echo "     Option A: cloudflared tunnel --url http://localhost:5678"
echo "     Option B: ngrok http 5678"
echo "  4. Update WEBHOOK_URL in credentials.env with the tunnel URL"
echo "  5. Create Telegram bot via @BotFather"
echo "  6. Run scripts/test-apis.sh to verify connections"
echo ""
echo "=== Setup Complete ==="
