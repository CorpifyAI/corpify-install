"""Copy correct agent subset to user's installation based on tier.

Standard: 50 agents (all corp-*, meeting/management/debate, base engineering, base testing)
Pro:      62 agents (Standard + 12 Pro-only agents) + Voice Control flag

Reads tier JSON files to determine which agents to keep.
"""
from __future__ import annotations

import argparse
import json
import shutil
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--tier", required=True, choices=["standard", "pro"])
    parser.add_argument("--install-dir", required=True)
    args = parser.parse_args()

    install = Path(args.install_dir).resolve()
    tier_file = install / "tiers" / f"{args.tier}.json"
    if not tier_file.exists():
        print(f"ERROR: tier file not found: {tier_file}", file=sys.stderr)
        sys.exit(1)

    config = json.loads(tier_file.read_text(encoding="utf-8"))
    allowed = set(config.get("agents", []))
    voice_enabled = bool(config.get("voice_control", False))

    agents_dir = install / ".claude" / "agents"
    if not agents_dir.exists():
        print(f"ERROR: agents dir not found: {agents_dir}", file=sys.stderr)
        sys.exit(1)

    removed = 0
    kept = 0
    for agent in agents_dir.glob("*.md"):
        name = agent.stem
        if name in allowed:
            kept += 1
        else:
            agent.unlink()
            removed += 1

    print(f"[tier_gate] Tier: {args.tier}")
    print(f"[tier_gate] Kept {kept} agents, removed {removed}")

    if args.tier == "pro" and not voice_enabled:
        print("[tier_gate] WARNING: Pro tier without voice_control flag")

    # Write small marker file so other tools can introspect tier
    marker = install / ".corpify-tier"
    marker.write_text(args.tier, encoding="utf-8")


if __name__ == "__main__":
    main()
