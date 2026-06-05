#!/usr/bin/env bash
# Whispering Voice Control installer for Corpify Pro tier (Mac / Linux)
# Whispering is open-source (MIT) by EpicenterHQ:
#   https://github.com/EpicenterHQ/epicenter

set -e

echo ""
echo "Installing Whispering (Voice Control)..."
echo "Source: https://github.com/EpicenterHQ/epicenter (MIT license)"
echo ""

OS="$(uname -s)"
RELEASES_API="https://api.github.com/repos/EpicenterHQ/epicenter/releases/latest"

# macOS: prefer Homebrew Cask if available
if [ "$OS" = "Darwin" ]; then
    if command -v brew &> /dev/null; then
        echo "Trying Homebrew cask install..."
        if brew install --cask whispering 2>/dev/null; then
            echo "[OK] Whispering installed via Homebrew"
        else
            echo "Homebrew cask not available — falling back to GitHub download"
            ASSET_PATTERN="\\.dmg"
        fi
    else
        ASSET_PATTERN="\\.dmg"
    fi
else
    # Linux: prefer AppImage
    ASSET_PATTERN="\\.AppImage"
fi

# GitHub release fallback
if [ -n "${ASSET_PATTERN:-}" ]; then
    echo "Downloading latest Whispering release from GitHub..."
    JSON=$(curl -sL --max-time 20 "$RELEASES_API")
    URL=$(echo "$JSON" | grep -oE 'https://[^"]+' | grep -E "$ASSET_PATTERN" | head -1)

    if [ -z "$URL" ]; then
        echo "Could not find matching asset in latest release."
        echo "Please install manually:"
        echo "  https://github.com/EpicenterHQ/epicenter/releases"
    else
        FILENAME=$(basename "$URL")
        TMP="/tmp/$FILENAME"
        echo "  Downloading $FILENAME..."
        curl -L --max-time 600 -o "$TMP" "$URL"

        if [ "$OS" = "Darwin" ] && [[ "$FILENAME" == *.dmg ]]; then
            echo "  Mounting DMG and copying to /Applications..."
            MOUNT_POINT=$(hdiutil attach "$TMP" -nobrowse | grep -oE '/Volumes/[^ ]+' | head -1)
            cp -R "$MOUNT_POINT"/*.app /Applications/ 2>/dev/null || true
            hdiutil detach "$MOUNT_POINT" -quiet
            echo "[OK] Whispering installed to /Applications/"
        elif [[ "$FILENAME" == *.AppImage ]]; then
            mkdir -p "$HOME/.local/bin"
            mv "$TMP" "$HOME/.local/bin/whispering"
            chmod +x "$HOME/.local/bin/whispering"
            echo "[OK] Whispering installed to ~/.local/bin/whispering"
        fi
    fi
fi

echo ""
echo "Next steps for you:"
echo "  1. Open Whispering"
echo "  2. Settings → choose Whisper.cpp (local) as transcription provider"
echo "  3. Settings → set your push-to-talk hotkey"
echo "  4. Grant microphone permission when prompted"
echo "  5. Test: hold the hotkey, speak, release — text appears at cursor"
echo ""
echo "Full guide: ~/corpify/docs/11-voice-control/"
