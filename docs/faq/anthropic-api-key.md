# Powering Your Corporation — Claude Pro vs API Key

Corpify uses Claude (by Anthropic) as the brain for every agent. It runs on
**your own Claude account**. There are two ways to power it — and for almost
everyone, the first one is the right choice.

## ✅ Recommended: Claude Pro subscription ($20/month, flat)

This is the predictable, worry-free option.

1. Go to **https://claude.ai** and subscribe to **Claude Pro** ($20/month).
2. Open Claude Code (in VS Code click the Claude Code icon, or run `claude`
   in a terminal). When it asks you to sign in, choose **"Sign in with your
   Claude account"** and log in with the account you just subscribed.

That's it — your whole corporation now runs on your flat $20/month plan.

**Why this is best:** the cost is fixed. When you hit a usage limit, the
corporation simply pauses ("try again in X minutes") — **nothing is broken,
nothing is lost.** You wait a little, then continue. **Your cost never goes
above your plan**, so you can never get a surprise bill.

> Need more capacity? **Claude Max** (also on claude.ai) gives much higher
> limits for $100–200/month — still flat and predictable.

## ⚙️ Advanced: Anthropic API key (pay-as-you-go)

Choose this **only** if you have outgrown the subscription and specifically
want extra pay-per-use capacity.

> ⚠️ **Warning:** the API bills for every token used. A busy day of reports
> and analyses can spend a $20 balance quickly. Always set a billing limit so
> it can never surprise you. This is exactly why we recommend the flat Claude
> Pro subscription for most owners.

### Step 1 — Create an Anthropic account
Go to **https://console.anthropic.com** and sign up (Google or email).

### Step 2 — Add billing AND a spending limit
**Plan & Billing** → add a payment method → **set a monthly billing limit**
so spend can never exceed the amount you choose. New accounts often get a
small free credit ($5–10) to start.

### Step 3 — Create an API key
- **API Keys** → **Create Key** → name it `Corpify`
- Copy it (shown once). It looks like: `sk-ant-api03-xxxxxxxx...`

### Step 4 — Tell Corpify
Open `~/corpify/.env` (copy from `.env.example` if `.env` doesn't exist) and add:

```
ANTHROPIC_API_KEY=sk-ant-api03-...
```

Save. The next time you start the corporation, it uses your key.

### Cost monitoring
The Anthropic console **Usage** tab shows daily/monthly spend. Keep your
**billing limit** on. The CFO agent in your corporation can also help optimize
usage if costs climb.

## Apply for free credits ($50K+ potential)

Many entrepreneurs qualify for **startup credits** that cover most or all
typical usage. See `docs/10-ai-credits/` for application guides:

- Anthropic Startup Program
- Google Cloud for Startups
- Microsoft Founders Hub
- OpenAI for Startups

Approval isn't guaranteed but it's free to apply.

## Troubleshooting (API key)

**"401 Unauthorized"** — key is invalid or revoked. Regenerate at
console.anthropic.com.

**"Insufficient credit"** — add balance at console.anthropic.com → Billing.

**Worried about leaking the key** — never paste it in a public chat,
screenshot, or GitHub repo. The `.env` file is git-ignored by default, so it
stays local. If you suspect a leak: rotate immediately (revoke old, create new).
