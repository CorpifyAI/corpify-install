"""LemonSqueezy license validation and local activation persistence."""
from __future__ import annotations

import json
import os
import time
import urllib.parse
import urllib.request
from dataclasses import dataclass
from pathlib import Path

LS_API = "https://api.lemonsqueezy.com/v1/licenses"
TIER_MAP = {
    1112829: "standard",
    1112833: "pro",
}
LICENSE_FILE = Path.home() / ".corpify" / "license.json"


class LicenseError(Exception):
    pass


@dataclass
class License:
    key: str
    tier: str
    product_id: int
    instance_id: str
    customer_email: str
    activated_at: str

    def to_dict(self) -> dict:
        return {
            "key": self.key,
            "tier": self.tier,
            "product_id": self.product_id,
            "instance_id": self.instance_id,
            "customer_email": self.customer_email,
            "activated_at": self.activated_at,
        }


def _post_form(url: str, data: dict, timeout: int = 15) -> dict:
    body = urllib.parse.urlencode(data).encode()
    req = urllib.request.Request(url, data=body, method="POST")
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return json.loads(r.read().decode())


def validate_license(key: str) -> License:
    """Validate license against LemonSqueezy. Raises LicenseError on failure."""
    if not key or len(key) < 16:
        raise LicenseError("License key looks too short. Check your email for the correct key.")
    try:
        data = _post_form(f"{LS_API}/validate", {"license_key": key})
    except urllib.error.HTTPError as e:
        body = e.read().decode(errors="replace")
        raise LicenseError(f"License server returned HTTP {e.code}: {body[:200]}") from e
    except Exception as e:
        raise LicenseError(f"Cannot reach license server: {e}") from e

    if not data.get("valid"):
        raise LicenseError(data.get("error") or "License invalid")

    meta = data.get("meta", {})
    instance = data.get("instance") or {}
    product_id = int(meta.get("product_id") or 0)
    tier = TIER_MAP.get(product_id, "standard")
    return License(
        key=key,
        tier=tier,
        product_id=product_id,
        instance_id=str(instance.get("id") or ""),
        customer_email=str(meta.get("customer_email") or ""),
        activated_at=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    )


def save_license(lic: License) -> Path:
    LICENSE_FILE.parent.mkdir(parents=True, exist_ok=True)
    LICENSE_FILE.write_text(json.dumps(lic.to_dict(), indent=2), encoding="utf-8")
    return LICENSE_FILE


def load_license() -> License | None:
    if not LICENSE_FILE.exists():
        return None
    try:
        data = json.loads(LICENSE_FILE.read_text(encoding="utf-8"))
        return License(**data)
    except Exception:
        return None


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--key", required=True)
    args = parser.parse_args()
    try:
        lic = validate_license(args.key)
        save_license(lic)
        print(json.dumps({"ok": True, "tier": lic.tier, "email": lic.customer_email}))
    except LicenseError as e:
        print(json.dumps({"ok": False, "error": str(e)}))
        raise SystemExit(1)
