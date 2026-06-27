# Corpify — Your AI Corporation

**40 AI specialists (52 in Pro). Your corporation. One-time purchase. Lifetime license.**

Corpify is a complete AI corporation — a curated team of 40 AI agents (52 in the Pro tier) organized by department (Executive, Sales, Marketing, Legal, Finance, Engineering, Research, and more) running inside Claude Code, with corporate memory and workflow commands.

## Installation

**Requires:** A license key (purchase at [corpify.tech](https://corpify.tech)).

### Windows (PowerShell)

```powershell
irm https://corpify.tech/install.ps1 | iex
```

### Mac / Linux (Terminal)

```bash
curl -s https://corpify.tech/install.sh | bash
```

The installer will:
1. Ask for your license key
2. Validate via the LemonSqueezy license server
3. Install missing prerequisites (Git, Node.js, VS Code, Claude Code)
4. Download the corporation into `~/corpify/`
5. Configure your tier (Standard or Pro)
6. Pro tier: install Voice Control (Whispering)
7. Open VS Code ready to use

## Uninstalling Corpify

Removes Corpify cleanly. Works even if a previous install was partial or broken.

### Windows (PowerShell)

```powershell
irm https://corpify.tech/uninstall.ps1 | iex
```

> Close VS Code first — otherwise the corporation folder stays locked and can't be deleted.

### Mac / Linux (Terminal)

```bash
curl -s https://corpify.tech/uninstall.sh | bash
```

**Preview without changing anything (dry run):**
- Windows: `powershell -ExecutionPolicy Bypass -File uninstall.ps1 -DryRun`
- Mac / Linux: `bash uninstall.sh --dry-run`

The uninstaller will:
1. Offer to back up your corporation's memory first
2. Remove `~/corpify`, `~/.corpify`, and the desktop shortcut
3. Ask before removing third-party tools (Git, Node.js, VS Code, Claude Code) — kept by default
4. Never remove Homebrew or anything not installed by Corpify
5. Offer to restore GitHub Copilot

A copy of `uninstall.ps1` / `uninstall.sh` also ships inside `~/corpify`.

## What you get

### Standard ($149)

- 40 AI specialists in 9 departments
- Corporate memory & task workflow (persists across sessions)
- 14 PULSE Protocol integration packages (links and setup guides)
- Course modules and bonus guides:
  - `docs/04-business-discovery/` — how the CEO finds profitable niches
  - `docs/05-vibe-coding/` — annotated guide to using AI for building
  - `docs/06-corporate-os/` — start the visual office on port 8002
  - `docs/08-pulse-protocol/` — 14 AI/exchange integrations
  - `docs/10-ai-credits/` — apply for up to $50K in startup credits
  - `docs/faq/` — installation, troubleshooting, refunds

### Pro ($299) — Standard plus:

- 12 additional engineering specialists (Software Architect, AI/ML Engineer, Backend, Frontend, DevOps, Security, QA, Bug Fixer, Database Optimizer, Tech Lead, Project Manager, Performance Benchmarker)
- **Voice Control** — bundled Whispering open-source dictation tool ([github.com/EpicenterHQ/epicenter](https://github.com/EpicenterHQ/epicenter)). Hold a key, speak, release — your text appears in any window.

## Ongoing costs

Corpify is one-time. No subscription to Corpify itself.

You will need:
- **Anthropic API key** (~$20-50/month for typical usage) — get it at [console.anthropic.com](https://console.anthropic.com). Many qualify for free credits — see `docs/10-ai-credits/`.
- **Optional 24/7 server** ($5-20/month) — only if you want the corporation to work autonomously when your computer is off.

## License

This is proprietary software. Your license key activates one installation per machine. See `LICENSE-NOTICE.md`.

## Support

- Email: support@corpify.tech
- Refunds: 14 days, before license activation (see corpify.tech/legal/refund.html)
- Website: [corpify.tech](https://corpify.tech)

## About this repository

This is the public installer + agent definitions + guides. The product is sold by [LemonSqueezy.com LLC](https://www.lemonsqueezy.com) (Iowa, USA) as Merchant of Record. See [corpify.tech/impressum](https://corpify.tech/impressum.html) for operator details.
