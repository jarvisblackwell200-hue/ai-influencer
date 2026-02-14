# CLAUDE.md — AI Influencer Automation Project

## Project Overview

Build and operate a fully automated AI influencer pipeline targeting **monetizable niches** on Instagram, TikTok, and YouTube. Everything is automated end-to-end — content ideation, image/video generation, caption writing, scheduling — until the **final approval step**, which happens via a **Telegram bot powered by n8n**. The operator (Chris) reviews, optionally tweaks, and approves each post before it goes live.

---

## 1. STRATEGIC POSITIONING

### Niche Selection (Ranked by Monetization Potential)

Pick **one** primary niche. These are ranked by proven AI influencer revenue:

| Rank | Niche | Why It Works | Revenue Channels |
|------|-------|-------------|-----------------|
| 1 | **Tech / AI Explainer** | High affiliate commissions (30-50% on SaaS), brand deals from software companies, YouTube ad RPM is highest in tech ($15-30 CPM) | Affiliate (SaaS, tools), sponsorships, YouTube ads, digital courses |
| 2 | **Fashion / Lifestyle** | Visual-first = plays to AI image strengths, massive brand deal market, Instagram-native | Brand sponsorships, affiliate (clothing/beauty), Fanvue/Patreon |
| 3 | **Finance / Investing** | Extremely high CPMs ($20-50), strong affiliate payouts for fintech products | Affiliate (trading platforms, fintech), sponsorships, premium content |
| 4 | **ASMR / Relaxation** | Low-effort content, high volume scaling, YouTube monetization friendly | YouTube ad revenue, Patreon, merch |
| 5 | **Fitness / Wellness** | Subscription model potential, challenge-based monetization | Paid challenges, affiliate, coaching upsells |

**Recommended for Chris:** `Tech / AI Explainer` or `Finance / Investing` — leverages your actual domain expertise (AI products, trading systems, Swedish ISK investing), highest monetization ceiling, and Swedish market angle is a differentiator.

### Influencer Identity Blueprint

```yaml
persona:
  name: "[Choose a Scandinavian-tech-sounding name]"
  age_appearance: 25-32
  gender: "[Choose]"
  ethnicity_appearance: "Nordic / ambiguous-European"
  personality_traits:
    - "Curious and analytical"
    - "Friendly but no-nonsense"
    - "Slightly nerdy, self-aware about it"
  backstory: "Stockholm-based tech enthusiast who breaks down AI, fintech, and investing for Nordic audiences"
  language: "English (primary), Swedish (secondary content)"
  disclosure: "Always disclose AI-generated nature in bio — legally required by FTC and EU AI Act"

visual_identity:
  style: "Clean Scandinavian minimalism — light backgrounds, muted tones, occasional pop colors"
  wardrobe_capsule: 5-7 distinct outfits rotated for realism
  signature_elements: "Glasses optional, specific hairstyle, always same face"
  settings: ["home office", "Stockholm streets", "coffee shop", "co-working space", "nature/archipelago"]
```

---

## 2. AI MODEL STACK (February 2026 State of the Art)

### Image Generation — Character Consistency

| Model | Use Case | Why |
|-------|----------|-----|
| **Flux 2 Max** (Black Forest Labs) | Primary character images | Best-in-class character consistency with multi-reference support (up to 10 refs). Open-weight, full control. Use via API (fal.ai, Replicate, or self-host) |
| **Flux 2 Flex** | Quick variations / drafts | Faster than Max, good for batch iteration |
| **GPT Image 1.5** (OpenAI) | Posts with text overlays, infographics | #1 ranked for text rendering in images (LM Arena score 1264) |
| **Midjourney v7** | Hero/editorial shots | Unmatched aesthetic quality for key posts |
| **Seedream 4.5** (ByteDance) | High volume / budget content | Cost-effective, good style consistency across batches |

**Character Consistency Workflow:**
1. Generate ONE "base character" image (neutral pose, full body, front-facing) with Flux 2 Max
2. Save as reference image(s) — face close-up + full body + 3/4 angle
3. All subsequent generations use these as `--cref` (character reference) inputs
4. Create 5-7 outfit variations locked as templates
5. Store all reference images in `/assets/character/references/`

### Video Generation

| Model | Use Case | Cost |
|-------|----------|------|
| **Google Veo 3.1** | Cinematic quality, native audio + lip sync | $0.20/sec, best all-rounder |
| **Kling 3.0** (Kuaishou) | Multi-shot sequences with character consistency, multi-character audio | ~$0.10/sec via fal.ai |
| **Runway Gen-4.5** | Film-grade editing, highest benchmark scores | From $12/mo subscription |
| **Wan 2.2** (Alibaba, open-source) | Budget video, self-hostable, good for high volume | ~$0.05/sec or free self-hosted |
| **Sora 2** (OpenAI) | Narrative/storytelling, complex motion | Included with ChatGPT Pro |

**Video Strategy:**
- Short-form (TikTok/Reels): Use Kling 3.0 for 5-15 sec clips
- YouTube Shorts: Use Veo 3.1 for best audio sync
- Talking head / explainers: Use image-to-video (still of character → animated with lip sync)

### Text / Captions / Scripts

| Model | Use Case |
|-------|----------|
| **Claude Sonnet 4.5** | Primary content writer — captions, scripts, hooks. Use via API in n8n |
| **Claude Opus 4.5** | Complex research posts, long-form scripts |
| **GPT-4o** | Backup/variety, good for brainstorming |

### Voice (for video narration)

| Tool | Use Case |
|------|----------|
| **ElevenLabs** | Custom voice clone for consistent AI influencer voice |
| **Veo 3.1 native audio** | Built-in voice for video clips |

---

## 3. CONTENT PIPELINE (Fully Automated)

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    AUTOMATED PIPELINE                        │
│                                                             │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌─────────┐ │
│  │ IDEATION │──▶│ CREATION │──▶│ ASSEMBLY │──▶│ PREVIEW │ │
│  │ (Claude) │   │(Flux/Veo)│   │ (n8n)    │   │(Telegram)│ │
│  └──────────┘   └──────────┘   └──────────┘   └────┬────┘ │
│                                                      │      │
└──────────────────────────────────────────────────────┼──────┘
                                                       │
                    ┌──────────────────────┐           │
                    │   HUMAN-IN-THE-LOOP  │◀──────────┘
                    │                      │
                    │  Chris reviews via   │
                    │  Telegram:           │
                    │  ✅ Approve          │
                    │  ✏️ Edit caption     │
                    │  ❌ Reject & regen   │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │     PUBLISHING       │
                    │  (Buffer / Later /   │
                    │   Upload-Post API)   │
                    └──────────────────────┘
```

### Daily Content Schedule

```yaml
daily_output:
  instagram:
    feed_posts: 1        # high-quality image + caption
    stories: 2-3         # behind-the-scenes, polls, quick tips
    reels: 1             # 15-30 sec video
  tiktok:
    videos: 1-2          # repurposed reels + native content
  youtube:
    shorts: 1            # repurposed best reel
    long_form: 1/week    # 5-10 min explainer (AI-generated talking head)
  x_twitter:
    threads: 1           # text-based thought leadership
    posts: 2-3           # engagement posts, quotes

posting_times:  # Optimized for Nordic + US overlap
  instagram: "17:00 CET"
  tiktok: "19:00 CET"
  youtube: "15:00 CET"
  x: "16:00 CET"
```

---

## 4. N8N WORKFLOW ARCHITECTURE

### Required n8n Nodes & Integrations

```yaml
credentials_needed:
  - telegram_bot: "Create via @BotFather"
  - anthropic_api: "Claude API key for content generation"
  - openai_api: "For GPT Image 1.5 and backup"
  - fal_ai_api: "For Flux 2 Max and Kling 3.0"
  - elevenlabs_api: "For voice generation"
  - buffer_or_upload_post: "For multi-platform scheduling"
  - google_drive: "For asset storage"

n8n_nodes_used:
  - Schedule Trigger (cron)
  - HTTP Request (API calls to Flux, Veo, Claude, etc.)
  - Telegram (Send and Wait for Response)
  - Code (JavaScript for processing)
  - IF / Switch (routing logic)
  - Wait (approval pause)
  - Google Drive (asset storage)
```

### Workflow 1: Daily Content Generation & Approval

```
TRIGGER: Cron schedule (e.g., daily at 09:00 CET)
│
├──▶ [1] IDEATION NODE (HTTP Request → Claude API)
│    System prompt: "You are a content strategist for a {niche} AI influencer.
│    Generate 1 Instagram post idea with: hook, caption (150-250 chars),
│    5 hashtags, and a detailed image prompt for Flux 2 Max.
│    Also suggest 1 reel concept with a 15-sec video script.
│    Format: JSON"
│    
│    Input: trending topics (optional Tavily web search node),
│           content calendar context, past performance data
│
├──▶ [2] IMAGE GENERATION (HTTP Request → fal.ai Flux 2 Max API)
│    Payload:
│    {
│      "model": "fal-ai/flux-pro/v1.1",
│      "prompt": "{generated_image_prompt}",
│      "image_url": "{character_reference_url}",  // character ref
│      "num_images": 3,  // generate options
│      "image_size": "square_hd"  // 1024x1024 for Instagram
│    }
│
├──▶ [3] CAPTION REFINEMENT (HTTP Request → Claude API)
│    "Polish this caption for Instagram. Make it engaging,
│     include a CTA, and ensure it matches the brand voice.
│     Add 20-30 relevant hashtags in a comment block."
│
├──▶ [4] ASSEMBLY (Code Node — JavaScript)
│    // Combine image URLs, caption, hashtags, metadata
│    // Format preview message for Telegram
│    // Store assets in Google Drive
│
├──▶ [5] TELEGRAM APPROVAL (Send and Wait for Response)
│    Message format:
│    "📱 NEW POST READY FOR REVIEW
│     
│     📸 Platform: Instagram Feed
│     📅 Scheduled: {date} at {time}
│     
│     Caption:
│     {caption_text}
│     
│     Hashtags:
│     {hashtags}
│     
│     [Image attached]
│     
│     Reply:
│     ✅ — Approve & schedule
│     ✏️ {new caption} — Edit caption then approve  
│     ❌ — Reject & regenerate
│     🔄 — Regenerate image only"
│    
│    Response type: Free Text
│    Timeout: 4 hours (auto-skip if no response)
│
├──▶ [6] ROUTING (Switch Node)
│    ├── If starts with "✅" → Publish
│    ├── If starts with "✏️" → Update caption → Publish
│    ├── If starts with "❌" → Loop back to step 1 (max 3 retries)
│    └── If starts with "🔄" → Loop back to step 2
│
└──▶ [7] PUBLISH (HTTP Request → Buffer/Upload-Post API)
     // Schedule post with final approved content
     // Send confirmation to Telegram: "✅ Scheduled for {time}"
```

### Workflow 2: Video Content Pipeline

```
TRIGGER: Cron schedule (3x per week)
│
├──▶ [1] SCRIPT GENERATION (Claude API)
│    "Write a 15-second TikTok/Reels script about {topic}.
│     Include: hook (first 2 sec), main content, CTA.
│     Also provide a detailed shot-by-shot description
│     for AI video generation."
│
├──▶ [2] VOICE GENERATION (ElevenLabs API)
│    // Generate narration audio from script
│
├──▶ [3] VIDEO GENERATION (fal.ai → Kling 3.0 or Veo 3.1)
│    // Image-to-video with character reference
│    // Attach voice/audio
│
├──▶ [4] TELEGRAM PREVIEW
│    // Send video + script for approval
│    // Same approve/edit/reject flow
│
└──▶ [5] PUBLISH to TikTok + Instagram Reels + YouTube Shorts
```

### Workflow 3: Engagement & Growth Monitoring

```
TRIGGER: Daily at 20:00 CET
│
├──▶ [1] PULL ANALYTICS (HTTP Request → platform APIs)
│
├──▶ [2] ANALYZE (Claude API)
│    "Analyze these metrics. What performed well? What content
│     type should we double down on? Suggest tomorrow's content
│     angle based on trends."
│
└──▶ [3] TELEGRAM REPORT
     "📊 DAILY REPORT
      Followers: +{delta}
      Best post: {top_post}
      Engagement rate: {rate}
      💡 Suggestion: {ai_suggestion}"
```

---

## 5. MONETIZATION STRATEGY

### Phase 1: Growth (Month 1-3, target 0 → 10K followers)
- Post consistently (1-2x daily)
- Use trending sounds/formats on TikTok
- Cross-post everywhere
- Engage with other accounts (can be partially automated)
- No monetization yet — focus on content-market fit

### Phase 2: Initial Revenue (Month 3-6, 10K → 50K)
- **Affiliate marketing**: Promote AI tools, SaaS products, trading platforms
  - Use high-commission digital products (30-50% vs 3-5% physical)
  - Platforms: ShareASale, PartnerStack, individual SaaS affiliate programs
  - Swedish angle: Avanza, Nordnet affiliate programs for finance niche
- **Platform monetization**: YouTube Partner Program, TikTok Creator Fund
- **Start building email list** via lead magnet (free guide/checklist)

### Phase 3: Scale (Month 6-12, 50K+)
- **Brand sponsorships**: $500-$5,000 per post depending on niche
- **Digital products**: Sell templates, guides, mini-courses
- **Premium content**: Patreon/Fanvue for exclusive insights
- **Consulting/agency**: Offer AI influencer creation as a service

### Revenue Projections (Conservative)

| Month | Followers | Monthly Revenue |
|-------|-----------|----------------|
| 3 | 5-10K | $100-300 (affiliate) |
| 6 | 20-50K | $500-2,000 (affiliate + sponsors) |
| 9 | 50-100K | $2,000-5,000 (diversified) |
| 12 | 100K+ | $5,000-15,000 (full stack) |

---

## 6. TECH STACK & INFRASTRUCTURE

### Services & Costs

| Service | Purpose | Monthly Cost |
|---------|---------|-------------|
| **n8n** (self-hosted) | Workflow automation | Free (Docker on Mac Mini) |
| **fal.ai** | Flux 2 Max + Kling 3.0 API | ~$50-100 (usage-based) |
| **Anthropic API** | Claude for content generation | ~$20-50 |
| **ElevenLabs** | Voice generation | $22/mo (Starter) |
| **Buffer** or **Upload-Post** | Multi-platform scheduling | $15-30/mo |
| **Google Drive** | Asset storage | Free |
| **Telegram** | Approval bot | Free |
| **Domain + hosting** | Landing page / link-in-bio | ~$10/mo |
| **Total** | | **~$120-220/mo** |

### Local Infrastructure (Chris's Mac Mini 16GB)

```bash
# n8n runs locally in Docker
docker run -d --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  -e N8N_ENCRYPTION_KEY="your-key" \
  -e WEBHOOK_URL="https://your-tunnel.ngrok.io" \
  n8nio/n8n

# Expose n8n webhooks for Telegram (use Cloudflare Tunnel or ngrok)
cloudflared tunnel --url http://localhost:5678
```

---

## 7. PROJECT STRUCTURE

```
ai-influencer/
├── CLAUDE.md                    # This file
├── assets/
│   ├── character/
│   │   ├── references/          # Base character reference images
│   │   ├── outfits/             # 5-7 outfit variations
│   │   └── settings/            # Background/location references
│   ├── templates/
│   │   ├── instagram-post.json  # Post template metadata
│   │   ├── reel-script.json     # Video script template
│   │   └── thread-template.json # X thread template
│   └── brand/
│       ├── colors.json          # Brand color palette
│       ├── fonts.md             # Typography guidelines
│       └── voice-guide.md       # Tone & voice reference
├── n8n/
│   ├── workflows/
│   │   ├── daily-content.json       # Main content generation workflow
│   │   ├── video-pipeline.json      # Video content workflow
│   │   ├── analytics-report.json    # Daily metrics workflow
│   │   └── engagement-bot.json      # Auto-engagement workflow
│   ├── credentials.env.example      # Template for API keys
│   └── docker-compose.yml           # n8n + tunnel setup
├── prompts/
│   ├── content-ideation.md      # System prompts for ideation
│   ├── caption-writer.md        # Caption generation prompts
│   ├── image-prompt.md          # Flux image prompt templates
│   ├── video-script.md          # Video script prompts
│   └── analytics-analyst.md     # Analytics analysis prompts
├── scripts/
│   ├── setup.sh                 # Initial setup script
│   ├── generate-character.sh    # Character reference generation
│   └── test-apis.sh             # API connectivity tests
└── docs/
    ├── api-reference.md         # API endpoints & payloads
    ├── content-calendar.md      # Monthly content themes
    └── growth-playbook.md       # Growth hacking tactics
```

---

## 8. GETTING STARTED — STEP BY STEP

### Step 1: Set Up Infrastructure
```bash
# 1. Install Docker on Mac Mini (if not already)
# 2. Start n8n
docker-compose up -d

# 3. Set up Cloudflare Tunnel for webhook access
cloudflared tunnel create ai-influencer
cloudflared tunnel route dns ai-influencer n8n.yourdomain.com

# 4. Create Telegram bot via @BotFather
# 5. Get API keys for: Anthropic, fal.ai, ElevenLabs, Buffer
```

### Step 2: Create Character
```bash
# Generate base character with Flux 2 Max
# Use fal.ai playground or API to create:
# - Front-facing neutral portrait (1024x1024)
# - 3/4 angle portrait
# - Full body shot
# - 5 outfit variations
# Save all to assets/character/references/
```

### Step 3: Build n8n Workflows
1. Import workflow templates from `n8n/workflows/`
2. Configure all credentials
3. Test each workflow step individually
4. Run end-to-end test with Telegram approval

### Step 4: Content Calendar
Create a monthly content calendar with themes:
- Week 1: Educational (how-to, explainers)
- Week 2: Trend commentary (react to AI/tech news)
- Week 3: Personal/lifestyle (day-in-the-life, behind-the-scenes)
- Week 4: Engagement (polls, questions, challenges)

### Step 5: Launch
1. Set up social profiles (Instagram, TikTok, YouTube, X)
2. Post 9-12 grid images on Instagram before going "live"
3. Enable automated workflows
4. Monitor Telegram for daily approvals
5. Track metrics weekly, adjust strategy monthly

---

## 9. IMPORTANT LEGAL / ETHICAL NOTES

- **Always disclose AI nature** in bio: "AI-generated content" or "Virtual Creator"
- **EU AI Act compliance**: Mark AI-generated content appropriately
- **FTC guidelines**: Disclose all affiliate relationships and sponsorships
- **Platform ToS**: Instagram, TikTok etc. require disclosure of synthetic media
- **Copyright**: Ensure generated images don't infringe on identifiable real people
- **Swedish law**: Follow Marknadsföringslagen for sponsored content disclosure

---

## 10. KEY COMMANDS FOR CLAUDE CODE

When working on this project with Claude Code, use these task patterns:

```bash
# Generate content ideas
claude "Generate 5 Instagram post ideas for this week based on trending AI topics. Output as JSON with fields: hook, caption, image_prompt, hashtags"

# Create image prompts
claude "Write a Flux 2 Max prompt for our AI influencer character sitting in a Stockholm coffee shop, wearing outfit #3, explaining something on a laptop. Photorealistic, natural lighting."

# Write video scripts
claude "Write a 15-second TikTok script about {topic}. Include shot descriptions for AI video generation."

# Analyze and iterate
claude "Review these engagement metrics and suggest content adjustments: {paste metrics}"

# Debug n8n workflows
claude "Help me debug this n8n workflow JSON. The Telegram approval node isn't waiting for response properly."
```

---

## 11. SUCCESS METRICS

Track weekly:
- Follower growth rate (target: 10-15% weekly in early months)
- Engagement rate (target: 3-5% on Instagram, 5-8% on TikTok)
- Content approval rate (how many posts pass first review)
- Time from generation to publish (target: < 30 min including approval)
- Revenue per 1K followers
- Cost per post (API costs / posts published)

---

*Last updated: February 2026*
*Stack: Flux 2 Max + Kling 3.0 + Veo 3.1 + Claude Sonnet 4.5 + ElevenLabs + n8n + Telegram*
