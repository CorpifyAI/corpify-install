# Corporate Memory

This folder is the **persistent memory** of your AI Corporation. It survives between Claude Code sessions — the corporation will remember you, your goals, and key decisions across reboots.

## How it works

- **Owner facts** — your name, business, priorities — live in `owner_*.md` files
- **Decisions** — important choices made by the team — live in `decisions/`
- **Projects** — state of each ongoing project — live in `projects/`
- **Lessons** — what the team learned — live in `lessons/`
- **Index** — running table-of-contents in `index.md`

The `corp-archivarius` agent owns this folder. Other agents query it through Archivarius.

## Why this matters

Without persistent memory, every Claude Code session starts from zero. With it, the corporation knows you. CEO will sign off by name, COO will resume projects where you left off, Lawyer will remember the country you operate in.

## Can I edit these files manually?

Yes — they're plain Markdown. Useful if you want to seed information ("here's my goal", "here's my favourite tools") before the corporation has had time to learn.

## Privacy

This folder lives **only on your computer**. Nothing is sent to Anthropic or any other service. If you uninstall Corpify, this folder stays unless you delete it.
