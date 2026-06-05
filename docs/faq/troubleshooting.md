# General Troubleshooting

## My agents don't respond / nothing happens

### Check 1 — Anthropic API key

The most common cause. Open `~/corpify/.env` and confirm:
```
ANTHROPIC_API_KEY=sk-ant-api03-...
```
If empty or missing, see [anthropic-api-key.md](anthropic-api-key.md).

### Check 2 — Claude Code running?

Open VS Code → look for the Claude Code panel (sidebar, anthropic logo). If missing, run from the VS Code command palette (Cmd/Ctrl+Shift+P): "Claude Code: Open Panel".

### Check 3 — Network

Anthropic API needs internet. Try:
```bash
curl https://api.anthropic.com
```
Should return a small response, not an error.

### Check 4 — Try a known-good agent

```
@corp-ceo Are you there?
```

Should respond within 5-10 seconds.

## Agent gives nonsense / hallucinates facts

AI hallucinations happen. Strategies:

- **Be more specific** in your prompt
- **Reference Archivarius**: "@corp-archivarius what did we decide about X last week?"
- **Ask for sources**: "Cite the URL / data behind that claim"
- **Cross-check** important claims (market data, financial advice, legal interpretation)

Remember: AI agents are not licensed professionals. Always verify high-stakes output (legal, tax, financial, medical) with a real expert.

## Visual Office (port 8002) won't load

### Server not started

```bash
cd ~/corpify/06-corporate-os
# (or wherever AI Team OS is installed)
./start.sh  # or equivalent
```

Then open `http://127.0.0.1:8002` in your browser.

See `docs/06-corporate-os/README.md` for full setup.

### Port already in use

Another app may be on port 8002. Stop it or change Corpify's port via config.

### Browser shows blank page

Hard refresh (Ctrl+Shift+R / Cmd+Shift+R). If still blank, check browser console (F12 → Console) and report what you see.

## License says "already activated"

You activated this license on a different machine. Each license is 1-machine. Options:

- Reactivate on this machine (deactivates the other one) — email support
- Buy a second license

## Slow responses

- **Claude Sonnet 4.6** (default) is the speed-quality balance
- For faster but rougher: try Claude Haiku 4.6 — set in `.env`:
  ```
  ANTHROPIC_MODEL=claude-haiku-4-6
  ```
- For deeper but slower: Claude Opus 4.7 — set:
  ```
  ANTHROPIC_MODEL=claude-opus-4-7
  ```

Higher-tier models cost more per token.

## Voice Control (Pro) not working

- Did you grant microphone permission? Check OS settings.
- Is Whispering running? Start it from your apps menu.
- Did you choose Whisper.cpp (local) as provider in Whispering settings?

See `docs/11-voice-control/README.md`.

## Reset everything

Nuclear option — wipe and reinstall:

```bash
# Mac/Linux
rm -rf ~/corpify ~/.corpify
curl -s https://corpify.tech/install.sh | bash

# Windows PowerShell
Remove-Item -Recurse -Force ~/corpify, ~/.corpify
irm https://corpify.tech/install.ps1 | iex
```

You'll need your license key again. Note: this also wipes your corporation's local memory. The decisions and project state saved in `~/corpify/memory/` will be lost.

## Still stuck

Email **support@corpify.tech** with:
- Tier (Standard / Pro)
- Operating system + version
- What you tried
- Exact error message (screenshot OK)
- Claude Code version (`claude --version`)
- Order ID from your purchase email

We respond within 24 hours.
