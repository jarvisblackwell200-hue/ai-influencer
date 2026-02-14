#!/bin/bash
# AI Influencer — API Connectivity Tests
# Tests all required API endpoints and reports results

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Load credentials
if [ -f "$PROJECT_ROOT/n8n/credentials.env" ]; then
    source "$PROJECT_ROOT/n8n/credentials.env"
else
    echo "WARNING: credentials.env not found at $PROJECT_ROOT/n8n/credentials.env"
    echo "Copy the example: cp n8n/credentials.env.example n8n/credentials.env"
    echo ""
fi

PASS=0
FAIL=0
SKIP=0

print_result() {
    local status="$1"
    local name="$2"
    local detail="$3"
    case "$status" in
        pass) echo "  [PASS] $name${detail:+ — $detail}"; PASS=$((PASS + 1)) ;;
        fail) echo "  [FAIL] $name${detail:+ — $detail}"; FAIL=$((FAIL + 1)) ;;
        skip) echo "  [SKIP] $name — key not set"; SKIP=$((SKIP + 1)) ;;
    esac
}

echo "=== AI Influencer — API Connectivity Tests ==="
echo "Date: $(date)"
echo ""

# 1. Anthropic (Claude)
echo "[1/7] Anthropic (Claude) API"
if [ -n "$ANTHROPIC_API_KEY" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -X POST "https://api.anthropic.com/v1/messages" \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d '{"model":"claude-sonnet-4-5-20250929","max_tokens":10,"messages":[{"role":"user","content":"ping"}]}')
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    if [ "$HTTP_CODE" = "200" ]; then
        MODEL=$(echo "$RESPONSE" | head -n -1 | python3 -c "import json,sys; print(json.load(sys.stdin).get('model','unknown'))" 2>/dev/null)
        print_result pass "Anthropic API" "Model: $MODEL"
    else
        print_result fail "Anthropic API" "HTTP $HTTP_CODE"
    fi
else
    print_result skip "Anthropic API"
fi

# 2. fal.ai (Flux 2 Max)
echo "[2/7] fal.ai (Flux 2 Max)"
if [ -n "$FAL_KEY" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -X POST "https://fal.run/fal-ai/flux-pro/v1.1" \
        -H "Authorization: Key $FAL_KEY" \
        -H "Content-Type: application/json" \
        -d '{"prompt":"test","image_size":"square","num_images":1,"num_inference_steps":4}' \
        --max-time 30)
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    if [ "$HTTP_CODE" = "200" ]; then
        print_result pass "fal.ai Flux 2 Max" "Image generation OK"
    elif [ "$HTTP_CODE" = "422" ] || [ "$HTTP_CODE" = "400" ]; then
        print_result pass "fal.ai Flux 2 Max" "Auth OK (validation error expected for minimal test)"
    else
        print_result fail "fal.ai Flux 2 Max" "HTTP $HTTP_CODE"
    fi
else
    print_result skip "fal.ai API"
fi

# 3. ElevenLabs
echo "[3/7] ElevenLabs (Voice)"
if [ -n "$ELEVENLABS_API_KEY" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -X GET "https://api.elevenlabs.io/v1/voices" \
        -H "xi-api-key: $ELEVENLABS_API_KEY")
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    if [ "$HTTP_CODE" = "200" ]; then
        VOICE_COUNT=$(echo "$RESPONSE" | head -n -1 | python3 -c "import json,sys; print(len(json.load(sys.stdin).get('voices',[])))" 2>/dev/null)
        print_result pass "ElevenLabs API" "$VOICE_COUNT voices available"
    else
        print_result fail "ElevenLabs API" "HTTP $HTTP_CODE"
    fi
else
    print_result skip "ElevenLabs API"
fi

# 4. Telegram Bot
echo "[4/7] Telegram Bot"
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    RESPONSE=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getMe")
    BOT_OK=$(echo "$RESPONSE" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('ok',False))" 2>/dev/null)
    if [ "$BOT_OK" = "True" ]; then
        BOT_NAME=$(echo "$RESPONSE" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('result',{}).get('username','unknown'))" 2>/dev/null)
        print_result pass "Telegram Bot" "@$BOT_NAME"
        # Test chat ID if set
        if [ -n "$TELEGRAM_CHAT_ID" ]; then
            SEND_RESULT=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=API test ping from AI Influencer pipeline" | \
                python3 -c "import json,sys; print(json.load(sys.stdin).get('ok',False))" 2>/dev/null)
            if [ "$SEND_RESULT" = "True" ]; then
                print_result pass "Telegram Chat ID" "Message sent to $TELEGRAM_CHAT_ID"
            else
                print_result fail "Telegram Chat ID" "Could not send to $TELEGRAM_CHAT_ID"
            fi
        fi
    else
        print_result fail "Telegram Bot" "Invalid token"
    fi
else
    print_result skip "Telegram Bot"
fi

# 5. Buffer
echo "[5/7] Buffer (Scheduling)"
if [ -n "$BUFFER_ACCESS_TOKEN" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -X GET "https://api.bufferapp.com/1/user.json?access_token=$BUFFER_ACCESS_TOKEN")
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    if [ "$HTTP_CODE" = "200" ]; then
        print_result pass "Buffer API" "Authenticated"
    else
        print_result fail "Buffer API" "HTTP $HTTP_CODE"
    fi
else
    print_result skip "Buffer API"
fi

# 6. OpenAI (backup)
echo "[6/7] OpenAI (Backup)"
if [ -n "$OPENAI_API_KEY" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -X GET "https://api.openai.com/v1/models" \
        -H "Authorization: Bearer $OPENAI_API_KEY")
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    if [ "$HTTP_CODE" = "200" ]; then
        print_result pass "OpenAI API" "Authenticated"
    else
        print_result fail "OpenAI API" "HTTP $HTTP_CODE"
    fi
else
    print_result skip "OpenAI API"
fi

# 7. n8n (Local)
echo "[7/7] n8n (Local Instance)"
N8N_URL="${WEBHOOK_URL:-http://localhost:5678}"
N8N_RESULT=$(curl -s -o /dev/null -w "%{http_code}" "$N8N_URL/healthz" --max-time 5 2>/dev/null)
if [ "$N8N_RESULT" = "200" ]; then
    print_result pass "n8n Instance" "Running at $N8N_URL"
else
    print_result fail "n8n Instance" "Not reachable at $N8N_URL (HTTP $N8N_RESULT)"
fi

echo ""
echo "==========================================="
echo "  Results: $PASS passed | $FAIL failed | $SKIP skipped"
echo "==========================================="

if [ $FAIL -gt 0 ]; then
    echo ""
    echo "Fix failed tests before running workflows."
    exit 1
fi
