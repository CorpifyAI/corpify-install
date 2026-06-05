# Block 11 — Voice Control (Pro tier only)

## What it is

Press and hold a hotkey. Speak naturally into your microphone. Release the hotkey. Your words appear as text wherever your cursor is — Claude Code chat, browser email, document, anywhere.

It's faster than typing for many tasks. Especially great for:
- Long prompts to AI agents
- Brainstorming
- Notes while you're thinking out loud
- People with RSI / typing fatigue

## What we bundle

Corpify Pro bundles **Whispering**, an open-source dictation app:
- **License:** MIT (commercial use OK)
- **Source:** https://github.com/EpicenterHQ/epicenter
- **Privacy:** 100% local transcription option using Whisper.cpp — your voice never leaves your computer
- **Cross-platform:** Windows, macOS (Intel + Apple Silicon), Linux

## Installation

The Pro installer ran `voice/install-whispering.{ps1,sh}` and either:
1. Installed Whispering via your package manager (winget, brew), or
2. Downloaded the latest release from GitHub and ran the installer.

Check by opening your applications list — there should be **"Whispering"**.

If install failed (rare), see Manual install below.

## First-time setup

### Step 1 — Open Whispering

From your app menu. First launch may take 10-20 seconds while it prepares.

### Step 2 — Choose transcription provider

Settings → Transcription → choose **Whisper.cpp (local)** for 100% private operation.

Alternatives if you want cloud speed:
- Groq (very fast, requires Groq API key)
- OpenAI Whisper (requires OpenAI API key)
- ElevenLabs (paid)

For maximum privacy, stick with Whisper.cpp local.

### Step 3 — Pick a model

Whisper offers different sized models — trade-off between speed and accuracy:

| Model | Size | Speed | Quality | Languages |
|-------|------|-------|---------|-----------|
| tiny | ~75 MB | Fastest | OK | 90+ |
| base | ~150 MB | Fast | Good | 90+ |
| small | ~500 MB | Medium | Better | 90+ |
| medium | ~1.5 GB | Slow | Very good | 90+ |
| large | ~3 GB | Slowest | Best | 90+ |

**Recommended for first try:** base.en (English only, fast, good quality).

If you speak multiple languages, pick `base` (no `.en` suffix) for multilingual.

The model downloads on first use (one-time).

### Step 4 — Set your hotkey

Settings → Hotkey → click the field and press your preferred combination.

Recommendations:
- **Right Control** (one-key)
- **Right Alt** (one-key)
- **Ctrl + Space** (familiar)

Avoid common combinations like Ctrl+C / Ctrl+V — they'd conflict.

### Step 5 — Grant microphone permission

On first hotkey press, your OS will ask. Allow.

### Step 6 — Test it

Open Claude Code panel in VS Code. Hold your hotkey, say:
> "Hello, I am setting up voice control for Corpify"

Release. The text should appear in the Claude Code text box.

If it doesn't:
- Check microphone is selected correctly (Settings → Audio)
- Speak closer to the mic
- Check the Whispering log for errors

## How to use

### Pattern 1 — Talk to your CEO
```
[Hold hotkey]
"Hey CEO, I had a thought about expanding into the European market. 
Can you research what we'd need to do legally and operationally 
to start selling in Germany and the UK?"
[Release hotkey]
```

Text appears. Click send. CEO responds.

### Pattern 2 — Quick capture
While in any text field (notes, doc, email), hold the hotkey to dictate ideas as they come.

### Pattern 3 — Coding by voice
```
[Hold hotkey]
"Create a Python function that takes a list of numbers and returns 
only the prime numbers."
[Release hotkey]
```

Send to Claude Code → it writes the function.

## AI text cleanup (optional)

Whispering can pass your raw transcription through an AI model that:
- Adds punctuation
- Removes "umm", "uh", "you know"
- Capitalizes properly

Settings → Transformations → enable. Choose Claude (or another model with API key).

This adds ~1-2 seconds latency but produces cleaner text.

## 90+ languages

If using a multilingual model, Whispering auto-detects the language. Speak French, Spanish, German, Chinese, Arabic — it transcribes in that language.

You can also explicitly pick a language in Settings if auto-detect gets it wrong.

## Manual install (if auto-install failed)

### Windows
1. Visit https://github.com/EpicenterHQ/epicenter/releases
2. Download latest `.msi` or `.exe` for Windows
3. Run the installer
4. Continue from "First-time setup" above

### macOS
1. Visit https://github.com/EpicenterHQ/epicenter/releases
2. Download latest `.dmg` for your chip (Intel or Apple Silicon)
3. Open the DMG, drag Whispering to Applications
4. First open: right-click → Open (macOS Gatekeeper warning is expected)

Or via Homebrew:
```bash
brew install --cask whispering
```

### Linux
Download AppImage from the releases page. Make executable. Run.

## Troubleshooting

### "No mic detected"
OS-level audio permission missing. Check OS settings → Privacy → Microphone.

### Transcription is wrong
- Try a larger model (small or medium)
- Speak slower
- Reduce background noise

### Hotkey doesn't work in some apps
Some apps capture global hotkeys (gaming, video conferencing). Try a different hotkey or pause those apps.

### Whispering won't start
Check the Whispering log file (in app data folder). Common cause: model download incomplete — delete model and re-download.

## License & credits

Whispering is by [EpicenterHQ](https://github.com/EpicenterHQ) under MIT license. We're grateful for their work.

Corpify bundles it without modification. Their app, our integration glue.
