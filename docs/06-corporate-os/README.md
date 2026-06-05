# Block 06 — Corporate OS (Visual Office)

## What Corporate OS is

A web dashboard ("visual office") that shows your entire corporation at a glance. Click any team member to chat with them. See what tasks are open. See meetings, briefings, decisions, memory.

It runs locally on your computer at `http://127.0.0.1:8002` — your data stays with you.

## What's bundled

When you installed Corpify, the Corporate OS components were copied to `~/corpify/06-corporate-os/`:

- A Python MCP (Model Context Protocol) server — the brain. Tracks projects, tasks, teams, decisions.
- A React/TypeScript dashboard — the front-end. Visual office UI.
- A SQLite database — where your corporation's memory lives.

## Starting the visual office

### One-time setup

The first time, install Python dependencies:

```bash
cd ~/corpify/06-corporate-os
python3 -m venv venv
source venv/bin/activate   # (Windows: venv\Scripts\Activate.ps1)
pip install -r requirements.txt
```

### Daily start

From the same folder:

```bash
# Mac/Linux
./start.sh

# Windows
.\start.ps1
```

Or manually:
```bash
python3 server.py &       # MCP server
python3 -m http.server 8002 --directory dashboard/dist
```

### Open in browser

Visit:
```
http://127.0.0.1:8002
```

The visual office loads.

## What you see

**Dashboard tabs (top navigation):**

| Tab | What it shows |
|-----|---------------|
| 🏠 Home | Today's summary — pending tasks, recent activity |
| 👥 Agents | Your team grid. Click anyone to chat. |
| 📋 Tasks | Task wall. Drag to reorder. See who's working on what. |
| 🤝 Meetings | Scheduled and past multi-agent discussions |
| 💼 Projects | All projects, their teams, their status |
| 📊 Analytics | What got done this week / month |
| 📚 Reports | Generated reports from various agents |
| 🔔 Briefings | Decisions waiting for your approval |
| 🌐 Ecosystem | Integrations and tools your corp uses |
| ⚙️ Settings | Configure |

## Clicking an agent

When you click a team member (Agents tab):
- Their bio appears
- A chat window opens
- Anything you type goes to that specific agent
- Their response appears below

Same as `@corp-ceo Hello` in Claude Code, but with a friendlier interface.

## Night mode (autonomous operation)

If you want the corporation to keep working while you sleep:

1. In Settings → Night Mode → enable
2. Set: which agents stay active, what kinds of tasks to advance
3. In the morning, check briefings — what decisions waited for you

For night mode to actually work overnight, your computer must stay on, OR you need to run Corporate OS on a small server (see `docs/06-corporate-os/server-deployment.md` if/when added).

## Mobile

The dashboard is responsive. Open the same URL from your phone (only on the same local network) to glance at your corporation from anywhere in the house.

## When things don't work

### Browser shows "can't reach server"

Server didn't start. Re-run start command, check terminal for errors.

### Page loads but no agents visible

The local database may be empty (first run). Click any agent name from Claude Code first (`@corp-ceo Hello`) — that activates them in the system. They'll appear in the dashboard after.

### Port 8002 in use

```bash
# Mac/Linux — find what's using it:
lsof -i :8002

# Windows:
netstat -ano | findstr :8002
```

Stop that process or change Corpify's port in `config.json` and restart.

### "Module not found" Python errors

You forgot to activate the venv:
```bash
source venv/bin/activate  # or Windows equivalent
```

## Privacy

Everything is local. No data leaves your machine — except the Claude API calls (which go to Anthropic per your API key). The dashboard server only listens on `127.0.0.1` (localhost), not exposed to the internet.

## What this is NOT

- Not a SaaS — you run it yourself
- Not multi-user out of the box (single-Owner design)
- Not a replacement for working in Claude Code — both surfaces talk to the same corporation
