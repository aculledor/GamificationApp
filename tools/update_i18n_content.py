#!/usr/bin/env python3
import json
from pathlib import Path

# === CONFIG ===
CONTENT_PATH = Path("assets/content/modules.json")
I18N_DIR = Path("assets/i18n_content/")
LANGS = ["en", "es", "it", "el", "tr", "fr", "pt"]  # idiomas que manejas
OUT_INDENT = 2

# === Load main content structure ===
print(f"📘 Loading {CONTENT_PATH} ...")
with open(CONTENT_PATH, encoding="utf-8") as f:
    content = json.load(f)

keys = set()

# --- extract keys from modules.json ---
for topic in content.get("topics", []):
    if "titleKey" in topic:
        keys.add(topic["titleKey"])

for q in content.get("questions", []):
    if "textKey" in q:
        keys.add(q["textKey"])
    for ans in q.get("answers", []):
        if "textKey" in ans:
            keys.add(ans["textKey"])
    for ft in q.get("correctFreeText", []) or []:
        keys.add(ft)

print(f"✅ Found {len(keys)} unique keys to ensure in translations.\n")

# === Ensure each language file exists and contains all keys ===
I18N_DIR.mkdir(parents=True, exist_ok=True)
for lang in LANGS:
    file_path = I18N_DIR / f"questions_{lang}.json"

    # Load existing file or start new one
    if file_path.exists():
        with open(file_path, encoding="utf-8") as f:
            data = json.load(f)
    else:
        print(f"🆕 Creating new translation file for '{lang}'")
        data = {}

    # Add missing keys
    added = 0
    for k in sorted(keys):
        if k not in data:
            data[k] = ""
            added += 1

    # Save back
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=OUT_INDENT)

    print(f"🌍 {lang}: added {added} new keys → {file_path.name}")

print("\n✨ Sync complete! You can now fill in the missing translations.")
