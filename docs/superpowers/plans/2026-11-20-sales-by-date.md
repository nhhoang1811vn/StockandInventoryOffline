# Sales by Date Report Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Sales" group (tagged "New") at the top of the Report screen with a Sales by Date report: per-day Quantity, Amount, Cost, Profit, plus a Total row.

**Architecture:** A pure function turns outgoing Documents + their Transactions + a goods price map into per-day rows (testable without DB). `SalesByDateReportData` (a `ReportData`) loads the inputs through existing use cases and maps rows to table strings. Total row, column show/hide dialog and date-range flow are the existing `ReportDetailPage`/`ReportDetailCubit` machinery; no schema change.

**Tech Stack:** Flutter, flutter_bloc, injectable, easy_localization, flutter_test.

**Spec:** [docs/superpowers/specs/2026-11-20-sales-by-date-design.md](../specs/2026-11-20-sales-by-date-design.md)

## Global Constraints

- Amount = Σ quantity × `DocumentTransaction.price` (null → 0); Cost = Σ quantity × `Good.purchasePrice` (null or unknown good → 0); Profit = Amount − Cost.
- Only `DocumentType.outgoing` Documents count.
- Every day from start to end (inclusive) gets a row, zeros when no sales; newest day first.
- Date cell is not tappable (no change to `_buildFirstColumn`; it only navigates for listed types).
- No schema change, no new SQL, no new dependency.
- New user-visible strings go into all 11 files in `assets/translations/` (edit JSON directly). Do not use legacy `translation/` scripts.
- Do not hand-edit `*.freezed.dart`, `*.g.dart`, `lib/di/di.config.dart`. (`ReportDataFactory` signature is unchanged, so no codegen is expected.)
- Do not reformat or touch unrelated files. `lib/presentation/pages/main/main_page.dart` has uncommitted user changes: never `git add` it.
- Domain terms: Good, Document, Transaction (CONTEXT.md glossary).

## Review Focus

- A Document dated 23:59 on the range's last day must be included; one at 00:00 the day after must not.
- Custom range where start and end are the same day → exactly one row.
- Incoming Documents in range must not affect any figure.
- Outgoing line whose good no longer exists in the goods map → Cost 0, no crash.
- Loss-making day (cost > amount) → negative Profit prints as `-1,200` and the cubit's Total row still parses it.
- Range spanning a daylight-saving change still yields one row per calendar day (iterate with `DateTime(y, m, d + 1)`, never `+ Duration(days: 1)`).
- Several Documents on one day aggregate into one row.

---

### Task 1: Per-day calculation (pure, tested)

**Files:**
- Create: `lib/data/report_data/sales_by_date_rows.dart`
- Test: `test/sales_by_date_rows_test.dart`

**Interfaces:**
- Produces:
  - `class SalesByDateRow { final DateTime day; final double quantity; final double amount; final double cost; double get profit; }` (const constructor, named required params).
  - `List<SalesByDateRow> buildSalesByDateRows({required DateTime start, required DateTime end, required List<Document> documents, required Map<int, List<DocumentTransaction>> transactionsByDocumentId, required Map<int, double?> purchasePriceByGoodId})` — newest day first; `day` is local midnight.
  - `List<MapEntry<int, List<String>>> salesByDateTableRows(List<SalesByDateRow> rows, String Function(DateTime) formatDate)` — key = `day.millisecondsSinceEpoch`; values `[formatDate(day), qty, amount, cost, profit]` each number via `getDoubleText` from `utils.dart`.
- Consumes: `Document`, `DocumentType`, `DocumentTransaction` (`lib/domain/entity/entity.dart`), `getDoubleText` (`lib/data/report_data/utils.dart`).

- [ ] **Step 1: Write failing tests** in `test/sales_by_date_rows_test.dart`. Build helpers `doc(id, DateTime date, DocumentType type)` and `tx(documentId, goodId, quantity, price)` (create via `Document()..id=..` / `DocumentTransaction()..` setters; `Document` extends `BaseModel`, check its `id` field). Tests, with assertions:
  - `sums one outgoing day`: doc on 2026-11-10 with tx (good 1, qty 2, price 10) and (good 2, qty 1, price 5); purchase prices {1: 4, 2: null}; range 11-10..11-10 → one row, quantity 3, amount 25, cost 8, profit 17.
  - `empty days appear with zeros, newest first`: range 11-08..11-10, doc only on 11-09 → days [11-10, 11-09, 11-08]; 11-10 and 11-08 all zeros.
  - `ignores incoming documents`: incoming doc on 11-10 → row all zeros.
  - `last day includes 23:59 and excludes next-day 00:00`: docs at 2026-11-10 23:59 and 2026-11-11 00:00, range 11-10..11-10 → one row, only first doc counted.
  - `unknown good gives zero cost`: tx goodId 99 not in map → cost 0, amount counted.
  - `negative profit formats with minus`: amount 100, cost 1300 → `salesByDateTableRows(...)` profit cell `-1,200`.
  - `aggregates several documents on one day` (two docs same day → summed).
  - `dst range keeps one row per calendar day`: range 2026-03-07..2026-03-10 → 4 rows, days distinct dates `7,8,9,10`.
  - `table row key and cells`: row for 2026-11-10 → key `DateTime(2026,11,10).millisecondsSinceEpoch`, cells `['D', '3', '25', '8', '17']` with `formatDate: (_) => 'D'`.

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_date_rows_test.dart`
Expected: FAIL (file/symbols missing).

- [ ] **Step 3: Implement** the three symbols in `sales_by_date_rows.dart`. Approach: build a `Map<DateTime, accumulators>` pre-seeded with every calendar day (loop `d = DateTime(y, m, d + 1)` from `start` day to `end` day), then fold in outgoing documents whose day key exists (documents outside the range are ignored). Missing entry in `transactionsByDocumentId` = no lines. Skip documents with null `id`.

- [ ] **Step 4: Run to verify pass**

Run: `flutter test test/sales_by_date_rows_test.dart`
Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/data/report_data/sales_by_date_rows.dart test/sales_by_date_rows_test.dart
git commit -m "feat: per-day sales calculation for Sales by Date report"
```

---

### Task 2: Report type, data loader, factory, strings, docs

**Files:**
- Modify: `lib/domain/entity/report_type.dart` (add `SALES_BY_DATE`, title `context.tr("report_type_sales_by_date")`)
- Create: `lib/data/report_data/sales_by_date_report_data.dart`
- Modify: `lib/data/report_data/report_data_factory.dart` (new `case ReportType.SALES_BY_DATE`)
- Modify: all 11 `assets/translations/*.json`
- Test: `test/sales_by_date_translations_test.dart`
- Modify: `docs/BUSINESS_LOGIC.md` (Reports section: 12 types, list Sales by Date, the Cost rule), `CONTEXT.md` (Main modules table "11 report types" → 12)

**Interfaces:**
- Consumes: `buildSalesByDateRows`, `salesByDateTableRows` (Task 1); `DocumentUseCases.getInRange`, `DocumentUseCases.getTransactionsByDocumentId(int)`, `GoodsUseCases.getAllByStoreId(int)`, `AppSettings.getSelectedStoreId()`, `DateFormatFactory.getDateFormat()`, `DateTime.startOfDay()/endOfDay()` (`lib/util/extension/date_time_ext.dart`).
- Produces: `class SalesByDateReportData extends ReportData` with `{required DateTime start, required DateTime end, required DocumentUseCases documentUseCases, required GoodsUseCases goodsUseCases}`. Columns, in order: `ColumnInfo("date")`, `ColumnInfo("quantity", showTotal: true)`, `ColumnInfo("amount", showTotal: true)`, `ColumnInfo("cost", showTotal: true)`, `ColumnInfo("profit", showTotal: true)`.
- Translation keys (existing: `date`, `quantity`, `amount`): new `cost`, `profit`, `report_type_sales_by_date`, `sales_title`, `tag_new`. English: "Cost", "Profit", "Sales by date", "Sales", "New". Vietnamese: "Giá vốn", "Lợi nhuận", "Doanh số theo ngày", "Bán hàng", "Mới". Other 9 locales: translate natively, reusing each locale's existing word for quantity/amount as a style guide. Before adding, grep each file to confirm the key does not already exist.

- [ ] **Step 1: Write failing test** `test/sales_by_date_translations_test.dart`, modelled on `test/translations_copy_key_test.dart`: for each of the 11 locales and each of the 5 new keys, the value is a non-empty `String`.

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_date_translations_test.dart`
Expected: FAIL (keys missing).

- [ ] **Step 3: Add the 5 keys to all 11 locale JSON files** (valid JSON; keep file's existing style).

- [ ] **Step 4: Add `ReportType.SALES_BY_DATE`** and its title case. `report_page.dart`'s icon switch and the factory switch are exhaustive, so they will not compile until Task 3 / Step 6; this is expected.

- [ ] **Step 5: Implement `SalesByDateReportData.getData()`**: `documents = documentUseCases.getInRange(start.startOfDay(), end.endOfDay())`; for each outgoing document load transactions via `getTransactionsByDocumentId(id)`; goods map from `goodsUseCases.getAllByStoreId(AppSettings.getSelectedStoreId())` → `{good.id!: good.purchasePrice}`; return `salesByDateTableRows(buildSalesByDateRows(...), (d) => DateFormatFactory.getDateFormat().format(d))`.

- [ ] **Step 6: Register in `ReportDataFactory.create`**: `SalesByDateReportData(start: start!, end: end!, documentUseCases: documentUseCases, goodsUseCases: goodsUseCases)`.

- [ ] **Step 7: Update docs** as listed above. State the Cost limitation: Cost uses the current `Good.purchasePrice`, so editing a purchase price changes past days.

- [ ] **Step 8: Verify translations test passes**

Run: `flutter test test/sales_by_date_translations_test.dart`
Expected: PASS. (`flutter analyze` is expected to flag the non-exhaustive icon switch in `report_page.dart` until Task 3.)

- [ ] **Step 9: Commit**

```bash
git add lib/domain/entity/report_type.dart lib/data/report_data assets/translations test/sales_by_date_translations_test.dart docs/BUSINESS_LOGIC.md CONTEXT.md
git commit -m "feat: Sales by Date report data, type and translations"
```

---

### Task 3: Report screen — Sales group with "New" tag

**Files:**
- Modify: `lib/presentation/pages/report/report_page.dart`

**Interfaces:**
- Consumes: `ReportType.SALES_BY_DATE`, keys `sales_title`, `tag_new` (Task 2). Navigation already handled: `onReportTypeTapped` sends any type other than RE_ORDER/GOOD_INFO through the date-range flow to `Pages.report_detail`.

- [ ] **Step 1: Add `ReportType.SALES_BY_DATE` → `Icons.point_of_sale` to `_getIconForReportType`.**

- [ ] **Step 2: Extend `_buildSectionHeader`** with an optional `bool showNewTag = false`; when true, render the title followed by a small pill (primary color at ~0.12 alpha background, primary text, 10px bold) with `context.tr("tag_new")`, in a `Row`. Default behaviour for existing headers unchanged.

- [ ] **Step 3: Insert as the first children of the `ListView` in `_buildBody`:** `_buildSectionHeader(context.tr("sales_title"), showNewTag: true)` then `_buildReportGroup([ReportType.SALES_BY_DATE])`.

- [ ] **Step 4: Static checks**

Run: `flutter analyze`
Expected: no new issues versus the baseline (record the baseline count before Task 1 if not clean).

Run: `flutter test`
Expected: all tests PASS, including the two new files.

- [ ] **Step 5: Manual check** (run on Android emulator or Windows desktop; report what could not be run): Report tab shows "Sales" first with the "New" pill → tap Sales by date → pick Current month → table shows Date, Quantity, Amount, Cost, Profit, one row per day with newest first, and a Total row; settings button hides/shows each column and the Total row follows; CSV/PDF export works. Cross-check: for a month's outgoing Documents, the Amount total equals the Amount total of List of documents filtered to Outgoing.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/pages/report/report_page.dart
git commit -m "feat: Sales group with New tag on Report screen"
```
