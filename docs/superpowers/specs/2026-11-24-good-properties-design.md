# Good properties — design

Status: awaiting approval. Size: small-to-medium change (short design).

## Intent

Let each Store hide the Good properties it does not use (Image, Barcode, Description, Minimum
quantity), so forms, lists and reports are simpler for that Store. Entry points are placed where
more users will see them.

## Goals

- Per-Store toggles for 4 properties, default all ON (existing Stores keep today's behaviour).
- Menu "Good properties" in two places:
    1. Settings page (`lib/presentation/pages/settings/settings_page.dart`), next to the
       Minimum quantity item.
    2. Main menu page (`lib/presentation/pages/menu/menu_page.dart`), inside the "Settings" card,
       between "Settings" and "Subscription".
- Changing the selected Store switches to that Store's toggles automatically.

## Non-goals / anti-goals

- No deletion of stored values. Hidden = not shown, not erased; turning it back ON restores them.
- No schema change, no migration.
- Not fixing existing bugs or reworking the older Minimum quantity / goods-list display settings.
- Not adding settings to backup/restore (see Constraints).

## Decision: what "hidden" means (chosen by the user: option c)

A hidden property disappears everywhere it is displayed, not only the form.

| Property         | Hidden in                                                                                                                        |
|------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Image            | save-good form (avatar + images section), list row thumbnails/images                                                             |
| Barcode          | save-good form field + scanner button, list rows, Excel export/import column, barcode sort                                       |
| Description      | save-good form field, list rows, Excel export/import column                                                                      |
| Minimum quantity | save-good form field, list row min-quantity text, Excel column, **low-stock notification, Home/low-stock badge, Reorder report** |

### Addendum: Purchase price and Sale price

Added later at the user's request as two more toggles (`showPurchasePrice`, `showSalePrice`, default
ON). Scope (my call): the Good's own default prices only — save-good form (when not editing a
document line), goods rows, goods summary totals, list-settings sheet, Excel columns. Document
transaction prices/amounts and reports are untouched because they are financial records.

## Approaches considered

- **A (chosen): per-store JSON in `AppSettings`** under key `GoodPropertiesSettings_<storeId>`.
  No migration, follows the `AutoDocumentNo` per-store key pattern and existing JSON settings.
- B: SQLite table `StoreSettings` — travels with backup but needs schema v9 + migration (migrations
  are not awaited, per docs). Too heavy for 4 booleans.
- C: columns on `Stores` — migration needed and mixes display prefs into an entity table.

## Design

- Entity `GoodPropertiesSettings` (freezed + json): `showImage`, `showBarcode`, `showDescription`,
  `showMinQuantity`, all `@Default(true)`. In `lib/domain/entity/`.
- `AppSettings.getGoodPropertiesSettings([storeId])` / `setGoodPropertiesSettings(obj, [storeId])`;
  storeId defaults to `getSelectedStoreId()`. Missing key → defaults.
- New page `lib/presentation/pages/settings/good_properties/` with `@injectable` Cubit + freezed
  state, four `SettingsSwitchItem`s, route + `Pages.settings_good_properties` constant.
- Min quantity master switch: effective value = `showMinQuantity && existing flags`
  (showInItem/showInList/showAlert). When OFF, `MinimumQuantityPage` shows a note that it is
  disabled
  in Good properties. Existing toggles and colour are untouched.
- Consumers read the settings (no logic in widgets beyond conditional rendering):
  `save_good_form.dart`, `save_good_cubit.dart`, `good_item_row.dart` + `goods_cubit.dart`,
  `goods_excel_export.dart` / `goods_excel_import.dart` / `excel_column_mapping.dart`,
  `low_stock_service.dart`, `main_page.dart` (notification), Home low-stock usage,
  `reorder_report_data.dart` and its entry in `report_page.dart`.
- Translations: add `good_properties` (+ note string + any labels) to all 11 files in
  `assets/translations/`.
- Docs: update ARCHITECTURE/BUSINESS_LOGIC (new setting, per-Store rule); CONTEXT glossary
  unchanged.

## Constraints

- `shared_preferences` is not included in backup/restore (`db_service.dart` has no `AppSettings`
  use), so these toggles are device-local, like all other settings today.
- Barcodes are not unique (existing rule); unaffected.
- Do not hand-edit generated files; run build_runner after adding freezed/injectable classes.

## Left to the builder

- Exact placement of the Reorder report hiding (hide the entry vs show an empty state) — default:
  hide the Reorder entry in the report list.
- Icons for the new menu item and wording of the translations.
- Whether Excel import should skip the column or just ignore values (default: ignore).
- Verification: `flutter analyze`; no test suite exists, add a small unit test for the settings
  default/per-store behaviour if feasible.
