# Sales by Item Report Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the Sales by Item report (one row per Good: Good name, Quantity, Amount, Cost, Profit) with an optional Group filter chosen in the date-range bottom sheet.

**Architecture:** A shared loader fetches outgoing Documents and their Transactions for a range (used by Sales by Date and Sales by Item). A pure function aggregates them per Good. `SalesByItemReportData` picks the Goods (all of the store, or one Group's) and maps rows to table strings. An optional `groupId` is threaded Report page → router → `ReportDetailPage` → `ReportDetailCubit.init` → `ReportDataFactory.create`.

**Tech Stack:** Flutter, flutter_bloc, injectable, easy_localization, flutter_test.

**Spec:** [docs/superpowers/specs/2026-11-20-sales-by-item-design.md](../specs/2026-11-20-sales-by-item-design.md) (builds on [sales-by-date design](../specs/2026-11-20-sales-by-date-design.md) and its implemented code in `lib/data/report_data/sales_by_date_*.dart`).

## Global Constraints

- Only `DocumentType.outgoing` Documents count. Amount = Σ quantity × `DocumentTransaction.price` (null → 0); Cost = Σ quantity × that Good's current `purchasePrice` (null → 0); Profit = Amount − Cost.
- All Goods of the Good list are shown; a Good with no sales shows 0 in every number column.
- **All** → `goodsUseCases.getAllByStoreId(AppSettings.getSelectedStoreId())`, no group query. **Specific Group** → `goodsUseCases.getGoodsByGroupId(groupId)` only; sub-Groups are not included.
- Column title for the first column is "Good name" (new key `good_name`); sorted by Good name, case-insensitive A→Z; row key = `good.id`.
- Reuse `Pages.select_group` for picking (returns `{groupId, groupName}`; `groupId == null` means All). Group resets to All each time the bottom sheet opens. The Group row appears only for Sales by Item.
- No row tap navigation, no schema/SQL change, no new dependency.
- New strings in all 11 files in `assets/translations/` (edit JSON directly). Existing keys to reuse: `group`, `all`, `quantity`, `amount`, `cost`, `profit`.
- Do not hand-edit generated files. Do not reformat unrelated code. Never `git add` `lib/presentation/pages/main/main_page.dart` (uncommitted user changes).
- Update `docs/BUSINESS_LOGIC.md` (13 report types, rule) and `CONTEXT.md` ("12 report types" → 13).

## Review Focus

- Transaction line for a Good outside the chosen Group (or not in the Good list) must be ignored, not crash.
- Group containing no Goods → empty table (header only, no Total row), no crash.
- Picker dismissed with Back (result `null`) must keep the previous Group selection; picking the root resets to All.
- Two Goods with the same name → two separate rows.
- Incoming Documents never count; Good with null `purchasePrice` → Cost 0.
- Loss-making Good → negative Profit prints `-1,200`.

---

### Task 1: Shared loader and per-Good aggregation

**Files:**
- Create: `lib/data/report_data/outgoing_sales_loader.dart`
- Create: `lib/data/report_data/sales_by_item_rows.dart`
- Modify: `lib/data/report_data/sales_by_date_report_data.dart` (use the loader; behaviour unchanged)
- Test: `test/sales_by_item_rows_test.dart`

**Interfaces:**
- Produces:
  - `class OutgoingSales { final List<Document> documents; final Map<int, List<DocumentTransaction>> transactionsByDocumentId; }` and `Future<OutgoingSales> loadOutgoingSales({required DocumentUseCases documentUseCases, required DateTime start, required DateTime end})` — documents from `documentUseCases.getInRange(start.startOfDay(), end.endOfDay())`; transactions fetched only for outgoing documents with non-null id (exactly the loop now in `SalesByDateReportData.getData`).
  - `class SalesByItemRow { final Good good; final double quantity; final double amount; final double cost; double get profit; }` (const constructor, named required params).
  - `List<SalesByItemRow> buildSalesByItemRows({required List<Good> goods, required List<Document> documents, required Map<int, List<DocumentTransaction>> transactionsByDocumentId})` — one row per Good in `goods` (goods with null id skipped), sorted by `good.name.toLowerCase()`.
  - `List<MapEntry<int, List<String>>> salesByItemTableRows(List<SalesByItemRow> rows)` — key `good.id!`; cells `[good.name, qty, amount, cost, profit]` via `getDoubleText` (`lib/data/report_data/utils.dart`).
- Consumes: `Document`, `DocumentType`, `DocumentTransaction`, `Good` (`lib/domain/entity/entity.dart`); `DocumentUseCases.getInRange`, `getTransactionsByDocumentId`; `DateTime.startOfDay()/endOfDay()` (`lib/util/extension/date_time_ext.dart`).

- [ ] **Step 1: Write failing tests** in `test/sales_by_item_rows_test.dart` (helpers `good(id, name, {purchasePrice})`, `doc(id, type)`, `tx(documentId, goodId, qty, price)` as in `test/sales_by_date_rows_test.dart`):
  - `sums per good and lists zero-sale goods`: goods A(1, cost 4), B(2, cost null), C(3); outgoing doc with tx (A,2,10), (B,1,5) → rows A: q2 a20 c8 p12; B: q1 a5 c0 p5; C: all 0; length 3.
  - `ignores lines of goods not in the list`: tx for good 99 → no extra row, A unaffected.
  - `ignores incoming documents`.
  - `aggregates the same good across documents`.
  - `null transaction price counts as zero amount`.
  - `sorted by name case-insensitive`: names `b`, `A`, `C` → `A`, `b`, `C`.
  - `same name goods stay separate rows`: two goods named `X` with ids 1, 2 → 2 rows, keys 1 and 2 in `salesByItemTableRows`.
  - `empty goods gives empty rows`.
  - `negative profit formats with minus`: amount 100, cost 1300 → profit cell `-1,200`.
  - `table row key and cells`: A above → key 1, cells `['A', '2', '20', '8', '12']`.

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_item_rows_test.dart`
Expected: FAIL (missing symbols).

- [ ] **Step 3: Implement `sales_by_item_rows.dart`** (accumulate per good id in a map seeded from `goods`; skip lines whose `goodId` is not a key).

- [ ] **Step 4: Implement `outgoing_sales_loader.dart`** and change `SalesByDateReportData.getData` to call `loadOutgoingSales` instead of its inline loop.

- [ ] **Step 5: Verify**

Run: `flutter test test/sales_by_item_rows_test.dart test/sales_by_date_rows_test.dart`
Expected: all PASS. Run: `flutter analyze lib/data/report_data` → No issues.

- [ ] **Step 6: Commit**

```bash
git add lib/data/report_data test/sales_by_item_rows_test.dart
git commit -m "feat: per-good sales aggregation and shared outgoing sales loader"
```

---

### Task 2: Report type, data loader, groupId plumbing, strings, docs

**Files:**
- Modify: `lib/domain/entity/report_type.dart` (add `SALES_BY_ITEM`, title key `report_type_sales_by_item`)
- Create: `lib/data/report_data/sales_by_item_report_data.dart`
- Modify: `lib/data/report_data/report_data_factory.dart` — signature becomes `ReportData create(ReportType type, DateTime? start, DateTime? end, {int? groupId})`; new case.
- Modify: `lib/presentation/pages/report_detail/bloc/report_detail_cubit.dart` — `init(BuildContext context, ReportType type, DateTime? start, DateTime? end, {int? groupId})` forwards `groupId` to `factory.create`.
- Modify: `lib/presentation/pages/report_detail/report_detail_page.dart` — `ReportDetailPage(this.type, this.start, this.end, {this.groupId})`, passes it to `init`.
- Modify: `lib/presentation/router.dart` (`Pages.report_detail`: pass `groupId: args["groupId"]`).
- Modify: all 11 `assets/translations/*.json`; Test: `test/sales_by_item_translations_test.dart`
- Modify: `docs/BUSINESS_LOGIC.md`, `CONTEXT.md`

**Interfaces:**
- Consumes: Task 1 symbols; `GoodsUseCases.getAllByStoreId(int)`, `GoodsUseCases.getGoodsByGroupId(int?)`, `AppSettings.getSelectedStoreId()`.
- Produces: `class SalesByItemReportData extends ReportData` with `{required DateTime start, required DateTime end, required int? groupId, required DocumentUseCases documentUseCases, required GoodsUseCases goodsUseCases}`; columns `ColumnInfo("good_name")`, `ColumnInfo("quantity", showTotal: true)`, `ColumnInfo("amount", showTotal: true)`, `ColumnInfo("cost", showTotal: true)`, `ColumnInfo("profit", showTotal: true)`. `groupId == null` → `getAllByStoreId`; otherwise `getGoodsByGroupId(groupId)`.
- New translation keys: `report_type_sales_by_item` (en "Sales by item", vi "Doanh số theo hàng hoá"), `good_name` (en "Good name", vi "Tên hàng hoá"); translate the other 9 locales natively, using each locale's existing `report_type_good_info` wording for "Good" as style guide. Grep each file first to confirm the keys are absent. Add with the same Dart/text approach as before (append before the final `}`; keep files valid JSON; no python or node on this machine, use a throwaway Dart script in the scratchpad).

- [ ] **Step 1: Write failing test** `test/sales_by_item_translations_test.dart` (copy `test/sales_by_date_translations_test.dart`, keys `report_type_sales_by_item`, `good_name`).

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_item_translations_test.dart`
Expected: FAIL.

- [ ] **Step 3: Add the 2 keys to all 11 locale files.**

- [ ] **Step 4: Add `ReportType.SALES_BY_ITEM`, `SalesByItemReportData`, factory case and `groupId` plumbing** (cubit, page, router) as listed above. Existing callers that omit `groupId` must keep compiling.

- [ ] **Step 5: Docs**: BUSINESS_LOGIC.md Reports section → 13 types plus a paragraph: Sales by item lists every Good (all of the store, or only those whose `groupId` equals the chosen Group, sub-Groups excluded), same Amount/Cost/Profit rules as Sales by date; CONTEXT.md "12" → "13".

- [ ] **Step 6: Verify**

Run: `flutter test test/sales_by_item_translations_test.dart` → PASS.
Run: `flutter analyze lib/data lib/domain lib/presentation/pages/report_detail lib/presentation/router.dart` → No issues, except the non-exhaustive icon switch in `report_page.dart` until Task 3 (expected; analyze that file only after Task 3).

- [ ] **Step 7: Commit**

```bash
git add lib/domain/entity/report_type.dart lib/data/report_data lib/presentation/pages/report_detail lib/presentation/router.dart assets/translations test/sales_by_item_translations_test.dart docs/BUSINESS_LOGIC.md CONTEXT.md
git commit -m "feat: Sales by Item report data, groupId plumbing and translations"
```

---

### Task 3: Report screen — item and Group row in the bottom sheet

**Files:**
- Create: `lib/presentation/pages/report/report_range_selection.dart` — `class ReportRangeSelection { final ReportDateRangeType type; final int? groupId; const ReportRangeSelection(this.type, this.groupId); }`
- Modify: `lib/presentation/pages/report/report_page.dart`

**Interfaces:**
- Consumes: `ReportType.SALES_BY_ITEM`, keys `group`, `all` (existing), `Pages.select_group` (arguments `{"groupId": int?}`; result `Map` with `groupId`/`groupName`, or `null` on Back), `Pages.report_detail` arguments now accept `'groupId'`.

- [ ] **Step 1: Commit the pending range change first.** `report_page.dart` currently has the user-approved, uncommitted edit (Current month / Current year end today). Commit only that hunk before further edits:

```bash
git add lib/presentation/pages/report/report_page.dart
git commit -m "fix: current month and current year reports end today"
```

- [ ] **Step 2: Add the item to the Sales group** (`_buildReportGroup([ReportType.SALES_BY_DATE, ReportType.SALES_BY_ITEM])`) and `SALES_BY_ITEM` → `Icons.category_outlined` in `_getIconForReportType`.

- [ ] **Step 3: Change `showSelectDateRangeType` to `Future<ReportRangeSelection?> showSelectDateRangeType(BuildContext context, {bool showGroup = false})`.** Wrap the sheet content in `StatefulBuilder` holding local `int? groupId` and `String? groupName`. When `showGroup`, render above the range options a `ListTile`: title `context.tr("group")`, trailing text `groupName ?? context.tr("all")` plus chevron; `onTap` pushes `Pages.select_group` with `{"groupId": groupId}` using the sheet's context; on a non-null result set `groupId = map["groupId"]`, `groupName = map["groupName"]` (root → both null → All); on `null` change nothing. Each range option pops `ReportRangeSelection(type, groupId)`.

- [ ] **Step 4: Update `onReportTypeTapped`**: call the sheet with `showGroup: reportType == ReportType.SALES_BY_ITEM`; use `selection.type` where `reportDateRangeType` was used; add `'groupId': selection.groupId` to the `report_detail` arguments (other reports pass `null`, harmless).

- [ ] **Step 5: Static checks**

Run: `flutter analyze` → no new issues (baseline: 1 warning, `flutter_lints` not found).
Run: `flutter test` → all PASS.

- [ ] **Step 6: Manual check** (Android emulator or Windows; report what could not be run): Sales shows two items; Sales by date sheet has no Group row; Sales by item sheet shows "Group: All" → tap → pick a Group → label shows its name → pick Current month → table lists only that Group's Goods (zeros for unsold), A→Z, Total row; Back from the picker keeps the previous Group; picking the root returns to All; All lists every Good; settings button hides/shows columns.

- [ ] **Step 7: Commit**

```bash
git add lib/presentation/pages/report
git commit -m "feat: Sales by Item on Report screen with Group filter in date range sheet"
```
