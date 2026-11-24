# Quantity Field (decimal digits) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** A per-Store "Number of digits after decimal point" setting (default 2) that formats every
shown quantity and limits what can be typed in quantity fields.

**Architecture:** `GoodPropertiesSettings` gets `quantityDecimals`. Pure helpers in
`lib/util/quantity_format.dart` do rounding, text and input filtering. `StringUtils.getQuantityText`
(18 call sites) reads the setting, and the places that bypass it (reports, Document CSV/PDF, "In
stock", calculators, minimum quantity field) are switched to the same helpers.

**Tech Stack:** Flutter, flutter_bloc, freezed/json_serializable, easy_localization.

**Spec:** [docs/superpowers/specs/2026-11-24-quantity-field-design.md](../specs/2026-11-24-quantity-field-design.md)

## Global Constraints

- Default `quantityDecimals` is **2**; valid range **0..6**, clamped on read and on save.
- Display rule: round to N digits, then drop trailing zeros and a trailing dot (N=2: 5.12→"5.12",
  5.00→"5", 5.20→"5.2", 5.126→"5.13"; N=0: 2.5→"3"); "-0" is shown as "0".
- Stored values are never rounded or rewritten. Excel import and scan flows are not rounded.
- Decimal separator is "."; no thousands separator in app screens, but reports keep thousands
  separators as today.
- Money formatting (`getDoubleText` for prices/amounts) is untouched.
- Setting is per Store, stored with `GoodPropertiesSettings`; old saved JSON must read as 2; reuse
  `AppSettings.goodPropertiesRevision` for refresh.
- No new dependency, no schema change; do not hand-edit generated files (run build_runner); strings
  in all 11 locale files; do not commit unless the user asks.
- Existing tests that exercise report/Document text must keep passing (update an assertion only
  where the spec changes the result, and say so).

## Review Focus

- N = 0 on existing fractional stock: `formatQuantity(2.5, 0)` → "3" while the stored value is
  untouched (Task 1 test).
- Negative and tiny values: `formatQuantity(-0.001, 2)` → "0", never "-0" (Task 1 test).
- Typing: "." first, a second ".", pasted "1.234" with N = 2, and "." with N = 0 are rejected; the
  old text is kept (Task 5 test).
- Old saved JSON without the key reads as 2, and a stored 9 or -1 is clamped to 6 or 0 (Task 1
  test).
- Report totals: a quantity column total uses N decimals with thousands separators ("1,234.5") while
  money columns still round to whole numbers (Task 4 test); `AppSettings` not initialised (row
  builder tests) falls back to 2 without throwing (Task 1 test).

---

## File Structure

- Create `lib/util/quantity_format.dart` — `formatQuantity`, `roundQuantity`,
  `QuantityInputFormatter`.
- Modify `lib/domain/entity/good_properties_settings.dart`, `lib/data/app_settings.dart` — the
  setting.
- Create `lib/presentation/pages/settings/good_properties/change_quantity_decimals_dialog.dart`;
  modify the Good properties cubit/state/page.
- Modify `lib/util/string_utils.dart`, report row builders, `report_data/utils.dart`,
  `column_info.dart`, `report_detail_cubit.dart`, `document_table_builder.dart`, the four quantity
  input widgets.
- Tests: `test/quantity_format_test.dart`, `test/quantity_decimals_test.dart` (+ updates to existing
  row/table tests if needed).

---

### Task 1: Pure formatter and the setting

**Files:**

- Create: `lib/util/quantity_format.dart`, `test/quantity_format_test.dart`,
  `test/quantity_decimals_test.dart`
- Modify: `lib/domain/entity/good_properties_settings.dart`, `lib/data/app_settings.dart`

**Interfaces:**

- Produces:
    - `String formatQuantity(double value, int decimals, {bool grouping = false})`
    - `double roundQuantity(double value, int decimals)`
    -
    `class QuantityInputFormatter extends TextInputFormatter { QuantityInputFormatter(int decimals) }`
    - `GoodPropertiesSettings.quantityDecimals` (`@Default(2) int`)
    - `AppSettings.minQuantityDecimals = 0`, `AppSettings.maxQuantityDecimals = 6`,
      `static int AppSettings.clampQuantityDecimals(int)`,
      `static int? AppSettings.parseQuantityDecimals(String?)` (null unless an integer 0..6),
      `static int AppSettings.getQuantityDecimals()` (selected Store; returns 2 on any failure, e.g.
      storage not initialised).

- [ ] **Step 1: Write failing tests.** `test/quantity_format_test.dart`:
    - `formatQuantity(5.12, 2)=="5.12"`, `(5.0, 2)=="5"`, `(5.2, 2)=="5.2"`, `(5.126, 2)=="5.13"`,
      `(2.5, 0)=="3"`, `(100.0, 2)=="100"`, `(10.50, 1)=="10.5"`, `(-0.001, 2)=="0"`,
      `(-2.5, 1)=="-2.5"`.
    - grouping: `formatQuantity(1234.5, 2, grouping: true)=="1,234.5"`,
      `(1234567.0, 0, grouping: true)=="1,234,567"`, without grouping `"1234.5"`.
    - `roundQuantity(5.126, 2)==5.13`, `roundQuantity(2.4, 0)==2.0`.
    - `QuantityInputFormatter(2)`: accepts "", "5", "5.", ".5", "5.12"; rejects (returns the old
      value) "5.123", "5..1", "a", "5.1.2", "-1"; pasting "1.234" over "" is rejected.
      `QuantityInputFormatter(0)` accepts "12" and rejects "1.".
      `test/quantity_decimals_test.dart` (Hive/prefs setup as in
      `test/good_properties_settings_test.dart`): default is 2; saved per Store; JSON without the
      key reads 2; JSON with 9 reads 6 and -1 reads 0; `parseQuantityDecimals` accepts "0".."6" with
      spaces trimmed and rejects "7", "-1", "", null, "2.5", "abc"; with `AppSettings` never
      initialised (a separate test file `test/quantity_decimals_uninit_test.dart`)
      `getQuantityDecimals()==2`.
- [ ] **Step 2: Run**
  `flutter test test/quantity_format_test.dart test/quantity_decimals_test.dart` → Expected: FAIL
  (symbols missing).
- [ ] **Step 3: Implement** the three helpers (round with `toStringAsFixed`, then trim zeros/dot;
  group the integer part with commas only when asked; the input formatter returns the old value
  unless the new text matches `^\d*\.?\d{0,N}$`, or `^\d*$` when N = 0). Add `quantityDecimals` to
  the entity (run build_runner) and the `AppSettings` members; `getQuantityDecimals` wraps
  everything in try/catch and clamps.
- [ ] **Step 4: Run** the same command → Expected: PASS; run `flutter test` for regressions.

---

### Task 2: Settings section, dialog and translations

**Files:**

- Create: `lib/presentation/pages/settings/good_properties/change_quantity_decimals_dialog.dart`
- Modify: `lib/presentation/pages/settings/good_properties/bloc/good_properties_state.dart`,
  `good_properties_cubit.dart`, `good_properties_page.dart`; `assets/translations/*.json` (11)
- Test: `test/quantity_decimals_cubit_test.dart`

**Interfaces:**

- Consumes: Task 1 `AppSettings.clampQuantityDecimals`, `parseQuantityDecimals`, entity field.
- Produces: `GoodPropertiesState.quantityDecimals` (`@Default(2) int`),
  `GoodPropertiesCubit.onQuantityDecimalsChanged(int value)` (clamps, emits, saves),
  `ChangeQuantityDecimalsDialogWidget(int value)` returning `int?` via `Navigator.pop`.

- [ ] **Step 1: Write failing test** `test/quantity_decimals_cubit_test.dart`: after `init()` with
  nothing saved `state.quantityDecimals==2`; `onQuantityDecimalsChanged(4)` saves 4 for the selected
  Store and leaves the other flags unchanged; `onQuantityDecimalsChanged(99)` saves 6; a fresh cubit
  `init()` restores it; saving bumps `AppSettings.goodPropertiesRevision`.
- [ ] **Step 2: Run** the test → Expected: FAIL.
- [ ] **Step 3: Implement** state field, cubit init/save wiring and handler. Dialog follows
  `change_image_size_dialog.dart` (autofocus number field, `digitsOnly`, `maxLength: 1`, error text
  when `parseQuantityDecimals` is null, OK disabled then). Page: after the Uniqueness card add
  `SettingsSectionHeader(context.tr("quantity_field"))` and a card with one
  `SettingsMenuItem(icon: Icons.pin_outlined, title: context.tr("decimal_digits"), subtitle: state.quantityDecimals.toString(), isLast: true)`
  that opens the dialog and calls the cubit.
- [ ] **Step 4: Translations.** Add `quantity_field` (en "Quantity field"), `decimal_digits` (en
  "Number of digits after decimal point"), `decimal_digits_error` (en "Enter a whole number from 0
  to 6") to all 11 files, translated (insert next to `good_properties_toggle_hint`, valid JSON,
  existing line endings).
- [ ] **Step 5: Run** the cubit test → PASS; `flutter analyze` → no new issues; verify each key
  appears in 11 files.

---

### Task 3: Display everywhere except reports

**Files:**

- Modify: `lib/util/string_utils.dart`,
  `lib/presentation/blocs/add_quantity_and_price/add_quantity_and_price_dialog.dart` ("In stock"),
  `lib/presentation/pages/save_good/components/save_good_form.dart` (minimum quantity text),
  `lib/presentation/pages/save_document/document_table_builder.dart` and its caller in
  `save_document_view.dart`, `lib/presentation/pages/save_document/bloc/save_document_cubit.dart`
  (total rounding)
- Test: `test/quantity_display_test.dart`, update `test/document_table_builder_test.dart`

**Interfaces:**

- Consumes: Task 1 helpers.
- Produces: `StringUtils.getQuantityText(double num)` (same signature) =
  `formatQuantity(num, AppSettings.getQuantityDecimals())`;
  `buildDocumentTable({... , int quantityDecimals = 2})`.

- [ ] **Step 1: Write failing tests.** `test/quantity_display_test.dart` (Hive/prefs setup, set the
  Store's `quantityDecimals`): `StringUtils.getQuantityText(5.126)` is "5.13" at 2, "5.1" at 1, "5"
  at 0; 100.0 stays "100". In `document_table_builder_test.dart` add: with `quantityDecimals: 1` a
  quantity 2.26 shows "2.3" and the total row shows the formatted total; default keeps current
  expectations except that "2.0"/"3.0" become "2"/"3" (update those assertions).
- [ ] **Step 2: Run** both files → Expected: FAIL.
- [ ] **Step 3: Implement.** Replace the body of `getQuantityText`; in the add-quantity dialog use
  `StringUtils.getQuantityText(widget.good.quantity)` for the "In stock" line; show the minimum
  quantity in `save_good_form.dart` with `formatQuantity` (no grouping) instead of
  `Config.simpleCurrencyFormat`; `buildDocumentTable` formats quantity and total quantity with
  `formatQuantity(value, quantityDecimals)` and `save_document_view.dart` passes
  `AppSettings.getQuantityDecimals()`; in `SaveDocumentCubit` replace `toStringAsFixed(2)` with
  `roundQuantity(totalQuantity, AppSettings.getQuantityDecimals())`.
- [ ] **Step 4: Run** both test files and then `flutter test` → Expected: all PASS.

---

### Task 4: Reports

**Files:**

- Modify: `lib/data/report_data/utils.dart`, `column_info.dart`, `list_of_goods_report_data.dart`,
  `reorder_report_data.dart`, `list_of_documents_report_data.dart`, `sales_by_item_rows.dart`,
  `sales_by_date_rows.dart`, `sales_by_month_rows.dart`, `sales_by_customer_rows.dart`,
  `lib/presentation/pages/report_detail/bloc/report_detail_cubit.dart` (and the `ColumnReport` class
  it uses)
- Test: `test/report_quantity_format_test.dart`; keep `sales_by_*_rows_test.dart` passing

**Interfaces:**

- Consumes: Task 1 helpers.
- Produces: `String getQuantityTextForReport(double value)` =
  `formatQuantity(value, AppSettings.getQuantityDecimals(), grouping: true)`;
  `String formatColumnTotal(double sum, {required bool isQuantity})` (quantity: same as above;
  otherwise `getDoubleText`); `ColumnInfo(..., bool isQuantity = false)` carried to
  `ColumnReport.isQuantity`.

- [ ] **Step 1: Write failing tests** `test/report_quantity_format_test.dart`:
  `getQuantityTextForReport(1234.5)=="1,234.5"` at N=2 (and "1,235" at N=0);
  `formatColumnTotal(1234.5, isQuantity: true)=="1,234.5"` and
  `formatColumnTotal(1234.5, isQuantity: false)=="1,234"`/`"1,235"` equal to
  `getDoubleText(1234.5)`; `applyColumnVisibility` still keeps `isQuantity` on the kept columns.
- [ ] **Step 2: Run** → Expected: FAIL.
- [ ] **Step 3: Implement.** Mark the quantity columns `isQuantity: true`: `quantity` in the four
  sales/purchase reports and the documents report; `quantity`, `min_quantity`, `field_reorder` in
  the Reorder report; `field_start_period`, `field_in`, `field_out`, `field_end_period` in the goods
  report (not the wallets report). Replace `getDoubleText` by `getQuantityTextForReport` for those
  cells only (list in Files). In `report_detail_cubit.dart` pass `isQuantity` into `ColumnReport`
  and use `formatColumnTotal` for the totals row.
- [ ] **Step 4: Run** `flutter test test/report_quantity_format_test.dart` and the whole suite →
  Expected: PASS. If an existing row test asserted the old whole-number rounding of a fractional
  quantity, update that assertion and note it.

---

### Task 5: Input limits and calculators

**Files:**

- Modify: `lib/presentation/pages/save_good/components/save_good_form.dart` (transaction quantity,
  minimum quantity, calculator),
  `lib/presentation/blocs/add_quantity_and_price/add_quantity_and_price_dialog.dart`,
  `lib/presentation/pages/save_good/components/quick_insert_document_widget.dart`
- Test: `test/quantity_input_widgets_test.dart`

**Interfaces:**

- Consumes: Task 1 `QuantityInputFormatter`, `roundQuantity`, `formatQuantity`,
  `AppSettings.getQuantityDecimals()`.

- [ ] **Step 1: Write failing test** `test/quantity_input_widgets_test.dart`: a `TextField` using
  `inputFormatters: [QuantityInputFormatter(2)]` and
  `keyboardType: TextInputType.numberWithOptions(decimal: true)` accepts "1.25" via
  `tester.enterText` and ignores a third decimal ("1.256" leaves "1.25"); with 0 digits a "." is
  ignored. (Tests the wiring contract through a small helper `quantityInputFormatters()` and
  `quantityKeyboardType()` that this task adds to `quantity_format.dart`.)
- [ ] **Step 2: Run** → Expected: FAIL (helpers missing).
- [ ] **Step 3: Implement** `List<TextInputFormatter> quantityInputFormatters()` and
  `TextInputType quantityKeyboardType()` (read the setting) and pass them as `inputFormatter` /
  `keyboardType` to the four quantity `AppTextField`s. In the three calculator callbacks write
  `formatQuantity(roundQuantity(p0, N), N)` to the controller and pass the same text to the cubit
  (the Save Good one replaces `p0.toInt()`).
- [ ] **Step 4: Run** the test and the whole suite → PASS; `flutter analyze`.

---

### Task 6: Docs and final verification

**Files:**

- Modify: `docs/BUSINESS_LOGIC.md` (quantity display and input rule), `docs/ARCHITECTURE.md`
  (formatter and setting)

- [ ] **Step 1:** Update both docs; link instead of duplicating.
- [ ] **Step 2: Run** build_runner (`dart run build_runner build --delete-conflicting-outputs`),
  `flutter analyze`, `flutter test` → Expected: no new analyzer issues, all tests pass.
- [ ] **Step 3: Verify** the three new keys exist in all 11 locale files (`grep -l`), and report
  what was run, results and what was not verified (on-device checks of the keyboard, dialog and
  report screens).
