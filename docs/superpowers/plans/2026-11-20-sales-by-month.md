# Sales by Month Report Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** Add the Sales by Month report (12 rows, months 1–12; columns Month, Quantity, Amount,
Cost, Profit; Total row) opened from a "Select year" bottom sheet listing the 5 most recent years.

**Architecture:** A pure function aggregates outgoing Documents and their Transactions per month of
a chosen year. `SalesByMonthReportData` loads inputs with the shared `loadOutgoingSales` and the
store's Goods. The year sheet converts the chosen year into `start = 1 Jan`, `end = 31 Dec` and uses
the existing `Pages.report_detail` flow, so page, cubit and router stay unchanged.

**Tech Stack:** Flutter, flutter_bloc, injectable, easy_localization, flutter_test.

**Spec:** [docs/superpowers/specs/2026-11-20-sales-by-month-design.md](../specs/2026-11-20-sales-by-month-design.md).
Code to mirror: `lib/data/report_data/sales_by_date_rows.dart`, `sales_by_date_report_data.dart`,
`outgoing_sales_loader.dart`.

## Global Constraints

- Only `DocumentType.outgoing` Documents count. Amount = Σ quantity × `DocumentTransaction.price`
  (null → 0); Cost = Σ quantity × the Good's current `purchasePrice` (null or unknown Good → 0);
  Profit = Amount − Cost.
- Always 12 rows, months 1–12 ascending, zeros for months without sales (including future months). A
  Document belongs to the month of its local `date`; Documents outside the chosen year are ignored.
- Row key = month number; Month cell is the plain number `1`…`12`; column title key `month`.
- Year sheet lists **5 years: this year and the 4 before it**, newest first; tapping a year opens
  the report with `start = DateTime(year, 1, 1)`, `end = DateTime(year, 12, 31)`. The "end today"
  rule does not apply. No default highlight.
- Sales by Month does not use the date-range sheet; no change to `ReportDetailPage`,
  `ReportDetailCubit`, `router.dart` or `ReportDataFactory`'s signature.
- No row tap navigation, no schema/SQL change, no new dependency.
- New keys in all 11 files in `assets/translations/` (edit JSON directly):
  `report_type_sales_by_month` (en "Sales by month", vi "Doanh số theo tháng"), `select_year` (en
  "Select year", vi "Chọn năm"), `month` (en "Month", vi "Tháng"); translate the other 9 locales
  natively; grep each file first to confirm the keys are absent.
- Do not hand-edit generated files; do not reformat unrelated code; never `git add` anything outside
  the files a task lists.
- Update `docs/BUSINESS_LOGIC.md` (15 report types + rule paragraph) and `CONTEXT.md` ("14 report
  types" → 15).

## Review Focus

- A Document at 1 Jan 00:00 and one at 31 Dec 23:59:59 of the chosen year are counted; one at 1 Jan
  of the next year and one at 31 Dec of the previous year are not.
- Month with no sales and a month in the future → a row of zeros (12 rows always).
- Documents of other years in the loaded list (defensive) never leak into a month.
- Incoming Documents never count; null `purchasePrice` / unknown Good → Cost 0; null price → Amount
  0.
- Loss-making month → negative Profit prints `-1,200`.
- Year list on 1 Jan and on 31 Dec still contains exactly five consecutive years starting at the
  current one.

---

### Task 1: Month aggregation and year list (pure, tested)

**Files:**

- Create: `lib/data/report_data/sales_by_month_rows.dart`
- Create: `lib/presentation/pages/report/report_years.dart`
- Test: `test/sales_by_month_rows_test.dart`, `test/report_years_test.dart`

**Interfaces:**

- Produces:
    -
    `class SalesByMonthRow { final int month; final double quantity; final double amount; final double cost; double get profit; }`
    (const ctor, named required params).
    -
    `List<SalesByMonthRow> buildSalesByMonthRows({required int year, required List<Document> documents, required Map<int, List<DocumentTransaction>> transactionsByDocumentId, required Map<int, double?> purchasePriceByGoodId})` —
    always 12 rows, month 1…12.
    - `List<MapEntry<int, List<String>>> salesByMonthTableRows(List<SalesByMonthRow> rows)` — key
      `month`; cells `['$month', qty, amount, cost, profit]` via `getDoubleText`
      (`lib/data/report_data/utils.dart`).
    - `List<int> recentYears(DateTime now, {int count = 5})` — `[now.year, now.year - 1, …]`, length
      `count`.
- Consumes: `Document`, `DocumentType`, `DocumentTransaction` (`lib/domain/entity/entity.dart`).

- [ ] **Step 1: Write failing tests.** `test/sales_by_month_rows_test.dart` (helpers
  `doc(id, DateTime date, [type])`, `tx(documentId, goodId, qty, price)` as in
  `test/sales_by_date_rows_test.dart`):
    - `always 12 rows with zeros`: no documents → 12 rows, months `1..12`, all values 0.
    - `sums a month`: doc 2026-03-10 with tx (good 1, 2, 10), (good 2, 1, 5); prices {1: 4, 2:
      null} → row 3: q3 a25 c8 p17; others 0.
    - `aggregates several documents in one month`.
    - `year boundaries`: docs at 2026-01-01 00:00 (counted, month 1), 2026-12-31 23:59:59 (counted,
      month 12), 2027-01-01 00:00 and 2025-12-31 23:59:59 (ignored).
    - `ignores incoming documents`.
    - `null price counts as zero amount; unknown good gives zero cost`.
    - `negative profit formats with minus`: amount 100, cost 1300 → `salesByMonthTableRows(...)`
      profit cell `-1,200`.
    - `table row key and cells`: month 3 above → key 3, cells `['3', '3', '25', '8', '17']`.
      `test/report_years_test.dart`: `recentYears(DateTime(2026, 11, 20))` →
      `[2026, 2025, 2024, 2023, 2022]`; `recentYears(DateTime(2026, 1, 1))` and
      `recentYears(DateTime(2026, 12, 31, 23, 59))` start at 2026 with length 5; `count: 3` → length
      3.

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_month_rows_test.dart test/report_years_test.dart`
Expected: FAIL (missing symbols).

- [ ] **Step 3: Implement** the four symbols. Approach: 12 accumulators; a document counts only if
  outgoing, id non-null and `date.year == year`.

- [ ] **Step 4: Run to verify pass**

Run: `flutter test test/sales_by_month_rows_test.dart test/report_years_test.dart`
Expected: all PASS. Then `flutter analyze lib/data/report_data lib/presentation/pages/report` → No
issues.

- [ ] **Step 5: Commit**

```bash
git add lib/data/report_data/sales_by_month_rows.dart lib/presentation/pages/report/report_years.dart test/sales_by_month_rows_test.dart test/report_years_test.dart
git commit -m "feat: per-month sales aggregation and recent years helper"
```

---

### Task 2: Report type, data loader, strings, docs

**Files:**

- Modify: `lib/domain/entity/report_type.dart` (`SALES_BY_MONTH`, title key
  `report_type_sales_by_month`)
- Create: `lib/data/report_data/sales_by_month_report_data.dart`
- Modify: `lib/data/report_data/report_data_factory.dart` (new case)
- Modify: all 11 `assets/translations/*.json`; Test: `test/sales_by_month_translations_test.dart`
- Modify: `docs/BUSINESS_LOGIC.md`, `CONTEXT.md`

**Interfaces:**

- Consumes: Task 1; `loadOutgoingSales` (`lib/data/report_data/outgoing_sales_loader.dart`);
  `GoodsUseCases.getAllByStoreId(int)`; `AppSettings.getSelectedStoreId()`.
- Produces: `class SalesByMonthReportData extends ReportData` with
  `{required DateTime start, required DateTime end, required DocumentUseCases documentUseCases, required GoodsUseCases goodsUseCases}`;
  the year is `start.year`; columns `ColumnInfo("month")`, then
  `ColumnInfo("quantity" | "amount" | "cost" | "profit", showTotal: true)`. Factory case passes
  `start!`, `end!` and the two use cases.

- [ ] **Step 1: Write failing test** `test/sales_by_month_translations_test.dart` (copy
  `test/sales_by_customer_translations_test.dart`; keys `report_type_sales_by_month`, `select_year`,
  `month`).

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_month_translations_test.dart`
Expected: FAIL.

- [ ] **Step 3: Add the 3 keys to all 11 locale files** (throwaway Dart script in the scratchpad as
  for earlier keys: append before the final `}`, keep valid JSON; no python/node on this machine).

- [ ] **Step 4: Implement** the enum value and title, `SalesByMonthReportData.getData()` (goods
  prices map from the store's goods; `loadOutgoingSales(start, end)`; return
  `salesByMonthTableRows(buildSalesByMonthRows(year: start.year, …))`), and the factory case.

- [ ] **Step 5: Docs**: BUSINESS_LOGIC.md → 15 types + a Sales by month paragraph (year chosen from
  the 5 most recent, 12 rows with zeros, month of the Document's local date, same figures; logic
  file); CONTEXT.md "14" → "15".

- [ ] **Step 6: Verify**

Run: `flutter test test/sales_by_month_translations_test.dart` → PASS.
Run: `flutter analyze lib/data lib/domain` → No issues (the icon switch in `report_page.dart` is
non-exhaustive until Task 3; analyze that file after Task 3).

- [ ] **Step 7: Commit**

```bash
git add lib/domain/entity/report_type.dart lib/data/report_data assets/translations test/sales_by_month_translations_test.dart docs/BUSINESS_LOGIC.md CONTEXT.md
git commit -m "feat: Sales by Month report data and translations"
```

---

### Task 3: Report screen — item and Select year sheet

**Files:**

- Modify: `lib/presentation/pages/report/report_page.dart`

**Interfaces:**

- Consumes: `ReportType.SALES_BY_MONTH`; keys `select_year`, `report_type_sales_by_month`;
  `recentYears(DateTime.now())` (`lib/presentation/pages/report/report_years.dart`);
  `Pages.report_detail` arguments `{'type', 'start', 'end'}`.

- [ ] **Step 1: Add the item** to the Sales group list (after `SALES_BY_CUSTOMER`) and
  `SALES_BY_MONTH` → `Icons.calendar_month_outlined` in `_getIconForReportType`.

- [ ] **Step 2: Add `Future<int?> showSelectYear(BuildContext context)`** beside
  `showSelectDateRangeType`: a bottom sheet styled like it (same rounded top, header row with title
  `context.tr("select_year")` and a close button) with one `ListTile` per
  `recentYears(DateTime.now())` showing the year and a chevron; tapping pops the year; closing pops
  `null`.

- [ ] **Step 3: Branch in `onReportTypeTapped`**: add
  `else if (reportType == ReportType.SALES_BY_MONTH)` before the date-range branch:
  `final year = await showSelectYear(context); if (year == null) return;` then push
  `Pages.report_detail` with
  `{'type': reportType, 'start': DateTime(year, 1, 1), 'end': DateTime(year, 12, 31)}`. Check
  `mounted` before using `context` after the await only if the file's existing flow already does so;
  otherwise keep the existing style.

- [ ] **Step 4: Static checks**

Run: `dart format lib/presentation/pages/report`, then `flutter analyze` → no new issues (baseline:
1 warning, `flutter_lints` not found).
Run: `flutter test` → all PASS.

- [ ] **Step 5: Manual check** (Android emulator or Windows; report what could not be run): Sales
  shows four items; tapping Sales by month opens "Select year" with 5 years, newest first, no
  date-range sheet; picking a year shows 12 rows (months 1–12), zeros for empty months, a Total row,
  period text 1 Jan – 31 Dec of that year; settings button hides/shows columns; for a year, the
  Total equals Sales by Date's Total over the same year (Custom range).

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/pages/report
git commit -m "feat: Sales by Month on Report screen with Select year sheet"
```
