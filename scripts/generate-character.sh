#!/bin/bash
# AI Influencer — Character Reference Generation Script
# Uses fal.ai API to generate base character images with Flux 2 Max

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Load API key
if [ -f "$PROJECT_ROOT/n8n/credentials.env" ]; then
    source "$PROJECT_ROOT/n8n/credentials.env"
fi

if [ -z "$FAL_KEY" ]; then
    echo "ERROR: FAL_KEY not set. Add it to n8n/credentials.env"
    exit 1
fi

API_URL="https://fal.run/fal-ai/nano-banana-pro"
OUTPUT_DIR="$PROJECT_ROOT/assets/character/references"
OUTFITS_DIR="$PROJECT_ROOT/assets/character/outfits"

mkdir -p "$OUTPUT_DIR" "$OUTFITS_DIR"

echo "=== Generating Base Character References ==="
echo ""

generate_image() {
    local prompt="$1"
    local output_file="$2"
    local ref_url="$3"

    local payload="{
        \"prompt\": \"$prompt\",
        \"image_size\": \"square_hd\",
        \"num_images\": 1,
        \"num_inference_steps\": 50,
        \"guidance_scale\": 7.5"

    if [ -n "$ref_url" ]; then
        payload="$payload, \"image_url\": \"$ref_url\""
    fi

    payload="$payload }"

    curl -s -X POST "$API_URL" \
        -H "Authorization: Key $FAL_KEY" \
        -H "Content-Type: application/json" \
        -d "$payload" | python3 -c "
import json, sys, urllib.request
data = json.load(sys.stdin)
if 'images' in data and len(data['images']) > 0:
    url = data['images'][0]['url']
    urllib.request.urlretrieve(url, '$output_file')
    print('  Saved: $output_file')
    print('  URL: ' + url)
else:
    print('  ERROR: No image returned')
    print('  Response: ' + json.dumps(data, indent=2))
    sys.exit(1)
"
}

# --- BASE REFERENCES ---
echo "[1/3] Front-facing portrait..."
generate_image \
    "A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses, warm friendly expression. Head and shoulders portrait, front-facing, neutral pose. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality." \
    "$OUTPUT_DIR/base-front.png"

echo "[2/3] Three-quarter angle portrait..."
generate_image \
    "A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses, slight smile. Head and shoulders portrait, three-quarter angle looking slightly right. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality." \
    "$OUTPUT_DIR/base-three-quarter.png"

echo "[3/3] Full body shot..."
generate_image \
    "A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses, standing in relaxed pose with hands in pockets. Wearing a navy blue crew-neck sweater over white collared shirt and dark chinos. Full body shot. Clean white studio background. Photorealistic, natural studio lighting, 4K quality." \
    "$OUTPUT_DIR/base-full-body.png"

echo ""
echo "=== Base references generated ==="
echo ""

# --- OUTFIT VARIATIONS ---
# Uncomment and set REF_URL after reviewing base references
# REF_URL="<paste URL of best base reference here>"

if [ -n "$REF_URL" ]; then
    echo "=== Generating Outfit Variations ==="
    echo ""

    echo "[1/5] Professional Tech..."
    generate_image \
        "A 28-year-old Nordic man with minimal round glasses wearing a navy blue crew-neck sweater over white collared shirt, dark chinos, clean white sneakers. Standing confidently with arms crossed. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-1-professional.png" \
        "$REF_URL"

    echo "[2/5] Casual Nordic..."
    generate_image \
        "A 28-year-old Nordic man with minimal round glasses wearing a light grey merino wool hoodie over a white t-shirt, dark slim jeans, white minimalist sneakers. Relaxed standing pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-2-casual.png" \
        "$REF_URL"

    echo "[3/5] Startup Founder..."
    generate_image \
        "A 28-year-old Nordic man with minimal round glasses wearing a black turtleneck, charcoal slim-fit blazer, dark trousers, black leather shoes. Standing with one hand adjusting glasses. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-3-startup.png" \
        "$REF_URL"

    echo "[4/5] Outdoor Nordic..."
    generate_image \
        "A 28-year-old Nordic man with minimal round glasses wearing an olive green field jacket, cream knit sweater underneath, khaki pants, brown leather boots. Relaxed pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-4-outdoor.png" \
        "$REF_URL"

    echo "[5/5] Weekend Creative..."
    generate_image \
        "A 28-year-old Nordic man with minimal round glasses wearing an oversized white linen shirt with rolled sleeves, light wash relaxed jeans, tan loafers. Casual leaning pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-5-weekend.png" \
        "$REF_URL"

    echo ""
    echo "=== Outfit variations generated ==="
else
    echo "To generate outfit variations:"
    echo "  1. Review base references in $OUTPUT_DIR/"
    echo "  2. Pick the best one and copy its fal.ai URL"
    echo "  3. Set REF_URL in this script and run again"
fi

echo ""
echo "Files saved to:"
echo "  Base refs: $OUTPUT_DIR/"
echo "  Outfits:   $OUTFITS_DIR/"
echo ""
echo "Use these as character references (--cref / image_url) for all future generations."
