# Character Reference Generation Prompts

Use these prompts with Nano Banana Pro (via fal.ai) to generate the base character.

## Important
- Generate the **base references first** (front, 3/4, full body) on a clean white background
- Use these as `image_url` (character reference) for ALL subsequent generations
- Nano Banana Pro supports up to 10 reference images for consistency

---

## Base References

### 1. Front-Facing Portrait
```
A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, high cheekbones, full lips, natural glowing makeup, minimalist gold thin necklace and small hoop earrings, warm confident smile. Head and shoulders portrait, front-facing, neutral pose. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality.
```

### 2. Three-Quarter Angle Portrait
```
A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, high cheekbones, full lips, natural glowing makeup, minimalist gold jewelry, slight smile looking slightly right. Head and shoulders portrait, three-quarter angle. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality.
```

### 3. Full Body Shot
```
A 24-year-old ethnically ambiguous classically beautiful woman with long dark brown wavy hair, warm olive skin, deep brown almond-shaped eyes, high cheekbones, full lips, natural glowing makeup, minimalist gold jewelry. Wearing an oversized cream knit sweater, tailored camel coat, straight-leg jeans, and white sneakers. Full body standing pose, one hand on hip. Clean white studio background. Photorealistic, natural studio lighting, 4K quality.
```

---

## Outfit Variations

### Outfit 1 — Scandi Minimal
```
[CHARACTER REF] wearing an oversized cream knit sweater, tailored camel coat draped over shoulders, straight-leg jeans, white sneakers. Standing with hands in coat pockets. White studio background. Photorealistic, 4K.
```

### Outfit 2 — City Chic
```
[CHARACTER REF] wearing a black leather blazer, white silk camisole, high-waisted black trousers, pointed black heels. Confident pose with one hand on hip. White studio background. Photorealistic, 4K.
```

### Outfit 3 — Athleisure Luxe
```
[CHARACTER REF] wearing a matching sage green crop top and high-waisted leggings set, white running shoes, oversized sunglasses pushed up on head. Relaxed athletic pose. White studio background. Photorealistic, 4K.
```

### Outfit 4 — Summer Nordic
```
[CHARACTER REF] wearing a flowy white linen midi dress, carrying a straw basket bag, tan leather sandals, layered gold jewelry. Light summer pose. White studio background. Photorealistic, 4K.
```

### Outfit 5 — Date Night
```
[CHARACTER REF] wearing a fitted black mini dress, gold statement earrings, strappy black heels, small black clutch bag. Elegant pose. White studio background. Photorealistic, 4K.
```

### Outfit 6 — Cozy Home
```
[CHARACTER REF] wearing an oversized cashmere cardigan in oatmeal, silk pajama pants, wool socks, hair in messy bun, holding a ceramic mug. Relaxed cozy pose. White studio background. Photorealistic, 4K.
```

### Outfit 7 — Street Style
```
[CHARACTER REF] wearing an oversized denim jacket, white graphic tee, olive cargo pants, chunky black boots, black crossbody bag. Cool casual pose. White studio background. Photorealistic, 4K.
```

---

## Setting Shots

### Stockholm Apartment
```
[CHARACTER REF] in [OUTFIT], in a bright Scandinavian apartment with white walls, natural wood floors, sheepskin throw on sofa, lit candles, large windows with Stockholm city view. Natural morning light. Photorealistic, lifestyle photography, 4K.
```

### Stockholm Streets
```
[CHARACTER REF] in [OUTFIT], walking on a cobblestone street in Södermalm Stockholm, colorful building facades, café terraces, golden hour sunlight. Street style photography, photorealistic, 4K.
```

### Fashion District
```
[CHARACTER REF] in [OUTFIT], standing outside a luxury boutique storefront in Stockholm's Bibliotekstan, shopping bags in hand, polished urban setting. Fashion editorial style, photorealistic, 4K.
```

### Coffee Shop
```
[CHARACTER REF] in [OUTFIT], sitting in a trendy Nordic café, marble table, matcha latte, hanging plants, natural light streaming in, looking at camera with warm smile. Lifestyle photography, photorealistic, 4K.
```

### Archipelago
```
[CHARACTER REF] in [OUTFIT], standing on smooth rocks by the water in the Swedish archipelago, wildflowers nearby, golden hour Nordic summer light, wind in hair. Cinematic, photorealistic, 4K.
```

---

## API Parameters
```json
{
  "model": "fal-ai/nano-banana-pro",
  "image_size": "square_hd",
  "num_images": 3,
  "num_inference_steps": 50,
  "guidance_scale": 7.5
}
```
