import json

with open("en-US.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# Filter only translatable values (ignore metadata like "@key")
values = [v for k, v in data.items() if not k.startswith("@")]

# Print values
for value in values:
    print(value)
