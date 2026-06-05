# Block 08 — PULSE Protocol Integration Packages

## What PULSE is

PULSE is a family of open-source Python packages that make it easy for your corporation's agents to talk to AI providers, exchanges, and data sources. Each package is a thin, secure wrapper that handles authentication, rate limits, error retries, and a unified interface.

Think of PULSE as the corporation's circulatory system — it carries data and instructions between agents and the outside world.

## What's in this folder

- `README.md` (this file) — overview
- `packages.md` — full list with description, install command, GitHub link

## Where the code lives

PULSE packages are open source. Your Corpify license includes **guides and configurations** to use them — but the actual package code lives in their public repositories. You install what you need via `pip`.

Why this design?
- You pull only what you'll use (smaller install)
- You get updates from the package maintainers directly
- You see the source code (audit anything sensitive yourself)

## Quick start — pick a use case

### "I want my agents to use OpenAI as backup if Claude is down"
```bash
pip install pulse-openai
```
Then configure in `.env`:
```
OPENAI_API_KEY=sk-...
```

### "I want my CFO agent to read my Binance balance"
```bash
pip install pulse-binance
```
Configure with Binance read-only API key.

### "I want the corporation to run on local AI (no cloud)"
```bash
pip install pulse-ollama
```
Install Ollama separately (https://ollama.ai), then point Corpify at `localhost:11434`.

## Security notes

**Critical:** PULSE crypto packages (binance, bybit, okx, kraken) are technical integration libraries — NOT investment advice.

- Use **read-only API keys** when possible
- **Never** give an agent withdrawal permissions
- **Never** auto-execute trades — always require human approval
- Corpify is NOT a registered investment advisor, broker-dealer, or money services business

See `LICENSE-NOTICE.md` and the AI Disclaimer at https://corpify.tech/legal/ai-disclaimer.html for full disclosure.

## See also

- [packages.md](packages.md) — every available PULSE package with link
