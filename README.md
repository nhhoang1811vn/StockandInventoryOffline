# update cubit
dart run build_runner build --delete-conflicting-outputs
# build aab
flutter build appbundle

# Translation 
1. Fetch the latest data from this
https://docs.google.com/spreadsheets/d/1e6FtEcq8TSWMolzjUaGiAwJikFGyQgrEAtFawK5Rio4/edit?gid=0#gid=0
Download the file and override it to lib/l10n/translation.xlsx
2. Execute python scripts
   cd lib/l10n/ 
python generate_arb_from_sheet.py

3. cd to project root **flutter gen-l10n**