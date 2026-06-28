#!/usr/bin/env bash
# Corpify Uninstaller for Mac / Linux
# Run with:  curl -s https://corpify.tech/uninstall.sh | bash
# Preview (no changes):  bash uninstall.sh --dry-run
#
# Mirrors install.sh. Idempotent: safe to run on a partial/broken install.
# Homebrew itself is NEVER removed.

DRY_RUN=0
[ "$1" = "--dry-run" ] && DRY_RUN=1

REPORT=()
add_report() { REPORT+=("$1"); }

confirm() {
    local ans
    read -r -p "$1 (y/n) " ans < /dev/tty
    case "$(printf '%s' "$ans" | tr '[:upper:]' '[:lower:]')" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

# Idempotent delete: missing path -> note and continue, never fail.
remove_if_exists() {
    local path="$1" label="$2"
    if [ -e "$path" ]; then
        if [ "$DRY_RUN" = "1" ]; then
            add_report "[would remove] $label"
        elif rm -rf "$path" 2>/dev/null; then
            add_report "[removed] $label"
        else
            add_report "[ERROR] could not remove $label"
        fi
    else
        add_report "[not found] $label"
    fi
}

# Run a command safely; never abort the script.
run_safe() {
    if [ "$DRY_RUN" = "1" ]; then add_report "[would run] $2"; return; fi
    if eval "$1" >/dev/null 2>&1; then add_report "[done] $2"; else add_report "[ERROR] $2"; fi
}

# ---- Banner --------------------------------------------------------------
echo ""
echo "========================================"
echo "  CORPIFY - Uninstaller"
[ "$DRY_RUN" = "1" ] && echo "  (DRY RUN - nothing will be changed)"
echo "========================================"
echo ""

# ---- Consent -------------------------------------------------------------
echo "This will remove Corpify from your computer:"
echo "  - Your corporation folder (~/corpify) and license (~/.corpify)"
echo "  - Optionally: deactivate your license, and remove third-party tools"
echo "    (Git, Node, VS Code, Claude Code) - you will be asked for each one."
echo ""
echo "It will NOT remove Homebrew or anything not installed by Corpify."
echo "Your corporation's memory can be backed up first (you will be asked)."
echo ""
read -r -p "Type 'remove' to continue, or anything else to cancel: " CONSENT < /dev/tty
if [ "$(printf '%s' "$CONSENT" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')" != "remove" ]; then
    echo ""; echo "Cancelled. Nothing was changed on your computer."; exit 0
fi
echo ""

# ---- Read license info (if present) --------------------------------------
LIC="$HOME/.corpify/license.json"
LIC_KEY=""; LIC_INSTANCE=""; LIC_EMAIL=""
if [ -f "$LIC" ]; then
    LIC_KEY=$(grep -o '"key":[[:space:]]*"[^"]*"' "$LIC" | head -1 | cut -d'"' -f4)
    LIC_INSTANCE=$(grep -o '"instance_id":[[:space:]]*"[^"]*"' "$LIC" | head -1 | cut -d'"' -f4)
    LIC_EMAIL=$(grep -o '"customer_email":[[:space:]]*"[^"]*"' "$LIC" | head -1 | cut -d'"' -f4)
    echo "Found license for: $LIC_EMAIL"
else
    echo "No license file found - skipping license deactivation."
fi
echo ""

# ---- License deactivation ------------------------------------------------
# Only possible if the install created an activation instance. Current installer
# uses /validate (no instance), so instance_id is usually empty/null.
if [ -n "$LIC_KEY" ]; then
    if [ -z "$LIC_INSTANCE" ] || [ "$LIC_INSTANCE" = "null" ]; then
        add_report "[note] license has no activation instance (nothing to deactivate)"
    elif confirm "Release the license so you can install on another computer?"; then
        if [ "$DRY_RUN" = "1" ]; then
            add_report "[would deactivate] license on LemonSqueezy"
        elif curl -s -X POST "https://api.lemonsqueezy.com/v1/licenses/deactivate" \
                -d "license_key=$LIC_KEY" -d "instance_id=$LIC_INSTANCE" --max-time 15 \
                | grep -q '"deactivated":true'; then
            add_report "[done] license deactivated (activation slot freed)"
        else
            add_report "[note] could not deactivate (offline?) - release later at corpify.tech or email support@corpify.tech"
        fi
    else
        add_report "[kept] license activation (not released)"
    fi
fi

# ---- Data protection: offer memory backup --------------------------------
MEM="$HOME/corpify/.claude/memory"
if [ -d "$MEM" ]; then
    echo "Your corporation's memory holds its accumulated work (agent memory, projects)."
    if confirm "Back up the memory before deleting?"; then
        BK="$HOME/corpify-memory-backup-$(date +%F)"
        if [ "$DRY_RUN" = "1" ]; then
            add_report "[would back up] memory -> $BK"
        elif cp -R "$MEM" "$BK" 2>/dev/null; then
            add_report "[backed up] memory -> $BK"
        else
            add_report "[ERROR] memory backup failed"
        fi
    fi
fi

# ---- Remove Corpify files (explicit confirmation; always-remove tier) -----
if [ "$DRY_RUN" = "1" ] || confirm "Delete your Corpify corporation and all its data?"; then
    remove_if_exists "$HOME/corpify" "corporation folder (~/corpify)"
    remove_if_exists "$HOME/.corpify" "license folder (~/.corpify)"
    remove_if_exists "$HOME/Desktop/Open Corpify.command" "desktop launcher (Open Corpify)"
else
    add_report "[kept] Corpify files (deletion declined)"
fi

# ---- Optional: third-party tools (ask per item; default keep) ------------
echo ""
echo "Corpify installed these only if they were missing. They are useful on"
echo "their own - keep them unless you are sure you want them gone."
echo ""

# Claude Code CLI (npm global)
if command -v claude >/dev/null 2>&1; then
    if confirm "Remove Claude Code CLI (npm global)?"; then
        run_safe "npm uninstall -g @anthropic-ai/claude-code" "remove Claude Code CLI"
    else add_report "[kept] Claude Code CLI"; fi
fi

# Claude Code VS Code extension (on Mac/Linux 'code' is the CLI)
if command -v code >/dev/null 2>&1; then
    if confirm "Remove the Claude Code VS Code extension?"; then
        run_safe "code --uninstall-extension anthropic.claude-code --force" "remove Claude Code extension"
    else add_report "[kept] Claude Code extension"; fi
fi

# Git / Node / VS Code (Mac via brew, Linux via apt/dnf). NEVER touch Homebrew.
OS="$(uname -s)"
if [ "$OS" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    if command -v git >/dev/null 2>&1; then
        if confirm "Remove Git (brew)?"; then run_safe "brew uninstall git" "remove Git"; else add_report "[kept] Git"; fi
    fi
    if command -v node >/dev/null 2>&1; then
        if confirm "Remove Node.js (brew)?"; then run_safe "brew uninstall node" "remove Node.js"; else add_report "[kept] Node.js"; fi
    fi
    if command -v code >/dev/null 2>&1; then
        if confirm "Remove Visual Studio Code (brew)?"; then run_safe "brew uninstall --cask visual-studio-code" "remove VS Code"; else add_report "[kept] VS Code"; fi
    fi
elif command -v apt-get >/dev/null 2>&1; then
    if command -v git >/dev/null 2>&1; then
        if confirm "Remove Git (apt)?"; then run_safe "sudo apt-get remove -y git" "remove Git"; else add_report "[kept] Git"; fi
    fi
    if command -v node >/dev/null 2>&1; then
        if confirm "Remove Node.js (apt)?"; then run_safe "sudo apt-get remove -y nodejs" "remove Node.js"; else add_report "[kept] Node.js"; fi
    fi
fi
# Homebrew itself is intentionally NEVER removed.

# Restore GitHub Copilot (the installer had removed it)
if command -v code >/dev/null 2>&1; then
    if confirm "Restore GitHub Copilot that the installer removed?"; then
        run_safe "code --install-extension github.copilot --force" "restore GitHub Copilot"
        run_safe "code --install-extension github.copilot-chat --force" "restore GitHub Copilot Chat"
    fi
fi

# ---- Report --------------------------------------------------------------
echo ""
echo "=== Uninstall report ==="
for line in "${REPORT[@]}"; do echo "  $line"; done
echo ""
if [ "$DRY_RUN" = "1" ]; then
    echo "Dry run complete - no changes were made."
else
    echo "Corpify has been uninstalled. Thank you."
fi
echo ""
