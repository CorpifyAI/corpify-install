# Anthropic API Key

Corpify uses Claude (made by Anthropic) as the brain for every agent. To run Claude, you need an API key from Anthropic.

## Why a separate API key?

Two reasons:

1. **You pay Anthropic directly** for your usage. Corpify is one-time; ongoing AI costs are between you and Anthropic.
2. **Privacy** — your business data goes through your own Anthropic account, not ours.

Typical cost: **$20-50/month** for light-to-moderate solo entrepreneur use. Could be higher if the corporation is busy generating reports and analyses all day.

## How to get one

### Step 1 — Create Anthropic account

Go to **https://console.anthropic.com** and sign up. You can use Google login or email + password.

### Step 2 — Add billing

Click **Plan & Billing** in the left sidebar → add a payment method. You'll be charged only for what you use (pay-as-you-go).

Most new accounts get a small **free credit** ($5-10) to start.

### Step 3 — Create an API key

- Left sidebar → **API Keys** → **Create Key**
- Name it: `Corpify` (or anything you'll recognize)
- Workspace: Default
- Click **Create** and **copy** the key (it's shown once; if you lose it, create a new one)

The key looks like:
```
sk-ant-api03-xxxxxxxxxxxxxxxxxxxx...
```

### Step 4 — Tell Corpify

Open `~/corpify/.env` (or copy from `.env.example` if `.env` doesn't exist yet). Add:

```
ANTHROPIC_API_KEY=sk-ant-api03-...
```

Save the file.

You're done. The next time you start the corporation, it will use your key.

## Apply for free credits ($50K+ potential)

Many entrepreneurs qualify for **startup credits** that cover most or all of typical usage. See `docs/10-ai-credits/` for application guides for:

- Google Cloud for Startups
- Anthropic Startup Program
- OpenAI for Startups
- Microsoft Founders Hub

Approval is not guaranteed but free to apply.

## Cost monitoring

In the Anthropic console, **Usage** tab shows daily / monthly spend. Set a **billing limit** to cap monthly spend if you want a hard ceiling.

The CFO agent inside your corporation can also help you optimize Claude usage if costs get high.

## Troubleshooting

### "401 Unauthorized" error

Key is invalid or revoked. Regenerate at console.anthropic.com.

### "Insufficient credit" error

Add credit balance at console.anthropic.com → Billing.

### Worried about leaking the key

Never paste it in a public chat, screenshot, or GitHub repo. The `.env` file is git-ignored by default in Corpify, so it stays local.

If you suspect a leak: rotate immediately (revoke old, create new) at console.anthropic.com.
