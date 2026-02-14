# API Reference

## Anthropic (Claude) API
- **Base URL:** `https://api.anthropic.com/v1`
- **Endpoint:** `POST /messages`
- **Auth:** `x-api-key` header
- **Models:** `claude-sonnet-4-5-20250929` (primary), `claude-opus-4-5-20250918` (complex tasks)
- **Docs:** https://docs.anthropic.com/en/docs

## fal.ai (Flux 2 Max / Kling 3.0)
- **Base URL:** `https://fal.run`
- **Flux 2 Max:** `POST /fal-ai/flux-pro/v1.1`
- **Kling 3.0:** `POST /fal-ai/kling-video/v1`
- **Auth:** `Authorization: Key {FAL_KEY}`
- **Docs:** https://fal.ai/docs

### Flux 2 Max Payload
```json
{
  "prompt": "image description",
  "image_url": "character reference URL",
  "image_size": "square_hd",
  "num_images": 3,
  "num_inference_steps": 50,
  "guidance_scale": 7.5
}
```

## ElevenLabs (Voice)
- **Base URL:** `https://api.elevenlabs.io/v1`
- **Text-to-Speech:** `POST /text-to-speech/{voice_id}`
- **Auth:** `xi-api-key` header
- **Docs:** https://elevenlabs.io/docs

## Telegram Bot API
- **Base URL:** `https://api.telegram.org/bot{TOKEN}`
- **Send Message:** `POST /sendMessage`
- **Send Photo:** `POST /sendPhoto`
- **Send Video:** `POST /sendVideo`
- **Docs:** https://core.telegram.org/bots/api

## Buffer (Social Scheduling)
- **Base URL:** `https://api.bufferapp.com/1`
- **Create Post:** `POST /updates/create.json`
- **Auth:** `access_token` query parameter
- **Docs:** https://buffer.com/developers/api

## Google Veo 3.1 (Video)
- **Access:** Via Google AI Studio or Vertex AI
- **Docs:** https://cloud.google.com/vertex-ai/docs
