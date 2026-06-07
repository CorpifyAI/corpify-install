# Third-Party Notices

Corpify installs and/or relies on the third-party software listed below. Each
component is the property of its respective owner and is licensed under its own
terms. Corpify does not modify these components; it installs them through the
official Windows Package Manager (winget) or the npm registry, which apply each
vendor's own installation agreement.

By running the Corpify installer you agree to the license terms of each
component you choose to install.

| Component | Publisher | Purpose in Corpify | License | Source |
|-----------|-----------|--------------------|---------|--------|
| Git for Windows | Git / Software Freedom Conservancy | Download and update Corpify content | GPL-2.0 | https://gitforwindows.org |
| Node.js (LTS) | OpenJS Foundation | Run the Claude Code CLI | MIT | https://nodejs.org |
| Visual Studio Code | Microsoft | Editor / Corpify workspace UI | MIT | https://github.com/microsoft/vscode |
| Claude Code CLI (`@anthropic-ai/claude-code`) | Anthropic | The AI agent runtime | Anthropic Terms of Service | https://www.npmjs.com/package/@anthropic-ai/claude-code |
| Claude Code VS Code extension (`anthropic.claude-code`) | Anthropic | Chat panel inside VS Code | Anthropic Terms of Service | https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code |
| Whispering (Pro tier only) | EpicenterHQ | Hold-to-talk voice dictation | MIT | https://github.com/epicenter-md/epicenter |

## License terms

### Git for Windows — GPL-2.0
Git is distributed under the GNU General Public License version 2. Full text:
https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
Source: https://github.com/git-for-windows/git

### Node.js — MIT
Copyright Node.js contributors. Licensed under the MIT License.
Full text: https://github.com/nodejs/node/blob/main/LICENSE

### Visual Studio Code — MIT
Copyright (c) Microsoft Corporation. Licensed under the MIT License.
Full text: https://github.com/microsoft/vscode/blob/main/LICENSE.txt
Note: the binary Microsoft distributes from visualstudio.com is under the
Microsoft Software License; winget installs that official build. The MIT license
above covers the `vscode` source.

### Claude Code (CLI and VS Code extension) — Anthropic Terms
Claude Code and the Claude models it uses are provided by Anthropic under the
Anthropic Commercial Terms of Service and Usage Policies.
Terms: https://www.anthropic.com/legal/commercial-terms
Usage: requires the Owner's own Anthropic account or API key.

### Whispering — MIT (Pro tier only)
Copyright (c) EpicenterHQ. Licensed under the MIT License.
Full text: https://github.com/epicenter-md/epicenter/blob/main/LICENSE

## What Corpify itself provides

The Corpify content (agent definitions, guides, workflow commands, and installer
scripts) is the proprietary product you purchased. It is delivered from
https://github.com/CorpifyAI/corpify-install and governed by the Corpify terms
at https://corpify.tech/legal/.

## Removal

To remove the third-party software, use Windows "Apps & features". To remove
Corpify content, delete the `~/corpify/` and `~/.corpify/` folders.

---

_Last updated: 2026-06-07. Questions: support@corpify.tech_
