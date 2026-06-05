"""Post-install welcome banner shown to the customer.

Prints a friendly summary of what was installed and how to start.
Called at end of install.ps1 / install.sh.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

LICENSE_FILE = Path.home() / ".corpify" / "license.json"


def main():
    tier = "standard"
    email = "you"
    if LICENSE_FILE.exists():
        try:
            data = json.loads(LICENSE_FILE.read_text(encoding="utf-8"))
            tier = data.get("tier", "standard")
            email = data.get("customer_email", "you")
        except Exception:
            pass

    print()
    print("=" * 60)
    print(" Welcome to Corpify")
    print("=" * 60)
    print(f" Tier: {tier.upper()}")
    print(f" Activated for: {email}")
    print()
    print(" Your corporation is installed at: ~/corpify/")
    print()
    print(" Folder tour:")
    print("   .claude/agents/    — your AI team (open any .md to read the role)")
    print("   .claude/commands/  — workflow shortcuts (/gstack-ship etc.)")
    print("   docs/04-..09       — guides for each part of the corporation")
    print("   docs/faq/          — installation help, refunds, common questions")
    if tier == "pro":
        print("   docs/11-voice-control/  — Voice Control setup (Pro)")
    print()
    print(" First step:")
    print("   1. VS Code should have opened with your corpify folder.")
    print("   2. Open the Claude Code panel (sidebar).")
    print("   3. Type: @corp-ceo Hello, I am ready to start")
    print("   4. CEO will introduce the team and get to know you.")
    print()
    print(" Anthropic API key needed:")
    print("   Get one at https://console.anthropic.com  (~$20-50/month typical)")
    print("   Many qualify for free startup credits — see docs/10-ai-credits/")
    print()
    print(" Support: support@corpify.tech")
    print("=" * 60)


if __name__ == "__main__":
    sys.exit(main() or 0)
