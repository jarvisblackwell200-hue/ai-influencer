#!/bin/bash
# AI Influencer — API Connectivity Tests
# Tests all required API endpoints

set -e

# Load credentials
if [ -f "n8n/credentials.env" ]; then
    source n8n/credentials.env
fi

PASS=0
FAIL=0

test_api() {
    local name="$1"
    local result="$2"
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        echo "  PASS: $name"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: $name"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== API Connectivity Tests ==="
echo ""

# 1. Anthropic (Claude)
echo "[1/6] Testing Anthropic API..."
if [ -n "$ANTHROPIC_API_KEY" ]; then
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST "https://api.anthropic.com/v1/messages" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d '{"model":"claude-sonnet-4-5-20250929","max_tokens":10,"messages":[{"role":"user","content":"ping"}]}')
    if [ "$RESULT" = "200" ]; then
        echo "  PASS: Anthropic API"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: Anthropic API (HTTP $RESULT)"
        FAIL=$((FAIL + 1))
    fi
else
    echo "  SKIP: ANTHROPIC_API_KEY not set"
fi

# 2. fal.ai
echo "[2/6] Testing fal.ai API..."
if [ -n "$FAL_KEY" ]; then
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://fal.run/fal-ai/flux-pro/v1.1" \
        -H "Authorization: Key $FAL_KEY")
    if [ "$RESULT" != "000" ]; then
        echo "  PASS: fal.ai API (reachable)"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: fal.ai API (unreachable)"
        FAIL=$((FAIL + 1))
    fi
else
    echo "  SKIP: FAL_KEY not set"
fi

# 3. ElevenLabs
echo "[3/6] Testing ElevenLabs API..."
if [ -n "$ELEVENLABS_API_KEY" ]; then
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://api.elevenlabs.io/v1/voices" \
        -H "xi-api-key: $ELEVENLABS_API_KEY")
    if [ "$RESULT" = "200" ]; then
        echo "  PASS: ElevenLabs API"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: ElevenLabs API (HTTP $RESULT)"
        FAIL=$((FAIL + 1))
    fi
else
    echo "  SKIP: ELEVENLABS_API_KEY not set"
fi

# 4. Telegram Bot
echo "[4/6] Testing Telegram Bot API..."
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    RESULT=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getMe" | python3 -c "import json,sys; print(json.load(sys.stdin).get('ok', False))")
    if [ "$RESULT" = "True" ]; then
        echo "  PASS: Telegram Bot API"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: Telegram Bot API"
        FAIL=$((FAIL + 1))
    fi
else
    echo "  SKIP: TELEGRAM_BOT_TOKEN not set"
fi

# 5. Buffer
echo "[5/6] Testing Buffer API..."
if [ -n "$BUFFER_ACCESS_TOKEN" ]; then
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://api.bufferapp.com/1/user.json?access_token=$BUFFER_ACCESS_TOKEN")
    if [ "$RESULT" = "200" ]; then
        echo "  PASS: Buffer API"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: Buffer API (HTTP $RESULT)"
        FAIL=$((FAIL + 1))
    fi
else
    echo "  SKIP: BUFFER_ACCESS_TOKEN not set"
fi

# 6. OpenAI (backup)
echo "[6/6] Testing OpenAI API..."
if [ -n "$OPENAI_API_KEY" ]; then
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://api.openai.com/v1/models" \
        -H "Authorization: Bearer $OPENAI_API_KEY")
    if [ "$RESULT" = "200" ]; then
        echo "  PASS: OpenAI API"
        PASS=$((PASS + 1))
    else
        echo "  FAIL: OpenAI API (HTTP $RESULT)"
        FAIL=$((FAIL + 1))
    fi
else
    echo "  SKIP: OPENAI_API_KEY not set"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
