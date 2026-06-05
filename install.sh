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

# ---- License key prompt --------------------------------------------------
echo "License key required (you received it by email after purchase)."
echo "Format: XXXXXXXX-XXXXXXXX-XXXXXXXX-XXXXXXXX"
echo ""
read -r -p "Paste your license key: " LICENSE_KEY

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

# Tier mapping
PRODUCT_ID=$(echo "$RESPONSE" | grep -o '"product_id":[0-9]*' | head -1 | cut -d':' -f2)
TIER="standard"
if [ "$PRODUCT_ID" = "1112833" ]; then
    TIER="pro"
fi

CUSTOMER_EMAIL=$(echo "$RESPONSE" | grep -o '"customer_email":"[^"]*"' | head -1 | cut -d'"' -f4)
INSTANCE_ID=$(echo "$RESPONSE" | grep -o '"instance":{"id":"[^"]*"' | head -1 | cut -d'"' -f4)

echo ""
echo "License valid! Tier: ${TIER^^}"
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
    for pkg in git node python; do
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
        for pkg in git nodejs python3 npm; do
            command -v "$pkg" &> /dev/null || sudo apt-get install -y "$pkg"
        done
    elif command -v dnf &> /dev/null; then
        for pkg in git nodejs python3 npm; do
            command -v "$pkg" &> /dev/null || sudo dnf install -y "$pkg"
        done
    fi
fi

# Claude Code
if ! command -v claude &> /dev/null; then
    echo "  Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code 2>/dev/null || sudo npm install -g @anthropic-ai/claude-code
else
    echo "  [OK] Claude Code"
fi

# ---- Download Corpify content --------------------------------------------
echo ""
echo "Downloading Corpify content..."

INSTALL_DIR="$HOME/corpify"
if [ -d "$INSTALL_DIR" ]; then
    echo "  Existing installation at $INSTALL_DIR"
    read -r -p "  Overwrite? (yes/no): " CONFIRM
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

python3 "$INSTALL_DIR/lib/tier_gate.py" --tier "$TIER" --install-dir "$INSTALL_DIR"

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
echo "  1. In VS Code, open the Claude Code panel (sidebar)"
echo "  2. Type: @corp-ceo Hello, I am ready to start"
echo "  3. CEO will introduce the corporation and ask about you"
echo ""
echo "Need help? See ~/corpify/docs/faq/"
echo "Support: support@corpify.tech"
echo ""
