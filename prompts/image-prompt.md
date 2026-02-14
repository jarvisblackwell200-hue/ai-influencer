# Image Prompt Templates for Flux 2 Max

## Base Character Description
```
A 28-year-old Nordic man with light brown slightly tousled hair, light stubble, warm hazel eyes, minimal round glasses
```

## Character Reference Usage
All image generations must include:
- `image_url`: URL to the base character reference image (stored in assets/character/references/)
- Style suffix: "photorealistic, natural lighting, Scandinavian minimalist aesthetic, 4K"
- Resolution: `square_hd` (1024x1024) for Instagram feed, `portrait_4_3` for Stories/Reels

## Outfit Catalog
| # | Name | Description | Best For |
|---|------|-------------|----------|
| 1 | Professional Tech | Navy blue crew-neck sweater over white collared shirt, dark chinos | Educational posts, explainers |
| 2 | Casual Nordic | Light grey merino wool hoodie, white t-shirt, dark jeans | Casual, lifestyle, behind-the-scenes |
| 3 | Startup Founder | Black turtleneck, charcoal blazer, dark trousers | Tech reviews, startup, evening |
| 4 | Outdoor Nordic | Olive green field jacket, cream knit sweater, khaki pants | Outdoor, nature posts |
| 5 | Weekend Creative | Oversized white linen shirt (rolled sleeves), light wash jeans | Weekend, relaxed, summer |

## Template Prompts

### Home Office Setup
```
A 28-year-old Nordic man with light brown tousled hair, light stubble, hazel eyes, minimal round glasses, sitting at a clean white Scandinavian desk, working on a MacBook, wearing {outfit_description}. Minimalist home office with white walls, light wood shelving, monstera plant. Natural window light from the left, shallow depth of field, warm tones. Photorealistic, natural lighting, 4K.
```

### Stockholm Streets
```
A 28-year-old Nordic man with light brown tousled hair, light stubble, hazel eyes, minimal round glasses, walking on a cobblestone street in Gamla Stan Stockholm, wearing {outfit_description}, holding a takeaway coffee cup. Golden hour sunlight, colorful historic buildings in background. Street photography style, photorealistic, 4K.
```

### Coffee Shop
```
A 28-year-old Nordic man with light brown tousled hair, light stubble, hazel eyes, minimal round glasses, sitting in a modern Nordic coffee shop, wearing {outfit_description}, {action}. Light wood table, warm interior lighting, blurred background with plants and other patrons. Photorealistic, natural lighting, 4K.
```
Actions: "looking at camera with slight smile" | "explaining something gesturing with one hand" | "looking at laptop screen" | "writing in a notebook"

### Co-working Space
```
A 28-year-old Nordic man with light brown tousled hair, light stubble, hazel eyes, minimal round glasses, standing at a whiteboard in a modern co-working space, wearing {outfit_description}, presenting {topic} with hand gestures. Industrial-meets-Scandinavian interior, bright even lighting. Photorealistic, 4K.
```

### Archipelago / Nature
```
A 28-year-old Nordic man with light brown tousled hair, light stubble, hazel eyes, minimal round glasses, sitting on smooth rocks by the water in the Swedish archipelago, wearing {outfit_description}. Pine trees in background, Nordic {season} evening light, peaceful atmosphere. Candid pose, photorealistic, cinematic, 4K.
```

## Technical Parameters
```json
{
  "model": "fal-ai/flux-pro/v1.1",
  "image_url": "<character reference URL>",
  "num_images": 3,
  "image_size": "square_hd",
  "guidance_scale": 7.5,
  "num_inference_steps": 50
}
```

## Prompt Composition Formula
```
{character_description} + {action/pose} + {setting_description} + {outfit} + {lighting/mood} + "photorealistic, natural lighting, 4K"
```
