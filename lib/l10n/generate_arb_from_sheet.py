import pandas as pd
import json

def generate_arb_files(sheet_path):
    # Read Excel sheet
    df = pd.read_excel(sheet_path, engine="openpyxl")

    # First column = keys, rest = languages
    keys = df.iloc[:, 0]
    languages = df.columns[1:]

    for lang in languages:
        if lang == "en":
            continue  # Skip English

        arb_data = {}
        for i in range(len(df)):
            key = keys[i]
            value = df.at[i, lang]
            if pd.notna(value):
                arb_data[key] = value

        filename = f"app_{lang}.arb"
        with open(filename, "w", encoding="utf-8") as f:
            json.dump(arb_data, f, ensure_ascii=False, indent=2)

        print(f"✅ Generated: {filename}")

# === Usage ===
generate_arb_files("translation.xlsx")  # Replace with your file
