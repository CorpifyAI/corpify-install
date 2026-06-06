# Anthropic limits & Claude Code sessions — what every Owner needs to know

This is one of the most common confusions for new Owners. Read this once and you'll save yourself many "why did it stop?" panics.

---

## Part 1 — Anthropic usage limits (the "fuel tank")

Your AI Corporation runs on **Claude** by Anthropic. Every message your agents send and receive consumes a small amount of credit (called *tokens*).

Anthropic limits how much you can use per minute / hour / day to keep the service stable. When you reach a limit, your corporation pauses for a short time — then resumes automatically. **Nothing is lost. Nothing is broken. It's just a brief refuel.**

### Two ways your corporation can be powered

Most Owners use **one** of these two billing setups. You picked one when you installed Corpify.

#### A. Anthropic API key (pay-per-use)

- You added an `ANTHROPIC_API_KEY` to your `.env` file during install
- You're billed per token used — no monthly fee
- Limits depend on your tier (Tier 1, Tier 2…) which Anthropic upgrades automatically as your spend grows
- **Where to check your spend & limits:** [https://console.anthropic.com/settings/usage](https://console.anthropic.com/settings/usage)
- **Where to manage your API keys:** [https://console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys)

#### B. Claude Pro / Max subscription (flat monthly)

- You subscribe to claude.ai for $20/mo (Pro) or $200/mo (Max)
- Claude Code can use your subscription instead of an API key (no billing per token)
- Limits are reset on a rolling window — Pro is more restrictive, Max is generous
- **Where to check your usage:** [https://claude.ai/new#settings/usage](https://claude.ai/new#settings/usage)

> 💡 **Which should you use?**
>
> - If you'll work with the corporation **a few hours per day** → Claude Pro/Max is usually cheaper.
> - If you'll use it **occasionally / lightly** → API key is cheaper.
> - If you want to **scale teams or run agents in parallel** → API key with auto-tier-upgrades scales better.
>
> You can switch any time — the corporation works the same.

### What happens when you hit a limit

You'll see a message like:

```
⚠️ Rate limit reached. Please wait a few minutes and try again.
```

or

```
You've hit your usage limit. Resets at HH:MM UTC.
```

**What to do:**

1. **Don't panic.** Nothing is broken.
2. **Wait.** Limits reset on rolling windows — usually 1 to 60 minutes.
3. **Resume.** Just send your next message after the wait. The corporation picks up where it left off.

**Tip:** if you hit limits often, you have two options:

- **For API users:** spend more (Anthropic auto-promotes you to higher tiers with bigger limits)
- **For subscription users:** upgrade Pro → Max, or switch to API
- **For everyone:** delegate fewer tasks at once, or use lighter models for routine work

---

## Part 2 — Claude Code sessions (the "conversation thread")

A **session** in Claude Code is one continuous conversation with the corporation. Everything you and the agents say in one session is remembered while the session is open.

### Why sessions have limits

Each session keeps a "context" — every message, every tool call, every file read. This context has a maximum size (currently **200,000 tokens** ≈ ~500 pages of text).

When a session grows large:
- It becomes **slower** (more text to process every turn)
- It costs **more per message** (you're sending the whole context each time)
- Eventually it **fills up** and Claude Code auto-compresses or warns you

### Three commands every Owner should know

In Claude Code, type these as messages:

#### `/compact`
- Compresses the session: keeps recent turns intact, summarizes older ones
- The corporation **doesn't lose memory** — Archivarius already saved the important stuff
- Use this when the session feels slow but you want to keep going on the same task

#### `/clear`
- Closes the current session and starts a fresh one
- Memory in `.claude/memory/` survives — your CEO will remember you next time
- Use this when switching to a completely new topic

#### `/cost`
- Shows how many tokens this session has consumed and the dollar cost
- Great sanity check before delegating a giant task

### When should you start a new session?

**Start fresh (`/clear`) when:**
- You're switching to a totally different project ("now help me plan marketing" after a coding sprint)
- The session has been running for hours and feels sluggish
- You see Claude Code warn about context size
- You want a clean slate for an important decision

**Stay in the session (or `/compact`) when:**
- You're mid-task and the agents need recent context
- You're iterating on something (writing → reviewing → fixing)
- The conversation is still focused on one goal

> 💡 **Rule of thumb:** if you can describe your next request without referring to "that thing we talked about earlier" → it's safe to `/clear`.

---

## Part 3 — Why does memory survive across sessions?

Two layers of memory keep your corporation continuous:

1. **Session memory** — the chat history you see. Lost on `/clear`.
2. **Persistent memory** — files in `.claude/memory/` and the AI Team OS database. **Never lost.** This is where the **Archivarius** agent stores: your name, your business, key decisions, past projects, the CEO's chosen name, etc.

When you start a new session, the CEO loads persistent memory at startup. That's why the second time you say "hi" — the corporation remembers you.

> If you want to verify, ask: *"Archivarius, what do you remember about me?"* — you'll get a structured summary.

---

## Part 4 — Common situations & answers

### "I asked for a big task and it stopped halfway"
Probably hit a rate limit. Wait 5–10 minutes and ask the agent to **continue from where it left off**. They'll resume.

### "Claude Code says 'context low' — what now?"
Run `/compact`. The session shrinks, you keep going.

### "I used Claude Code yesterday and today it doesn't remember"
That's normal — sessions don't persist by default. But the corporation's **persistent memory** does. Ask the CEO "what did we work on yesterday?" — they'll check Archivarius.

### "I want to see how much I've spent"
- API: [https://console.anthropic.com/settings/usage](https://console.anthropic.com/settings/usage)
- Pro/Max subscription: [https://claude.ai/new#settings/usage](https://claude.ai/new#settings/usage)
- Current session only: type `/cost` in Claude Code

### "I keep hitting limits. Is something wrong?"
No. You're using the corporation actively, which is the point. Solutions in order of effort:
1. Wait it out (5–60 min)
2. Use `/compact` to shrink the session — limits are per-token, smaller session = fewer tokens per call
3. Split big tasks into smaller chunks across the day
4. Upgrade tier (API) or plan (Pro → Max)

### "What if Anthropic goes down?"
Rare but it happens. Check [https://status.anthropic.com](https://status.anthropic.com). When it comes back, the corporation works again. Nothing on your machine breaks.

---

## TL;DR

| Concept | What it means | What to do |
|---------|---------------|------------|
| **Rate limit** | "Out of fuel for now" | Wait, then continue |
| **Session** | One open conversation | Use `/compact` or `/clear` |
| **Persistent memory** | What survives `/clear` | Archivarius handles it |
| **Usage dashboard** | See your spend | API: console.anthropic.com/settings/usage · Subscription: claude.ai/new#settings/usage |

---

## Still stuck?

Ask your CEO: *"I'm confused about limits / sessions / usage."* They'll walk you through it based on your specific setup, and they have the full Anthropic docs at hand.

Or email: **support@corpify.tech**
