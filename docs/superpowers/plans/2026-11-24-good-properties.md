# Good Properties Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** Per-Store toggles that hide Image, Barcode, Description and Minimum quantity everywhere a
Good shows them, reachable from the Settings page and the main menu page.

**Architecture:** A freezed entity `GoodPropertiesSettings` is stored as JSON in `AppSettings` under
a per-store key. A new settings page (Cubit + freezed state) edits it. Each consumer (form, list
rows, Excel, low-stock paths) reads it. A static revision notifier lets already-built tabs (Goods,
Home are kept alive in `MainPage`'s `IndexedStack`) refresh after a change.

**Tech Stack:** Flutter, flutter_bloc (Cubit), freezed/json_serializable, injectable,
easy_localization, shared_preferences via `Storage`.

**Spec:** [docs/superpowers/specs/2026-11-24-good-properties-design.md](../specs/2026-11-24-good-properties-design.md)

## Global Constraints

- Defaults: all four properties ON. A Store with no saved value behaves exactly as today.
- Key format: `GoodPropertiesSettings_<storeId>` (JSON string), same style as `AutoDocumentNo`.
- Hidden means not displayed; stored values (image, barcode, description, minQuantity) are never
  erased.
- Minimum quantity OFF is a master switch: effective = `showMinQuantity && <existing flag>`;
  existing `MinimumQuantitySettings` values are never modified by it.
- No schema change, no new dependency. Settings are not part of backup/restore.
- Do not hand-edit `*.freezed.dart`, `*.g.dart`, `lib/di/di.config.dart`; run codegen as in
  `docs/DEVELOPMENT.md`.
- New user-visible strings go into all 11 files in `assets/translations/` (edit JSON directly).
- Domain terms: Store, Good, Document. Do not fix unrelated bugs.
- Do not commit unless the user asks.

## Review Focus

- Store B must not see Store A's toggles; a new Store (no key) shows all ON.
- Missing, empty or corrupt JSON for the key → defaults, never a crash; `getSelectedStoreId()`
  returning `-1` must not throw.
- Existing Goods whose quantity is below `minQuantity` while Minimum quantity is OFF: no
  notification, no Home low-stock tile, no low-stock text/badge on rows, no Reorder entry.
- Saving a Good while a property is hidden keeps its existing barcode, description, minQuantity and
  images.
- Excel import of a file that has data in columns of a hidden property: those values are ignored,
  name import still works; export has no column for hidden properties.
- Changing a toggle takes effect on the Goods and Home tabs without restarting the app.

---

## File Structure

- Create `lib/domain/entity/good_properties_settings.dart` — entity (+ export in `entity.dart`).
- Modify `lib/data/app_settings.dart` — per-store get/set, revision notifier.
- Create
  `lib/presentation/pages/settings/good_properties/{good_properties_page.dart, bloc/good_properties_cubit.dart, bloc/good_properties_state.dart}`.
- Modify `lib/presentation/pages/pages.dart`, `lib/presentation/router.dart`, `settings_page.dart`,
  `menu_page.dart`.
- Modify consumers (Tasks 3–5), `minimum_quantity_page.dart` (note), `assets/translations/*.json`
  (11), docs.
- Test: `test/data/good_properties_settings_test.dart`.

---

### Task 1: Entity and per-store storage

**Files:**

- Create: `lib/domain/entity/good_properties_settings.dart`; export it from
  `lib/domain/entity/entity.dart`
- Modify: `lib/data/app_settings.dart`
- Test: `test/data/good_properties_settings_test.dart`

**Interfaces:**

- Produces:
    -
    `GoodPropertiesSettings({bool showImage = true, bool showBarcode = true, bool showDescription = true, bool showMinQuantity = true})` —
    freezed, `fromJson`/`toJson`.
    - `static GoodPropertiesSettings AppSettings.getGoodPropertiesSettings({int? storeId})` —
      `storeId` defaults to `getSelectedStoreId()`; returns defaults on missing/invalid JSON.
    -
    `static void AppSettings.setGoodPropertiesSettings(GoodPropertiesSettings value, {int? storeId})` —
    saves, then increments the notifier.
    - `static final ValueNotifier<int> AppSettings.goodPropertiesRevision` (starts at 0).
    - `static bool AppSettings.isMinQuantityEnabled()` —
      `getGoodPropertiesSettings().showMinQuantity`.

- [ ] **Step 1: Write failing tests** in `test/data/good_properties_settings_test.dart`. Setup:
  `SharedPreferences.setMockInitialValues({})`,
  `await AppSettings.initialize(PrefStorage(prefs: await SharedPreferences.getInstance()))` (its
  return value may be false because Hive is not initialised; `_storage` is still set — ignore it).
  Tests:
    - `defaults are all true when nothing saved`: `getGoodPropertiesSettings(storeId: 1)` equals
      `GoodPropertiesSettings()` with four `true`.
    - `values are isolated per store`: set `showBarcode: false` for store 1; store 1 →
      `showBarcode == false`; store 2 → `true`.
    - `uses selected store by default`: `setSelectedStoreId(5)`; set without `storeId`;
      `getGoodPropertiesSettings(storeId: 5).showImage` reflects it.
    - `corrupt json falls back to defaults`: write `"{not json"` to `GoodPropertiesSettings_3` via
      prefs; `getGoodPropertiesSettings(storeId: 3)` returns defaults without throwing.
    - `no selected store (-1) returns defaults`.
    - `setting bumps revision`: `goodPropertiesRevision.value` increases by 1 after a set.
    - `isMinQuantityEnabled follows showMinQuantity`.
- [ ] **Step 2: Run** `flutter test test/data/good_properties_settings_test.dart` → expect FAIL
  (symbols missing).
- [ ] **Step 3: Implement** the entity (freezed + json, `@Default(true)` on each field) and run
  codegen; implement the `AppSettings` members with key `'GoodPropertiesSettings_$id'`; wrap
  `jsonDecode`/`fromJson` in try/catch returning defaults.
- [ ] **Step 4: Run** the test file → expect all PASS.

---

### Task 2: Settings page, routes and two menu entry points

**Files:**

- Create: `lib/presentation/pages/settings/good_properties/good_properties_page.dart`,
  `bloc/good_properties_cubit.dart`, `bloc/good_properties_state.dart`
- Modify: `lib/presentation/pages/pages.dart`, `lib/presentation/router.dart`,
  `lib/presentation/pages/settings/settings_page.dart`,
  `lib/presentation/pages/menu/menu_page.dart`; run codegen (DI + freezed)
- Test: `test/presentation/good_properties_cubit_test.dart`

**Interfaces:**

- Consumes: Task 1 `AppSettings` API.
- Produces:
    - `@injectable class GoodPropertiesCubit extends Cubit<GoodPropertiesState>` with `void init()`,
      `void onShowImageChanged(bool)`, `onShowBarcodeChanged(bool)`,
      `onShowDescriptionChanged(bool)`, `onShowMinQuantityChanged(bool)`; each emits then saves via
      `AppSettings.setGoodPropertiesSettings`.
    -
    `GoodPropertiesState.initial({@Default(true) bool showImage, showBarcode, showDescription, showMinQuantity})`.
    - `Pages.settings_good_properties = "/settings_good_properties"`.

- [ ] **Step 1: Write failing cubit test** (mock prefs as in Task 1): after `init()` with nothing
  saved all four are true; after `onShowBarcodeChanged(false)` state has `showBarcode == false` and
  `AppSettings.getGoodPropertiesSettings().showBarcode == false`; other three unchanged.
- [ ] **Step 2: Run** `flutter test test/presentation/good_properties_cubit_test.dart` → FAIL.
- [ ] **Step 3: Implement** cubit + state mirroring `MinimumQuantityCubit`/`MinimumQuantityState`.
- [ ] **Step 4: Run** the cubit test → PASS.
- [ ] **Step 5: Implement the page** `GoodPropertiesPage` modelled on `minimum_quantity_page.dart`:
  `SettingsScaffold(title: context.tr("good_properties"))`, one `SettingsMenuCard` with four
  `SettingsSwitchItem`s (icons: `Icons.image_outlined`, `UIConstants.barcodeIconData`,
  `Icons.notes_outlined`, `Icons.warning_amber_rounded`; titles `good_properties_image`, `barcode`,
  `label_description`, `min_quantity`; last has `isLast: true`). Call `init()` in `initState`.
- [ ] **Step 6: Register route** in `router.dart` next to `Pages.settings_minimum_quantity`
  (`BlocProvider(create: (_) => getIt<GoodPropertiesCubit>(), child: GoodPropertiesPage())`) and the
  constant in `pages.dart`.
- [ ] **Step 7: Add entry points** — `settings_page.dart`: new
  `SettingsMenuItem(icon: Icons.checklist_rounded, title: context.tr("good_properties"), onTap: pushNamed(Pages.settings_good_properties))`
  placed right before the Minimum quantity item; `menu_page.dart` `_buildSettingsCard()`: new
  `SettingsMenuItem` between the "settings" item and the "subscriptions_title" item (neither is
  `isLast`; Subscription stays last).
- [ ] **Step 8: Translations** — add keys `good_properties` (en "Good properties", vi "Thuộc tính
  hàng hóa"), `good_properties_image` (en "Image", vi "Hình ảnh"),
  `good_properties_min_quantity_disabled_note` (en "Turned off in Good properties", vi "Đã tắt trong
  Thuộc tính hàng hóa") to all 11 locale files; translate the other nine.
- [ ] **Step 9: Run** `flutter analyze` → no new issues; open Settings → "Good properties" and menu
  tab → entry between Settings and Subscription (manual check on Windows or device).

---

### Task 3: Save-good form honours Image, Barcode, Description, Minimum quantity

**Files:**

- Modify: `lib/presentation/pages/save_good/bloc/save_good_cubit.dart`, `save_good_state.dart`,
  `lib/presentation/pages/save_good/components/save_good_form.dart`; run codegen
- Test: `test/presentation/save_good_properties_test.dart` (state/flag logic only)

**Interfaces:**

- Consumes: Task 1.
- Produces: `SaveGoodState` gains `@Default(true) bool showImage, showBarcode, showDescription`.
  Existing `showMinQuantity` becomes `settings.showMinQuantity && minQuantitySettings.showInItem`,
  computed in `initState()`.

- [ ] **Step 1: Write failing test** for a pure helper
  `static bool SaveGoodCubit.effectiveShowMinQuantity(GoodPropertiesSettings p, MinimumQuantitySettings m)`
  returning `p.showMinQuantity && m.showInItem`: (true,true)→true, (false,true)→false, (true,false)
  →false.
- [ ] **Step 2: Run** the test → FAIL.
- [ ] **Step 3: Implement** the helper; in `initState()` read
  `AppSettings.getGoodPropertiesSettings()` and emit the four flags.
- [ ] **Step 4: Run** the test → PASS.
- [ ] **Step 5: Update `save_good_form.dart`** to wrap with `if (state.showX)`: the
  `EntityPhotoAvatar` (and its following spacer) and `ImagesInformationSection` on `showImage`; the
  description `AppTextField` + spacer on `showDescription`; `_buildBarCode` + spacer on
  `showBarcode`; the min-quantity field is already guarded by `showMinQuantity`.
  `insertOrUpdateGood` must not clear hidden values (it copies state values loaded in `init`; keep
  as is — verify, do not change).
- [ ] **Step 6: Run** `flutter analyze`; manual check: toggle each property OFF, open Add Good and
  Edit Good — field absent; save an existing Good that has barcode/description/min quantity/image
  with them hidden, then turn them ON — values intact.

---

### Task 4: Goods list, grid, search and search-results honour the toggles

**Files:**

- Modify: `lib/presentation/pages/goods/good_item_row.dart`, `goods/bloc/goods_cubit.dart`,
  `goods/bloc/goods_state.dart`, `goods/goods_view.dart`, `goods/goods_list_view_page.dart`,
  `goods/component/list_settings_good_widget.dart`, `goods/component/sort_good_widget.dart`,
  `search/search_page.dart`; run codegen
- Test: `test/presentation/goods_effective_flags_test.dart`

**Interfaces:**

- Consumes: Task 1 (`getGoodPropertiesSettings`, `goodPropertiesRevision`).
- Produces:
    - `GoodItemRow` new params `bool showImage = true` and `bool showLowStockIndicator = true`.
      `showImage == false`: no image tile (list tile: drop the leading tile; grid tile: drop the
      image). `showLowStockIndicator == false`: `isLowStock` is always false (no orange quantity, no
      "low stock" badge); out-of-stock behaviour unchanged.
    - `GoodsState` gains `@Default(GoodPropertiesSettings()) GoodPropertiesSettings properties`.
    - Callers pass effective flags: `showBarcode: settings.showBarcode && properties.showBarcode`,
      `showDescription` likewise,
      `showMinQuantity: state.showMinQuantity && properties.showMinQuantity`,
      `showImage: properties.showImage`, `showLowStockIndicator: properties.showMinQuantity`.

- [ ] **Step 1: Write failing test** for a pure function
  `bool effectiveFlag(bool legacy, bool property) => legacy && property` placed in
  `lib/presentation/utils.dart` (or the file `goods_cubit.dart` if `utils.dart` is unsuitable): all
  four combinations. (If a trivial `&&` helper is judged not worth a function, replace this step
  with a `GoodItemRow` widget test: with `showImage: false` and an item with `files`, no `Image`
  widget is found; with `showLowStockIndicator: false` and quantity < minQuantity,
  `find.text('low_stock')`-equivalent is absent.)
- [ ] **Step 2: Run** the test → FAIL.
- [ ] **Step 3: Implement** the new `GoodItemRow` params and guards (list tile lines ~87-101 and
  grid tile ~248-265; `isLowStock` at ~55 and ~211).
- [ ] **Step 4: In `GoodsCubit`** load `AppSettings.getGoodPropertiesSettings()` in `initState` and
  `refresh()`/`loadData()`, store it in `state.properties`; subscribe to
  `AppSettings.goodPropertiesRevision` in the constructor (re-read and emit on change) and remove
  the listener in `close()`. Hidden Barcode: `getGoodSortOptions()` should treat `sortByBarcode` as
  `no_sort` when `showBarcode` is false (do not overwrite the saved setting).
- [ ] **Step 5: Update callers** `goods_view.dart`, `goods_list_view_page.dart`, `search_page.dart`
  (they currently pass `true`; read `AppSettings.getGoodPropertiesSettings()` there only to derive
  the flags, e.g. in the page's build via the cubit state or a one-time read in `initState`). In
  `list_settings_good_widget.dart` hide the barcode/description/min-quantity switches and in
  `sort_good_widget.dart` hide the barcode sort when the property is OFF.
- [ ] **Step 6: Run** the test → PASS; `flutter analyze`.
- [ ] **Step 7: Manual check:** with each property OFF, list view and grid view (1, 2, 3 columns)
  and global search show no such data; change a toggle in Settings then switch to the Goods tab —
  updated without restart.

---

### Task 5: Excel import/export honour Barcode, Description, Minimum quantity

**Files:**

- Modify: `lib/presentation/pages/goods/component/excel_column_mapping.dart`,
  `excel_column_mapping_sheet.dart`, `goods_excel_import.dart` (only if it does not already skip
  fields whose mapping is `null`)
- Test: `test/presentation/excel_column_mapping_test.dart`

**Interfaces:**

- Consumes: Task 1.
- Produces: `ExcelColumnMapping.defaults({GoodPropertiesSettings? properties})` — a field's default
  column is `null` when its property is hidden (`barcode` ↔ `showBarcode`, `description` ↔
  `showDescription`, `minQuantity` ↔ `showMinQuantity`); `name`, `purchasePrice`, `salePrice`
  unchanged.
  `static List<ExcelImportField> ExcelColumnMapping.visibleFields(GoodPropertiesSettings p)`.

- [ ] **Step 1: Write failing tests:** (a) `defaults(properties: showBarcode false)[barcode]` is
  `null` and `[description]` is `1`; (b) `visibleFields` with all hidden returns
  `[name, purchasePrice, salePrice]`; (c) with defaults returns all six, in enum order.
- [ ] **Step 2: Run** the file → FAIL.
- [ ] **Step 3: Implement** both members. `ExcelColumnMappingSheet` uses
  `ExcelColumnMapping.defaults(properties: AppSettings.getGoodPropertiesSettings())` and iterates
  `visibleFields(...)`. Confirm `GoodsExcelImportParser` and `GoodsExcelExportBuilder` already skip
  fields whose mapping is `null` (export does: `if (column == null) return`); fix the parser only if
  it does not.
- [ ] **Step 4: Run** the file → PASS; `flutter analyze`.
- [ ] **Step 5: Manual check:** with Barcode OFF, export has no Barcode column; importing a file
  whose barcode column is filled creates Goods with no barcode.

---

### Task 6: Minimum quantity master switch for alerts, Home, Reorder report

**Files:**

- Modify: `lib/core/services/low_stock_service.dart`, `lib/presentation/pages/main/main_page.dart`,
  `lib/presentation/pages/home/bloc/home_cubit.dart`, `home_state.dart`, `home_page.dart`,
  `lib/presentation/pages/report/report_page.dart`, `lib/data/report_data/reorder_report_data.dart`,
  `lib/presentation/pages/settings/minimum_quantity/minimum_quantity_page.dart`; run codegen
- Test: `test/core/low_stock_service_test.dart`

**Interfaces:**

- Consumes: `AppSettings.isMinQuantityEnabled()`.
- Produces: `HomeState` gains `@Default(true) bool showLowStock`.

- [ ] **Step 1: Write failing test** for `LowStockService.hasLowStock()` with a fake/mock
  `GoodsRepository` returning one Good with `quantity 1`, `minQuantity 5` for the selected Store:
  returns `true` when `showMinQuantity` is true, `false` when it is false (set via
  `setGoodPropertiesSettings`). (If `GoodsRepository` cannot be faked without a new dependency,
  extract the pure check into `static bool anyLowStock(List<Good>, bool enabled)` and test that.)
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** in `LowStockService.hasLowStock()`: return `false` first when
  `!AppSettings.isMinQuantityEnabled()`.
- [ ] **Step 4: Run** → PASS.
- [ ] **Step 5: `main_page.dart`:** the low-stock alert condition becomes
  `showAlert && AppSettings.isMinQuantityEnabled()`.
- [ ] **Step 6: Home:** `HomeCubit` computes `lowStockGoods` only when enabled and sets
  `showLowStock`; `home_page.dart` hides the low-stock tile (around line 288) when
  `!state.showLowStock`; `HomeCubit` also listens to `AppSettings.goodPropertiesRevision` and
  reloads, removing the listener in `close()`.
- [ ] **Step 7: Reorder report:** `report_page.dart` removes `ReportType.RE_ORDER` from the
  inventory group when `!AppSettings.isMinQuantityEnabled()` (recompute on `build`; refresh the page
  when the revision changes via a `ValueListenableBuilder` on `goodPropertiesRevision`). Keep
  `ReorderReportData` unchanged apart from nothing else — the entry is hidden, so no empty state is
  needed.
- [ ] **Step 8: Minimum quantity page:** when `!AppSettings.isMinQuantityEnabled()`, show a note row
  using `good_properties_min_quantity_disabled_note` at the top of the page and keep all existing
  controls working.
- [ ] **Step 9: Run** `flutter analyze` and `flutter test`; manual check with a Good below its
  minimum: turn Minimum quantity OFF → no notification at next launch, no Home tile, no Reorder
  entry, no low-stock text on rows; turn ON → all return.

---

### Task 7: Docs and final verification

**Files:**

- Modify: `docs/ARCHITECTURE.md` (new setting page + revision notifier), `docs/BUSINESS_LOGIC.md`
  (per-Store property visibility and Minimum quantity master switch), `CONTEXT.md` only if a listed
  fact becomes false
- Create: `docs/adr/` entry only if the revision-notifier approach is judged architectural
  (otherwise skip)

- [ ] **Step 1:** Update the two docs; link instead of duplicating content.
- [ ] **Step 2: Run** codegen as in `docs/DEVELOPMENT.md`, then `flutter analyze` and
  `flutter test` → all tests pass, no new analyzer issues.
- [ ] **Step 3: Verify all translation files** contain the three new keys (`Grep` each key across
  `assets/translations/*.json`; expect 11 hits per key).
- [ ] **Step 4: Report** what was run, results, and what was not verified (device-only paths:
  notification, camera/scanner).
