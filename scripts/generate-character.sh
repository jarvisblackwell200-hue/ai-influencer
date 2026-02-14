#!/bin/bash
# AI Influencer — Character Reference Generation Script
# Uses fal.ai API to generate base character images with Flux 2 Max

set -e

# Load API key
if [ -f "n8n/credentials.env" ]; then
    source n8n/credentials.env
fi

if [ -z "$FAL_KEY" ]; then
    echo "ERROR: FAL_KEY not set. Add it to n8n/credentials.env"
    exit 1
fi

API_URL="https://fal.run/fal-ai/flux-pro/v1.1"
OUTPUT_DIR="assets/character/references"

mkdir -p "$OUTPUT_DIR"

echo "=== Generating Base Character References ==="
echo ""

# Base character description — CUSTOMIZE THIS
CHARACTER_DESC="A 28-year-old Nordic person with light brown hair, clean-shaven, wearing minimal glasses, warm friendly expression, photorealistic, natural lighting, Scandinavian minimalist aesthetic"

# Generate front-facing portrait
echo "[1/3] Generating front-facing portrait..."
curl -s -X POST "$API_URL" \
  -H "Authorization: Key $FAL_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": \"$CHARACTER_DESC, front-facing neutral portrait, studio lighting, white background, head and shoulders, 4K\",
    \"image_size\": \"square_hd\",
    \"num_images\": 1,
    \"num_inference_steps\": 50,
    \"guidance_scale\": 7.5
  }" | python3 -c "
import json, sys, urllib.request
data = json.load(sys.stdin)
url = data['images'][0]['url']
urllib.request.urlretrieve(url, '$OUTPUT_DIR/base-front.png')
print('Saved: $OUTPUT_DIR/base-front.png')
"

# Generate 3/4 angle portrait
echo "[2/3] Generating 3/4 angle portrait..."
curl -s -X POST "$API_URL" \
  -H "Authorization: Key $FAL_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": \"$CHARACTER_DESC, three-quarter angle portrait, looking slightly to the right, studio lighting, white background, head and shoulders, 4K\",
    \"image_size\": \"square_hd\",
    \"num_images\": 1,
    \"num_inference_steps\": 50,
    \"guidance_scale\": 7.5
  }" | python3 -c "
import json, sys, urllib.request
data = json.load(sys.stdin)
url = data['images'][0]['url']
urllib.request.urlretrieve(url, '$OUTPUT_DIR/base-three-quarter.png')
print('Saved: $OUTPUT_DIR/base-three-quarter.png')
"

# Generate full body shot
echo "[3/3] Generating full body shot..."
curl -s -X POST "$API_URL" \
  -H "Authorization: Key $FAL_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": \"$CHARACTER_DESC, full body standing pose, casual smart outfit, modern minimalist studio, white background, 4K\",
    \"image_size\": \"square_hd\",
    \"num_images\": 1,
    \"num_inference_steps\": 50,
    \"guidance_scale\": 7.5
  }" | python3 -c "
import json, sys, urllib.request
data = json.load(sys.stdin)
url = data['images'][0]['url']
urllib.request.urlretrieve(url, '$OUTPUT_DIR/base-full-body.png')
print('Saved: $OUTPUT_DIR/base-full-body.png')
"

echo ""
echo "=== Character references generated ==="
echo "Files saved to $OUTPUT_DIR/"
echo ""
echo "Next: Review the images and run outfit variations."
echo "Then use these as --cref (character reference) for all future generations."
