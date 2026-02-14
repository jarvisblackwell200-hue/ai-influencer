# API Reference

## Quick Reference

| Service | Base URL | Auth Method | Used For |
|---------|----------|-------------|----------|
| Anthropic | `api.anthropic.com/v1` | `x-api-key` header | Content ideation, captions, analytics |
| fal.ai | `fal.run` | `Authorization: Key` | Image gen (Flux), Video gen (Kling) |
| ElevenLabs | `api.elevenlabs.io/v1` | `xi-api-key` header | Voice generation |
| Telegram | `api.telegram.org` | Token in URL | Approval bot |
| Buffer | `api.bufferapp.com/1` | `access_token` param | Social scheduling |
| OpenAI | `api.openai.com/v1` | `Bearer` token | Backup content gen |

---

## 1. Anthropic (Claude) API

**Endpoint:** `POST https://api.anthropic.com/v1/messages`

**Headers:**
```
x-api-key: {ANTHROPIC_API_KEY}
anthropic-version: 2023-06-01
content-type: application/json
```

**Request Body:**
```json
{
  "model": "claude-sonnet-4-5-20250929",
  "max_tokens": 2048,
  "system": "System prompt here",
  "messages": [
    { "role": "user", "content": "User message" }
  ]
}
```

**Response:**
```json
{
  "id": "msg_...",
  "type": "message",
  "role": "assistant",
  "content": [{ "type": "text", "text": "Response text" }],
  "model": "claude-sonnet-4-5-20250929",
  "usage": { "input_tokens": 100, "output_tokens": 200 }
}
```

**Models:**
- `claude-sonnet-4-5-20250929` — Primary (fast, cost-effective)
- `claude-opus-4-5-20250918` — Complex tasks (slower, more capable)

**Error Codes:** 401 (bad key), 429 (rate limit), 500 (server error)

**Docs:** https://docs.anthropic.com/en/docs

---

## 2. fal.ai — Flux 2 Max (Image Generation)

**Endpoint:** `POST https://fal.run/fal-ai/flux-pro/v1.1`

**Headers:**
```
Authorization: Key {FAL_KEY}
Content-Type: application/json
```

**Request Body:**
```json
{
  "prompt": "Image description...",
  "image_url": "https://... (character reference)",
  "image_size": "square_hd",
  "num_images": 3,
  "num_inference_steps": 50,
  "guidance_scale": 7.5
}
```

**Image Sizes:** `square_hd` (1024x1024), `portrait_4_3`, `landscape_4_3`, `portrait_16_9`, `landscape_16_9`

**Response:**
```json
{
  "images": [
    { "url": "https://fal.media/files/...", "width": 1024, "height": 1024 }
  ],
  "seed": 12345,
  "has_nsfw_concepts": [false]
}
```

**Docs:** https://fal.ai/models/fal-ai/flux-pro/v1.1

---

## 3. fal.ai — Kling 3.0 (Video Generation)

**Endpoint:** `POST https://fal.run/fal-ai/kling-video/v1/standard/image-to-video`

**Request Body:**
```json
{
  "prompt": "Video motion description",
  "image_url": "https://... (character still image)",
  "duration": "5",
  "aspect_ratio": "9:16"
}
```

**Response:**
```json
{
  "video": { "url": "https://fal.media/files/..." }
}
```

**Notes:** ~$0.10/sec, best for 5-15 sec clips. Use `image_url` for character consistency.

---

## 4. ElevenLabs (Voice Generation)

**Endpoint:** `POST https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`

**Headers:**
```
xi-api-key: {ELEVENLABS_API_KEY}
Content-Type: application/json
Accept: audio/mpeg
```

**Request Body:**
```json
{
  "text": "Narration text here",
  "model_id": "eleven_multilingual_v2",
  "voice_settings": {
    "stability": 0.5,
    "similarity_boost": 0.75,
    "style": 0.3,
    "use_speaker_boost": true
  }
}
```

**Response:** Binary audio file (audio/mpeg)

**List Voices:** `GET /v1/voices` — returns available voice IDs

**Docs:** https://elevenlabs.io/docs/api-reference

---

## 5. Telegram Bot API

**Base URL:** `https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}`

### Send Photo
```
POST /sendPhoto
  chat_id: {TELEGRAM_CHAT_ID}
  photo: {image_url}
  caption: {message_text}
```

### Send Video
```
POST /sendVideo
  chat_id: {TELEGRAM_CHAT_ID}
  video: {video_url}
  caption: {message_text}
```

### Send Message
```
POST /sendMessage
  chat_id: {TELEGRAM_CHAT_ID}
  text: {message_text}
  parse_mode: HTML (optional)
```

### Get Updates (for chat ID discovery)
```
GET /getUpdates
```

**Docs:** https://core.telegram.org/bots/api

---

## 6. Buffer (Social Scheduling)

**Endpoint:** `POST https://api.bufferapp.com/1/updates/create.json`

**Parameters:**
```
access_token: {BUFFER_ACCESS_TOKEN}
profile_ids[]: {profile_id}
text: {caption}
media[photo]: {image_url}
scheduled_at: {ISO 8601 timestamp}
```

**Get Profiles:** `GET /1/profiles.json?access_token={token}`

**Docs:** https://buffer.com/developers/api

---

## 7. OpenAI (Backup)

**Endpoint:** `POST https://api.openai.com/v1/chat/completions`

**Headers:**
```
Authorization: Bearer {OPENAI_API_KEY}
Content-Type: application/json
```

**Request Body:**
```json
{
  "model": "gpt-4o",
  "messages": [
    { "role": "system", "content": "System prompt" },
    { "role": "user", "content": "User message" }
  ],
  "max_tokens": 2048
}
```

---

## Rate Limits & Cost Estimates

| Service | Rate Limit | Cost Estimate |
|---------|-----------|--------------|
| Anthropic | 1000 req/min (Sonnet) | ~$3/M input, $15/M output |
| fal.ai Flux | Concurrent limit varies | ~$0.04/image |
| fal.ai Kling | Queue-based | ~$0.10/sec of video |
| ElevenLabs | 100 req/min (Starter) | $22/mo for 30K chars |
| Telegram | 30 msg/sec | Free |
| Buffer | 60 req/min | $15-30/mo |
