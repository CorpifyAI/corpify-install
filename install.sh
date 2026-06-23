#!/usr/bin/env bash
# Corpify Installer for Mac / Linux
# Run with: curl -s https://corpify.tech/install.sh | bash

set -e

echo ""
echo "========================================"
echo "  CORPIFY - AI Corporation Installer"
echo "========================================"
echo ""
echo "Welcome. This will install your AI Corporation."
echo "Estimated time: 5-10 minutes."
echo ""

# ---- Consent screen (legal + transparency) -------------------------------
echo "Before we begin, please review what this installer will do on"
echo "your computer:"
echo ""
echo "1. INSTALL THIRD-PARTY SOFTWARE (only if not already present),"
echo "   via your system package manager (Homebrew on macOS, apt/dnf on"
echo "   Linux) and npm:"
echo "     - Git                              (license: GPL v2)"
echo "     - Node.js                          (license: MIT)"
echo "     - Visual Studio Code               (license: MIT)"
echo "     - Claude Code CLI by Anthropic     (license: Anthropic Terms)"
echo "     - Claude Code VS Code extension    (license: Anthropic Terms)"
echo "     - Whispering by EpicenterHQ        (license: MIT) -- Pro only"
echo "   Each program installs under its own vendor license."
echo "   By proceeding you authorize these installations."
echo ""
echo "2. DOWNLOAD CORPIFY CONTENT:"
echo "     - Agent definitions and guides into ~/corpify/"
echo "     - License info into ~/.corpify/license.json"
echo ""
echo "3. STORE YOUR EMAIL LOCALLY:"
echo "   The email tied to your license is saved in"
echo "   ~/.corpify/license.json. This file stays on your computer."
echo "   It is sent only to LemonSqueezy for license validation."
echo ""
echo "4. WHAT WE DO NOT DO:"
echo "     - No kernel-level software"
echo "     - No auto-start / background services"
echo "     - No telemetry collection"
echo "     - No system-settings changes beyond what each installed"
echo "       program does on its own"
echo ""
echo "You can remove everything later by deleting ~/corpify/ and"
echo "~/.corpify/, and uninstalling the programs via your package manager."
echo ""
echo "Full terms: https://corpify.tech/legal/installation.html"
echo "Third-party licenses: see THIRD-PARTY-NOTICES.md in ~/corpify/"
echo ""
read -r -p "Type 'agree' to continue, or anything else to cancel: " CONSENT < /dev/tty
CONSENT_LC="$(printf '%s' "$CONSENT" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
if [ "$CONSENT_LC" != "agree" ]; then
    echo ""
    echo "Installation cancelled. Nothing was changed on your computer."
    exit 0
fi
echo ""

# ---- License key (taken from your install command; prompt only as fallback)
# Your personalized command sets CORPIFY_KEY so you never have to paste it.
LICENSE_KEY="$(printf '%s' "${CORPIFY_KEY:-}" | tr -d '[:space:]')"
if [ -n "$LICENSE_KEY" ] && [ ${#LICENSE_KEY} -ge 16 ]; then
    echo "License key detected from your install command."
else
    echo "License key required (you received it by email after purchase)."
    echo "Format: XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX"
    echo ""
    read -r -p "Paste your license key: " LICENSE_KEY < /dev/tty
    LICENSE_KEY="$(printf '%s' "$LICENSE_KEY" | tr -d '[:space:]')"
fi

if [ -z "$LICENSE_KEY" ] || [ ${#LICENSE_KEY} -lt 16 ]; then
    echo ""
    echo "ERROR: No license key entered."
    echo "Purchase at: https://corpify.tech"
    exit 1
fi

# ---- Validate via LemonSqueezy License API ------------------------------
echo ""
echo "Validating license..."

RESPONSE=$(curl -s -X POST "https://api.lemonsqueezy.com/v1/licenses/validate" \
    -d "license_key=$LICENSE_KEY" \
    --max-time 15) || {
    echo "ERROR contacting license server."
    echo "Check your internet connection and try again."
    exit 1
}

VALID=$(echo "$RESPONSE" | grep -o '"valid":[a-z]*' | head -1 | cut -d':' -f2)

if [ "$VALID" != "true" ]; then
    ERROR=$(echo "$RESPONSE" | grep -o '"error":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo ""
    echo "License invalid: $ERROR"
    echo "If you purchased recently, check your email for the correct key."
    echo "Support: support@corpify.tech"
    echo "Purchase: https://corpify.tech"
    exit 1
fi

# Tier from product name (robust across test/live), with product_id fallback
PRODUCT_NAME=$(echo "$RESPONSE" | grep -o '"product_name":"[^"]*"' | head -1 | cut -d'"' -f4)
VARIANT_NAME=$(echo "$RESPONSE" | grep -o '"variant_name":"[^"]*"' | head -1 | cut -d'"' -f4)
PRODUCT_ID=$(echo "$RESPONSE" | grep -o '"product_id":[0-9]*' | head -1 | cut -d':' -f2)
TIER="standard"
if echo "$PRODUCT_NAME $VARIANT_NAME" | grep -qi 'pro' || [ "$PRODUCT_ID" = "1112833" ]; then
    TIER="pro"
fi

CUSTOMER_EMAIL=$(echo "$RESPONSE" | grep -o '"customer_email":"[^"]*"' | head -1 | cut -d'"' -f4)
INSTANCE_ID=$(echo "$RESPONSE" | grep -o '"instance":{"id":"[^"]*"' | head -1 | cut -d'"' -f4)

echo ""
echo "License valid! Tier: $(echo "$TIER" | tr 'a-z' 'A-Z')"
echo "Activated for: $CUSTOMER_EMAIL"
echo ""

# ---- Save license info locally -------------------------------------------
CORPIFY_DIR="$HOME/.corpify"
mkdir -p "$CORPIFY_DIR"

cat > "$CORPIFY_DIR/license.json" <<EOF
{
  "key": "$LICENSE_KEY",
  "tier": "$TIER",
  "product_id": $PRODUCT_ID,
  "instance_id": "$INSTANCE_ID",
  "customer_email": "$CUSTOMER_EMAIL",
  "activated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

# ---- Prerequisites check -------------------------------------------------
echo "Checking prerequisites..."

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
    # macOS — use Homebrew
    if ! command -v brew &> /dev/null; then
        echo "  Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    for pkg in git node; do
        if ! command -v "$pkg" &> /dev/null; then
            echo "  Installing $pkg..."
            brew install "$pkg" || true
        else
            echo "  [OK] $pkg"
        fi
    done
    if ! command -v code &> /dev/null; then
        echo "  Installing VS Code..."
        brew install --cask visual-studio-code || true
    else
        echo "  [OK] VS Code"
    fi
else
    # Linux — apt or dnf
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq
        for pkg in git nodejs npm; do
            command -v "$pkg" &> /dev/null || sudo apt-get install -y "$pkg"
        done
    elif command -v dnf &> /dev/null; then
        for pkg in git nodejs npm; do
            command -v "$pkg" &> /dev/null || sudo dnf install -y "$pkg"
        done
    fi
fi

# Claude Code CLI (terminal)
if ! command -v claude &> /dev/null; then
    echo "  Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code 2>/dev/null || sudo npm install -g @anthropic-ai/claude-code
else
    echo "  [OK] Claude Code CLI"
fi

# Claude Code VS Code extension (UI panel)
echo "  Installing Claude Code VS Code extension..."
code --install-extension anthropic.claude-code --force &> /dev/null || true
echo "  [OK] Claude Code VS Code extension"

# ---- Download Corpify content --------------------------------------------
echo ""
echo "Downloading Corpify content..."

INSTALL_DIR="$HOME/corpify"
if [ -d "$INSTALL_DIR" ]; then
    echo "  Existing installation at $INSTALL_DIR"
    read -r -p "  Overwrite? (yes/no): " CONFIRM < /dev/tty
    if [ "$CONFIRM" != "yes" ]; then
        echo "Cancelled."
        exit 0
    fi
    rm -rf "$INSTALL_DIR"
fi

git clone --depth 1 https://github.com/CorpifyAI/corpify-install.git "$INSTALL_DIR" 2>&1 | grep -v "^$" || true
if [ ! -d "$INSTALL_DIR" ]; then
    echo "  Download failed."
    exit 1
fi
echo "  [OK] Downloaded to $INSTALL_DIR"

# ---- Tier gating ---------------------------------------------------------
echo ""
echo "Configuring for $TIER tier..."

bash "$INSTALL_DIR/lib/tier_gate.sh" --tier "$TIER" --install-dir "$INSTALL_DIR"

# ---- Pro: Voice Control --------------------------------------------------
if [ "$TIER" = "pro" ]; then
    echo ""
    echo "Installing Voice Control (Pro feature)..."
    bash "$INSTALL_DIR/voice/install-whispering.sh"
fi

# ---- Open VS Code --------------------------------------------------------
echo ""
echo "========================================"
echo "  Installation complete!"
echo "========================================"
echo ""
echo "Your AI Corporation is ready at: $INSTALL_DIR"
echo ""
echo "Opening VS Code with your corporation..."
sleep 2
code "$INSTALL_DIR" &> /dev/null &

echo ""
echo "Next steps:"
echo "  1. In VS Code, click the Claude icon on the left sidebar"
echo "  2. Sign in to Claude (browser will open, allow access)"
echo "  3. In the chat, type: hi"
echo "  4. The CEO will greet you and walk you through everything"
echo ""
echo "Need help? See ~/corpify/docs/faq/"
echo "Support: support@corpify.tech"
echo ""
