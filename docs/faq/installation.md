# Installation Issues

## Windows

### "irm : The remote name could not be resolved"

Your internet is offline or DNS is broken. Try `ping github.com` — if that fails, fix your connection first.

### "Running scripts is disabled on this system"

PowerShell blocks scripts by default. See [powershell-execution-policy.md](powershell-execution-policy.md).

### "winget is not recognized"

Older Windows 10 may not have winget. Update Windows via Settings → Update & Security, then re-run the installer. If still missing, install [App Installer from Microsoft Store](https://apps.microsoft.com/detail/9NBLGGH4NNS1).

### "Access denied" during install

Run PowerShell as Administrator (right-click PowerShell → Run as Administrator) and retry. Some packages need elevated permissions to install.

### Installer hangs at "Installing Node.js..."

winget downloads are slow on some networks. Be patient — first install may take 5-10 minutes per package. If truly stuck after 15 minutes, cancel (Ctrl+C) and re-run.

## Mac

### "Operation not permitted"

macOS may sandbox the installer. Open System Settings → Privacy & Security → grant Terminal full disk access. Retry.

### Homebrew install asks for password

This is normal — Homebrew uses `sudo` for initial setup. Enter your Mac login password.

### "command not found: code" after install

VS Code installed but the `code` shell command wasn't registered. Open VS Code → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH" → Enter.

### Apple Silicon / Intel mismatch

Whispering (Pro) ships separate binaries for Intel vs Apple Silicon. The installer auto-picks the right one. If you have issues, download manually from [GitHub releases](https://github.com/EpicenterHQ/epicenter/releases).

## Linux

### "sudo: command not found"

You're on a stripped-down container or root shell. Install sudo (`apt install sudo` as root) or run the installer as root directly.

### Different distro than Ubuntu / Fedora

The installer detects `apt-get` and `dnf`. For Arch / openSUSE / others, you may need to install prerequisites manually:
- `git`, `nodejs`, `npm`, `python3`, `code` (VS Code)
- Then re-run the installer — it will skip already-installed.

## All platforms

### "License invalid" but I just bought

Wait 30 seconds and retry — LemonSqueezy may need a moment to propagate. If still failing after 5 minutes, email support@corpify.tech with your order ID.

### Stops at "Configuring for standard tier..."

The Python script `lib/tier_gate.py` couldn't find your install dir. Make sure no other process is using `~/corpify`. Delete the folder and retry.

### "git clone failed"

GitHub had a hiccup, or your firewall blocks GitHub. Retry. If persistently broken, download the repo as a ZIP from https://github.com/CorpifyAI/corpify-install and extract to `~/corpify`, then re-run from the local copy.

### Started over a dozen times, nothing works

Email support@corpify.tech with:
- Your order ID
- Operating system (e.g. Windows 11, macOS 14.5)
- The exact error message
- Output of the failed step

We respond within 24 hours.
