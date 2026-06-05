# PULSE Protocol Packages

Each package is open-source. Install only what you need via `pip install <package>`.

## Core packages

### pulse-python
**Purpose:** Core PULSE library — base classes, common utilities, security primitives.
**Install:** `pip install pulse-python`
**Repo:** https://pypi.org/project/pulse-python/

### pulse-gateway
**Purpose:** Security layer — input sanitization, prompt-injection defense, rate limiting between agents and external APIs.
**Install:** `pip install pulse-gateway`
**Repo:** https://pypi.org/project/pulse-gateway/

### pulse-proton
**Purpose:** Ultra-fast typed data exchange between agents (binary protocol). Use when agents need to pass large structured datasets quickly.
**Install:** `pip install pulse-proton`
**Repo:** https://pypi.org/project/pulse-proton/

## AI Provider integrations

### pulse-anthropic
**Purpose:** Native Claude (Anthropic) integration. Often pre-configured because Corpify uses Claude as the default brain.
**Install:** `pip install pulse-anthropic`
**Repo:** https://pypi.org/project/pulse-anthropic/

### pulse-openai
**Purpose:** Connect OpenAI's GPT models (e.g. fallback if Claude API is rate-limited).
**Install:** `pip install pulse-openai`
**Repo:** https://pypi.org/project/pulse-openai/

### pulse-perplexity
**Purpose:** Give agents the ability to do live web research via Perplexity AI.
**Install:** `pip install pulse-perplexity`
**Repo:** https://pypi.org/project/pulse-perplexity/

### pulse-ollama
**Purpose:** Run AI models 100% locally on your machine (no cloud, no API keys). Slower but private.
**Install:** `pip install pulse-ollama`
**Setup:** Also install Ollama itself: https://ollama.ai
**Repo:** https://pypi.org/project/pulse-ollama/

## Crypto exchange integrations

> ⚠️ **Disclaimer:** These packages are software libraries for technical integration with public exchange APIs. They do NOT constitute investment advice. Use at your own risk. Corpify does not provide cryptocurrency exchange, transmission, or custody services and is not a virtual currency business.

### pulse-binance
**Purpose:** Read account state, prices, market data from Binance (read-only recommended).
**Install:** `pip install pulse-binance`
**Repo:** https://pypi.org/project/pulse-binance/

### pulse-bybit
**Purpose:** Same as above for Bybit.
**Install:** `pip install pulse-bybit`
**Repo:** https://pypi.org/project/pulse-bybit/

### pulse-okx
**Purpose:** Same for OKX.
**Install:** `pip install pulse-okx`
**Repo:** https://pypi.org/project/pulse-okx/

### pulse-kraken
**Purpose:** Same for Kraken.
**Install:** `pip install pulse-kraken`
**Repo:** https://pypi.org/project/pulse-kraken/

## Notes on installation

- All PULSE packages support Python 3.10+
- They follow Semantic Versioning — pin a version in production if reliability matters
- Each package has its own `.env` variables documented in its README on PyPI

## Notes on availability

Some packages above may be in active development as of the date you read this. If `pip install` says "no matching distribution found":

1. Check the PyPI URL above for the latest version available
2. Some packages may have transitioned to a different name
3. Search GitHub for `pulse-<provider>` for the source repository
4. As a fallback, the corp-ai-scout and corp-skills-hunter agents can find an equivalent open-source library that fills the same role

If a critical integration is missing, email **support@corpify.tech** and we'll point you at the current canonical option.
