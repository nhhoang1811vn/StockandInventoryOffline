import json
from googletrans import Translator

# Load English ARB file
with open("app_en.arb", "r", encoding="utf-8") as f:
    source = json.load(f)

# Separate content and metadata
content = {k: v for k, v in source.items() if not k.startswith("@")}
meta = {k: v for k, v in source.items() if k.startswith("@")}

# List of target languages
languages = ["es", "fr", "de", "vi", "id"]  # Add more if needed

translator = Translator()

for lang in languages:
    print(f"Translating to: {lang}")
    translated = {}
    for key, value in content.items():
        try:
            translated_text = translator.translate(value, src='en', dest=lang).text
            translated[key] = translated_text
        except Exception as e:
            print(f"Error translating '{key}': {e}")
            translated[key] = value  # fallback

    # Add metadata
    translated.update(meta)

    # Save to new ARB file
    out_file = f"app_{lang}.arb"
    with open(out_file, "w", encoding="utf-8") as f_out:
        json.dump(translated, f_out, ensure_ascii=False, indent=2)

    print(f"✅ Saved: {out_file}")
