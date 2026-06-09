#!/usr/bin/env bash
# Copy correct agent subset to user's installation based on tier.
#
# Standard: ~40 agents.  Pro: ~52 agents + Voice Control flag.
#
# Bash-native — no Python dependency, runs on every fresh macOS / Linux.

set -euo pipefail

TIER=""
INSTALL_DIR=""
while [ $# -gt 0 ]; do
    case "$1" in
        --tier)        TIER="${2:-}"; shift 2 ;;
        --install-dir) INSTALL_DIR="${2:-}"; shift 2 ;;
        *) echo "[tier_gate] unknown argument: $1" >&2; exit 1 ;;
    esac
done

if [ "$TIER" != "standard" ] && [ "$TIER" != "pro" ]; then
    echo "[tier_gate] invalid tier: '$TIER' (expected standard|pro)" >&2
    exit 1
fi

TIER_FILE="$INSTALL_DIR/tiers/$TIER.json"
AGENTS_DIR="$INSTALL_DIR/.claude/agents"

[ -f "$TIER_FILE" ]  || { echo "[tier_gate] tier file not found: $TIER_FILE" >&2; exit 1; }
[ -d "$AGENTS_DIR" ] || { echo "[tier_gate] agents dir not found: $AGENTS_DIR" >&2; exit 1; }

# Extract the allowed agent names from the JSON "agents": [ ... ] array.
# Pure awk/grep — no jq or python required.
ALLOWED="$(awk '/"agents"[[:space:]]*:[[:space:]]*\[/{f=1; next} /\]/{f=0} f' "$TIER_FILE" \
            | grep -oE '"[^"]+"' | tr -d '"')"

if [ -z "$ALLOWED" ]; then
    echo "[tier_gate] could not parse agent list from $TIER_FILE" >&2
    exit 1
fi

kept=0
removed=0
for f in "$AGENTS_DIR"/*.md; do
    [ -e "$f" ] || continue
    base="$(basename "$f" .md)"
    if printf '%s\n' "$ALLOWED" | grep -qxF "$base"; then
        kept=$((kept + 1))
    else
        rm -f "$f"
        removed=$((removed + 1))
    fi
done

echo "[tier_gate] Tier: $TIER"
echo "[tier_gate] Kept $kept agents, removed $removed"

VOICE="$(grep -oE '"voice_control"[[:space:]]*:[[:space:]]*(true|false)' "$TIER_FILE" \
          | grep -oE '(true|false)$' || true)"
if [ "$TIER" = "pro" ] && [ "$VOICE" != "true" ]; then
    echo "[tier_gate] WARNING: Pro tier without voice_control flag in tier JSON" >&2
fi

# Marker file other tools can introspect
printf '%s' "$TIER" > "$INSTALL_DIR/.corpify-tier"
