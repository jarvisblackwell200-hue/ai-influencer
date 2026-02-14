# Image Prompt Templates for Flux 2 Max

## Base Character Description
[To be filled after character generation — reference the base character images]

```
Base prompt prefix: "A [age]-year-old [gender] with [specific features], [ethnicity appearance]"
```

## Character Reference Usage
All image generations must include:
- `image_url`: URL to the base character reference image
- Style: "photorealistic, natural lighting, Scandinavian minimalist aesthetic"
- Resolution: 1024x1024 (square_hd) for Instagram, 9:16 for Stories/Reels

## Template Prompts

### Home Office Setup
```
{character_description}, sitting at a clean white desk in a minimalist Scandinavian home office, wearing {outfit_number}, looking at a laptop screen showing {topic_visual}, natural window light from the left, shallow depth of field, warm tones, photorealistic, 4K
```

### Stockholm Streets
```
{character_description}, walking on a cobblestone street in Gamla Stan Stockholm, wearing {outfit_number}, holding a coffee cup, golden hour lighting, autumn/spring atmosphere, photorealistic, street photography style
```

### Coffee Shop
```
{character_description}, sitting in a modern Nordic coffee shop, wearing {outfit_number}, {action: explaining something / taking notes / looking at phone}, warm interior lighting, blurred background with plants, photorealistic
```

### Co-working Space
```
{character_description}, standing at a whiteboard in a modern co-working space, wearing {outfit_number}, presenting {topic}, clean industrial interior, bright even lighting, photorealistic
```

### Nature / Archipelago
```
{character_description}, outdoors in the Swedish archipelago, wearing {outfit_number}, {season} atmosphere, natural lighting, scenic water and rocks background, candid pose, photorealistic
```

## Outfit Catalog
| # | Description | Best For |
|---|-------------|----------|
| 1 | TBD | Professional/educational posts |
| 2 | TBD | Casual/lifestyle posts |
| 3 | TBD | Tech/startup vibes |
| 4 | TBD | Outdoor/nature content |
| 5 | TBD | Evening/event content |

## Technical Parameters
```json
{
  "model": "fal-ai/flux-pro/v1.1",
  "num_images": 3,
  "image_size": "square_hd",
  "guidance_scale": 7.5,
  "num_inference_steps": 50
}
```
