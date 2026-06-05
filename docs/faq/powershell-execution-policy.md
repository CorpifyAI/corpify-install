# PowerShell Execution Policy

If you see `Running scripts is disabled on this system` or `cannot be loaded because running scripts is disabled` — Windows is protecting you. We need to grant your user account permission to run signed scripts.

## Safe one-liner (recommended)

Open PowerShell normally (not as Admin) and run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

You'll be asked to confirm — type `Y` and Enter.

This affects ONLY your user account, not the whole system. It allows scripts you wrote locally and scripts downloaded from trusted sources to run, but still blocks unsigned dangerous scripts.

After this, re-run the Corpify installer:

```powershell
irm https://corpify.tech/install.ps1 | iex
```

## What just happened

Windows PowerShell has 5 levels:

| Level | Meaning |
|-------|---------|
| `Restricted` | Default — no scripts allowed |
| `AllSigned` | Only signed scripts |
| `RemoteSigned` | Local scripts fine, remote must be signed |
| `Unrestricted` | All scripts (warns on remote) |
| `Bypass` | All scripts, no warnings |

`RemoteSigned` is the practical middle ground for everyday users. Most professional Windows users have this set.

## Reverting

If you want to set it back later:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
```

## Why doesn't the installer auto-fix this?

Because changing the execution policy requires a script to run — which is what's blocked in the first place. You have to do it manually once.

After this one-time fix, all future Corpify operations work without prompts.
