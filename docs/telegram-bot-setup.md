# Telegram Bot Setup Guide

## 1. Create the Bot

1. Open Telegram and search for `@BotFather`
2. Send `/newbot`
3. Choose a display name: e.g., `AI Influencer Control`
4. Choose a username: e.g., `ai_influencer_ctrl_bot`
5. Copy the **bot token** — save it as `TELEGRAM_BOT_TOKEN` in `n8n/credentials.env`

## 2. Get Your Chat ID

1. Send any message to your new bot
2. Open this URL in your browser (replace `YOUR_TOKEN`):
   ```
   https://api.telegram.org/botYOUR_TOKEN/getUpdates
   ```
3. Find `"chat":{"id":XXXXXXXX}` in the response
4. Save this number as `TELEGRAM_CHAT_ID` in `n8n/credentials.env`

## 3. Configure Bot in n8n

1. In n8n, go to **Credentials** > **Add Credential** > **Telegram API**
2. Enter the bot token
3. The Telegram nodes in our workflows use this credential

## 4. Approval Flow Commands

The bot sends formatted previews and waits for your response:

| Response | Action |
|----------|--------|
| `yes` or message starting with `✅` | Approve and schedule the post |
| Message starting with `✏️` followed by text | Replace caption with the text after ✏️, then approve |
| `no` or message starting with `❌` | Reject and regenerate (up to 3 retries) |
| `🔄` | Keep caption, regenerate image only |

### Timeout Behavior
- If no response within **4 hours**, the post is auto-skipped
- A notification is sent: "Post skipped due to no response"

## 5. Message Format

Posts arrive in this format:
```
📱 NEW POST READY FOR REVIEW

📸 Platform: Instagram Feed
📅 Scheduled: 2026-02-15 at 17:00 CET

Caption:
Here's the thing about AI in 2026...

Hashtags:
#AI #Tech #Stockholm #AIInfluencer ...

[Image attached]

Reply:
✅ — Approve & schedule
✏️ {new caption} — Edit caption then approve
❌ — Reject & regenerate
🔄 — Regenerate image only
```

## 6. Daily Report Format

```
📊 DAILY REPORT — 2026-02-14

📈 Followers: 1,234 (+45)
🏆 Best post: "AI Tools Comparison" (2.3K reach)
💬 Engagement rate: 4.2%
💡 Suggestion: Double down on tool comparison content — highest engagement this week

📱 IG: 890 | TT: 234 | YT: 78 | X: 32
```
