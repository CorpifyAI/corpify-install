# Block 05 — Vibe-Coding: Build Without Writing Code

## What "vibe-coding" means here

Vibe-coding is **describing what you want in plain English** to an AI assistant (Claude Code) that writes the actual code for you. You don't need to know a programming language. You need to be clear about what you want.

This is a skill worth thousands of dollars to learn — and the foundation of how your corporation builds things for you.

## Your tool: Claude Code in VS Code

Claude Code was already installed during Corpify setup. Here's what you're looking at when you open VS Code:

```
┌─────────────────────────────────────────────────────────────┐
│  File  Edit  View  ...  Run  Help                  [- □ X] │  ← Window menu
├──────┬──────────────────────────────────────┬──────────────┤
│ 📁   │                                       │ 🤖 Claude    │  ← Claude Code panel
│ 🔍   │   YOUR FILES                          │   Code       │     (right sidebar)
│ 📋   │   (open a folder, edit a file here)   │              │
│ ▶    │                                       │  Chat here ↓ │
│ ⬇    │                                       │              │
│      │                                       │  [text box]  │
└──────┴──────────────────────────────────────┴──────────────┘
   ↑                                                 ↑
   Activity Bar                                Type prompts
   (mode icons)                                or @agent-name

           ┌──────────────────────────────────────┐
           │  Terminal (bottom panel)             │  ← Ctrl/Cmd+`
           │  $ run shell commands here           │     toggle
           └──────────────────────────────────────┘
```

### What each part does

**1. Activity Bar (far left, icons)** — switches between modes:
- 📁 Explorer (your files)
- 🔍 Search (find text)
- 📋 Source Control (git)
- ▶ Run & Debug
- ⬇ Extensions (add features)

**2. Editor (middle)** — where files open. Click any file in Explorer to read or edit it.

**3. Claude Code panel (right side)** — your AI chat. Type here to give Claude instructions. This is where vibe-coding happens.

**4. Terminal (bottom panel)** — for shell commands. Open with `Ctrl + ` (backtick), or Cmd+` on Mac.

## Your first vibe-coded project — a landing page

Let's build something real.

### Step 1 — Open Claude Code

In VS Code, look at the right side. If you don't see Claude Code, press `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows), type "Claude Code", and pick "Claude Code: Open Panel".

### Step 2 — Type your first command

In the Claude Code text box at the bottom of the panel, type:

```
Create a simple HTML landing page for a fictional product called 
"PlantPal" — an app that reminds you to water your houseplants. 
The page should have a hero section with a catchy headline, 
3 feature bullets, and a sign-up email form. Use modern CSS, 
plant-themed green colors, and a friendly font. Save it as 
plantpal.html in this folder.
```

Press Enter (or click the send button).

### Step 3 — Watch it build

Claude will:
1. Think for a moment
2. Create the file `plantpal.html`
3. Write all the HTML and CSS
4. Show you what it did

### Step 4 — See the result

Open the file Claude just created:
1. In the Explorer (left), find `plantpal.html`
2. Right-click → "Open with Live Server" (or just double-click)
3. Your browser opens the page

That's vibe-coding. You described a thing in English, and Claude wrote the code.

## Patterns that work well

### Be specific about what you want

**Vague** → mediocre output:
> "Make me a website"

**Specific** → great output:
> "Make me a single-page portfolio site for a freelance writer. 
> Sections: hero with name and tagline, about (3 paragraphs), 
> services (3 cards), contact form. Dark theme. Use Inter font. 
> Save as index.html."

### Iterate, don't restart

After the first version, refine:
> "Change the colors to a warmer palette. Make the headline bigger. 
> Add a 'Recent work' section between Services and Contact."

Claude edits the existing file. Run again, refresh browser.

### Ask Claude to explain

If you don't understand the code:
> "Explain in plain English what lines 10-30 do."

Claude tutors you while building.

### When stuck, ask for help

> "The form doesn't submit. Help me figure out why."

Claude debugs.

## Working with your corporation

Your AI agents can vibe-code too. Examples:

```
@engineering-frontend-developer Build me a React component 
for a todo list with drag-and-drop reorder. Use react-dnd. 
Save in src/components/TodoList.jsx.
```

```
@engineering-backend-architect Design a REST API for an event 
ticketing system. List the endpoints, the data models, and 
write the FastAPI starter code.
```

```
@engineering-rapid-prototyper Quick prototype: a chrome extension 
that highlights all dollar amounts on a webpage. Just the basics, 
no polish, runnable today.
```

The specialist agent applies their expertise + Rule 1 (search GitHub for existing packages first).

## Common beginner mistakes

### ❌ "Build me an app"

Too vague. Claude has no idea what kind, what tech, what features. Result: random output.

### ❌ "Make this work" (no context)

Without knowing what "this" is and what "work" means, Claude guesses.

### ❌ Copy-pasting errors without explanation

If you get an error, paste the **full error message** plus what you tried.

### ❌ Giving up after one bad attempt

The first version is rarely the final version. Iterate.

## What this is NOT

- **Not magic** — Claude makes mistakes. Review the code.
- **Not a free pass to ignore basics** — you'll progress faster if you learn what HTML, CSS, JavaScript, Python actually are.
- **Not a license to ship without testing** — always run the thing before deploying.
- **Not for safety-critical software** — don't vibe-code medical devices or nuclear control systems.

For low-stakes tools, internal automation, personal websites, prototypes, learning projects — vibe-coding is fantastic.

## Where to go next

- `docs/06-corporate-os/README.md` — open the visual office to see your team
- `docs/04-business-discovery/README.md` — let the CEO find what you should build
- `docs/faq/troubleshooting.md` — if Claude Code isn't responding

Build something today. The corporation is rooting for you.
