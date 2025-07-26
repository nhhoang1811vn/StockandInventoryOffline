import json

with open("app_en.arb", "r", encoding="utf-8") as f:
    data = json.load(f)

keys = [k for k in data.keys() if not k.startswith("@")]

# Print keys
for key in keys:
    print(key)
