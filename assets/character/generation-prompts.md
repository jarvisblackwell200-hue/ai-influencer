# Character Reference Generation Prompts

Use these prompts with Flux 2 Max (via fal.ai) to generate the base character.

## Important
- Generate the **base references first** (front, 3/4, full body) on a clean white background
- Use these as `image_url` (character reference) for ALL subsequent generations
- Keep `guidance_scale: 7.5` and `num_inference_steps: 50` for consistency

---

## Base References

### 1. Front-Facing Portrait
```
A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses, warm friendly expression. Head and shoulders portrait, front-facing, neutral pose. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality.
```

### 2. Three-Quarter Angle Portrait
```
A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses, slight smile. Head and shoulders portrait, three-quarter angle looking slightly right. Clean white studio background. Photorealistic, natural studio lighting, sharp focus, 4K quality.
```

### 3. Full Body Shot
```
A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses, standing in relaxed pose with hands in pockets. Wearing a navy blue crew-neck sweater over white collared shirt and dark chinos. Full body shot. Clean white studio background. Photorealistic, natural studio lighting, 4K quality.
```

---

## Outfit Variations

### Outfit 1 — Professional Tech
```
[CHARACTER REF] wearing a navy blue crew-neck sweater over white collared shirt, dark chinos, clean white sneakers. Standing confidently with arms crossed. White studio background. Photorealistic, 4K.
```

### Outfit 2 — Casual Nordic
```
[CHARACTER REF] wearing a light grey merino wool hoodie over a white t-shirt, dark slim jeans, white minimalist sneakers. Relaxed standing pose. White studio background. Photorealistic, 4K.
```

### Outfit 3 — Startup Founder
```
[CHARACTER REF] wearing a black turtleneck, charcoal slim-fit blazer, dark trousers, black leather shoes. Standing with one hand adjusting glasses. White studio background. Photorealistic, 4K.
```

### Outfit 4 — Outdoor Nordic
```
[CHARACTER REF] wearing an olive green field jacket, cream knit sweater underneath, khaki pants, brown leather boots. Relaxed pose. White studio background. Photorealistic, 4K.
```

### Outfit 5 — Weekend Creative
```
[CHARACTER REF] wearing an oversized white linen shirt with rolled sleeves, light wash relaxed jeans, tan loafers. Casual leaning pose. White studio background. Photorealistic, 4K.
```

---

## Setting Shots (Use with character reference + outfit)

### Home Office
```
[CHARACTER REF] in [OUTFIT], sitting at a clean white Scandinavian desk, working on a MacBook, minimalist home office with white walls, light wood shelving, monstera plant, natural window light from the left, warm tones. Photorealistic, shallow depth of field, 4K.
```

### Stockholm Streets
```
[CHARACTER REF] in [OUTFIT], walking on cobblestone street in Gamla Stan Stockholm, golden hour sunlight, colorful historic buildings in background, holding a takeaway coffee. Street photography style, photorealistic, 4K.
```

### Coffee Shop
```
[CHARACTER REF] in [OUTFIT], sitting in a modern Nordic coffee shop, light wood table, latte in hand, looking at camera with slight smile, warm interior lighting, blurred background with plants and other patrons. Photorealistic, 4K.
```

### Co-working Space
```
[CHARACTER REF] in [OUTFIT], standing at a whiteboard in a modern co-working space, presenting an idea with hand gestures, industrial-meets-Scandinavian interior, bright even lighting. Photorealistic, 4K.
```

### Archipelago
```
[CHARACTER REF] in [OUTFIT], sitting on smooth rocks by the water in the Swedish archipelago, pine trees in background, Nordic summer evening light, peaceful atmosphere. Photorealistic, cinematic, 4K.
```

---

## API Parameters
```json
{
  "model": "fal-ai/flux-pro/v1.1",
  "image_size": "square_hd",
  "num_images": 3,
  "num_inference_steps": 50,
  "guidance_scale": 7.5
}
```

For character reference shots, add:
```json
{
  "image_url": "<URL to base reference image>"
}
```
