#!/bin/bash
# AI Influencer — Character Reference Generation Script
# Uses fal.ai API to generate base character images with Nano Banana Pro

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
    "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, high cheekbones, full lips, natural glowing makeup, minimalist gold thin necklace and small hoop earrings, warm confident smile. Head and shoulders portrait, front-facing, neutral pose. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality." \
    "$OUTPUT_DIR/base-front.png"

echo "[2/3] Three-quarter angle portrait..."
generate_image \
    "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, high cheekbones, full lips, natural glowing makeup, minimalist gold jewelry, slight smile looking slightly right. Head and shoulders portrait, three-quarter angle. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality." \
    "$OUTPUT_DIR/base-three-quarter.png"

echo "[3/3] Full body shot..."
generate_image \
    "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, high cheekbones, full lips, natural glowing makeup, minimalist gold jewelry. Wearing an oversized cream knit sweater, tailored camel coat, straight-leg jeans, and white sneakers. Full body standing pose, one hand on hip. Clean white studio background. Photorealistic, natural studio lighting, 4K quality." \
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

    echo "[1/7] Scandi Minimal..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, wearing an oversized cream knit sweater, tailored camel coat draped over shoulders, straight-leg jeans, white sneakers. Standing with hands in coat pockets. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-1-scandi-minimal.png" \
        "$REF_URL"

    echo "[2/7] City Chic..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, wearing a black leather blazer, white silk camisole, high-waisted black trousers, pointed black heels. Confident pose with one hand on hip. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-2-city-chic.png" \
        "$REF_URL"

    echo "[3/7] Athleisure Luxe..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, wearing a matching sage green crop top and high-waisted leggings set, white running shoes, oversized sunglasses pushed up on head. Relaxed athletic pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-3-athleisure.png" \
        "$REF_URL"

    echo "[4/7] Summer Nordic..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, wearing a flowy white linen midi dress, carrying a straw basket bag, tan leather sandals, layered gold jewelry. Light summer pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-4-summer.png" \
        "$REF_URL"

    echo "[5/7] Date Night..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, wearing a fitted black mini dress, gold statement earrings, strappy black heels, small black clutch bag. Elegant pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-5-date-night.png" \
        "$REF_URL"

    echo "[6/7] Cozy Home..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair in messy bun, warm olive skin, deep brown almond-shaped eyes, wearing an oversized cashmere cardigan in oatmeal, silk pajama pants, wool socks, holding a ceramic mug. Relaxed cozy pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-6-cozy-home.png" \
        "$REF_URL"

    echo "[7/7] Street Style..."
    generate_image \
        "A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, wearing an oversized denim jacket, white graphic tee, olive cargo pants, chunky black boots, black crossbody bag. Cool casual pose. White studio background. Photorealistic, 4K." \
        "$OUTFITS_DIR/outfit-7-street-style.png" \
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
