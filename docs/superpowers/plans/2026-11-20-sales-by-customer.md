# Sales by Customer Report Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** Add the Sales by Customer report (one row per Customer plus a "No customer" row; columns
Customer, Quantity, Amount, Cost, Profit) with an optional Customer filter chosen in the date-range
bottom sheet.

**Architecture:** Same shape as Sales by Item. A pure function aggregates outgoing Documents and
their Transactions per Customer; `SalesByCustomerReportData` loads inputs (shared
`loadOutgoingSales`, customers, goods prices). An optional `customerId` is threaded Report page →
router → `ReportDetailPage` → `ReportDetailCubit.init` → `ReportDataFactory.create`, next to the
existing `groupId`.

**Tech Stack:** Flutter, flutter_bloc, injectable, easy_localization, flutter_test.

**Spec:** [docs/superpowers/specs/2026-11-20-sales-by-customer-design.md](../specs/2026-11-20-sales-by-customer-design.md).
Existing code to mirror: `lib/data/report_data/sales_by_item_rows.dart`,
`sales_by_item_report_data.dart`, `outgoing_sales_loader.dart`, and the Group row in
`lib/presentation/pages/report/report_page.dart`.

## Global Constraints

- Only `DocumentType.outgoing` Documents count; their customer is `Document.personId`. Amount = Σ
  quantity × `DocumentTransaction.price` (null → 0); Cost = Σ quantity × the Good's current
  `purchasePrice` (null or unknown Good → 0); Profit = Amount − Cost.
- **All** (`customerId == null`): one row for every Customer of the store (zeros when nothing
  bought), sorted by name case-insensitive A→Z, then a final **"No customer"** row (always shown,
  zeros allowed) holding outgoing Documents whose `personId` is null or matches no listed Customer.
  Total therefore equals Sales by Date / Sales by Item for the same range.
- **One Customer**: exactly one row for it; no "No customer" row; Documents of other Customers
  ignored. If the id is not in the store's customers → empty table.
- Row key = `customer.id`; "No customer" row key = `-1`. First column title = existing key
  `customer`.
- Pick through `Pages.customer_list` with `{'isSelection': true}` (pops a `Customer`; `null` on
  Back → keep previous choice). Choice resets to All each time the sheet opens. No clear (×) button
  (user decision). Customer row appears only for Sales by Customer.
- No row tap navigation, no schema/SQL change, no new dependency.
- New keys in all 11 files in `assets/translations/` (edit JSON directly; reuse `customer`, `all`):
  `report_type_sales_by_customer` (en "Sales by customer", vi "Doanh số theo khách hàng"),
  `no_customer` (en "No customer", vi "Không có khách hàng"); translate the other 9 locales
  natively; grep first that both keys are absent.
- Do not hand-edit generated files; do not reformat unrelated code; never `git add`
  `lib/presentation/pages/main/main_page.dart`.
- Update `docs/BUSINESS_LOGIC.md` (14 report types + rule paragraph) and `CONTEXT.md` ("13 report
  types" → 14).

## Review Focus

- Outgoing Document whose customer was deleted (`customerId` null) or belongs to another store → "No
  customer" under All; ignored under a single Customer.
- Selected Customer id missing from the store's customers → empty table, no crash.
- Customer who bought nothing → row of zeros under All.
- Two Customers with the same name → two rows (keys differ).
- Incoming Documents never count; null `purchasePrice` or unknown Good → Cost 0; null price → Amount
  0.
- Back from the Customer picker keeps the previous choice.

---

### Task 1: Per-Customer aggregation (pure, tested)

**Files:**

- Create: `lib/data/report_data/sales_by_customer_rows.dart`
- Test: `test/sales_by_customer_rows_test.dart`

**Interfaces:**

- Produces:
    -
    `class SalesByCustomerRow { final int? customerId; final String? name; final double quantity; final double amount; final double cost; double get profit; }`
    (const ctor, named required params; `customerId == null` ⇒ the "No customer" row).
    -
    `List<SalesByCustomerRow> buildSalesByCustomerRows({required List<Customer> customers, required List<Document> documents, required Map<int, List<DocumentTransaction>> transactionsByDocumentId, required Map<int, double?> purchasePriceByGoodId, int? onlyCustomerId})` —
    rules in Global Constraints.
    -
    `List<MapEntry<int, List<String>>> salesByCustomerTableRows(List<SalesByCustomerRow> rows, String noCustomerLabel)` —
    key `customerId ?? -1`; cells `[name ?? noCustomerLabel, qty, amount, cost, profit]` via
    `getDoubleText` (`lib/data/report_data/utils.dart`).
- Consumes: `Customer`, `Document`, `DocumentType`, `DocumentTransaction`
  (`lib/domain/entity/entity.dart`).

- [ ] **Step 1: Write failing tests** in `test/sales_by_customer_rows_test.dart` (helpers
  `customer(id, name)`, `doc(id, type, personId)`, `tx(documentId, goodId, qty, price)`, modelled on
  `test/sales_by_item_rows_test.dart`). Test names and assertions:
    - `all: one row per customer, zeros for non-buyers, no-customer row last`: customers A (1), B
      (2); outgoing doc1 (person 1) tx (good 1, 2, 10); prices {1: 4} → rows `[A, B, noCustomer]`; A
      q2 a20 c8 p12; B zeros; noCustomer zeros, `customerId == null`.
    - `no-customer row collects null and unknown customers`: doc with `personId` null and doc with
      `personId` 99 → both land in no-customer row (sums).
    - `single customer: only that row, others and no-customer ignored`: `onlyCustomerId: 1` → length
      1, A only, values exclude doc of customer 2 and null-customer doc.
    - `single customer missing from list gives empty`: `onlyCustomerId: 77` → empty list.
    - `ignores incoming documents`.
    - `null price counts as zero amount; unknown good gives zero cost`.
    - `sorted by name case-insensitive`: `b`, `A`, `C` → `A`, `b`, `C` (then no-customer).
    - `same name customers stay separate`: two `X` ids 1, 2 → keys `{1, 2, -1}` from
      `salesByCustomerTableRows`.
    - `table cells and labels`: no-customer row with label `'NC'` → first cell `'NC'`, key `-1`;
      customer A row cells `['A', '2', '20', '8', '12']`.
    - `negative profit formats with minus`: amount 100, cost 1300 → `-1,200`.

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_customer_rows_test.dart`
Expected: FAIL (missing symbols).

- [ ] **Step 3: Implement** both functions in `sales_by_customer_rows.dart`. Approach: accumulators
  keyed by customer id plus one for no-customer; a document's `personId` not in the accumulator map
  goes to no-customer when `onlyCustomerId == null`, is skipped otherwise.

- [ ] **Step 4: Run to verify pass**

Run: `flutter test test/sales_by_customer_rows_test.dart`
Expected: all PASS. Then `flutter analyze lib/data/report_data` → No issues.

- [ ] **Step 5: Commit**

```bash
git add lib/data/report_data/sales_by_customer_rows.dart test/sales_by_customer_rows_test.dart
git commit -m "feat: per-customer sales aggregation"
```

---

### Task 2: Report type, data loader, customerId plumbing, strings, docs

**Files:**

- Modify: `lib/domain/entity/report_type.dart` (`SALES_BY_CUSTOMER`, title key
  `report_type_sales_by_customer`)
- Create: `lib/data/report_data/sales_by_customer_report_data.dart`
- Modify: `lib/data/report_data/report_data_factory.dart` —
  `create(..., {int? groupId, int? customerId})`; new case
- Modify: `lib/presentation/pages/report_detail/bloc/report_detail_cubit.dart` —
  `init(..., {int? groupId, int? customerId})` forwards both
- Modify: `lib/presentation/pages/report_detail/report_detail_page.dart` —
  `ReportDetailPage(this.type, this.start, this.end, {this.groupId, this.customerId})`, passes to
  `init`
- Modify: `lib/presentation/router.dart` (`Pages.report_detail`: `customerId: args["customerId"]`)
- Modify: all 11 `assets/translations/*.json`; Test: `test/sales_by_customer_translations_test.dart`
- Modify: `docs/BUSINESS_LOGIC.md`, `CONTEXT.md`

**Interfaces:**

- Consumes: Task 1; `loadOutgoingSales` (`lib/data/report_data/outgoing_sales_loader.dart`);
  `CustomersUseCase.getAllByStoreId(int)`; `GoodsUseCases.getAllByStoreId(int)`;
  `AppSettings.getSelectedStoreId()`; `'no_customer'.tr()` from
  `package:easy_localization/easy_localization.dart` (no BuildContext available in report data; same
  pattern as other data-layer text).
- Produces: `class SalesByCustomerReportData extends ReportData` with
  `{required DateTime start, required DateTime end, required int? customerId, required DocumentUseCases documentUseCases, required CustomersUseCase customersUseCase, required GoodsUseCases goodsUseCases}`;
  columns `ColumnInfo("customer")`, then
  `ColumnInfo("quantity" | "amount" | "cost" | "profit", showTotal: true)`.

- [ ] **Step 1: Write failing test** `test/sales_by_customer_translations_test.dart` (copy
  `test/sales_by_item_translations_test.dart`; keys `report_type_sales_by_customer`, `no_customer`).

- [ ] **Step 2: Run to verify failure**

Run: `flutter test test/sales_by_customer_translations_test.dart`
Expected: FAIL.

- [ ] **Step 3: Add the 2 keys to all 11 locale files** (throwaway Dart script in the scratchpad, as
  for earlier keys: append before the final `}`; no python/node on this machine).

- [ ] **Step 4: Implement** the enum value, `SalesByCustomerReportData` (customers from
  `getAllByStoreId(AppSettings.getSelectedStoreId())`; prices map from the store's goods; sales from
  `loadOutgoingSales`; result via the two Task 1 functions with label `'no_customer'.tr()`), factory
  case (factory already holds `customersUseCase`), and the `customerId` plumbing. Callers that omit
  the new parameters must keep compiling.

- [ ] **Step 5: Docs**: BUSINESS_LOGIC.md → 14 types plus a Sales by customer paragraph (rows, No
  customer row, single-Customer rule, same figures; logic file); CONTEXT.md "13" → "14".

- [ ] **Step 6: Verify**

Run: `flutter test test/sales_by_customer_translations_test.dart` → PASS.
Run:
`flutter analyze lib/data lib/domain lib/presentation/pages/report_detail lib/presentation/router.dart` →
No issues (the icon switch in `report_page.dart` is non-exhaustive until Task 3; analyze that file
after Task 3).

- [ ] **Step 7: Commit**

```bash
git add lib/domain/entity/report_type.dart lib/data/report_data lib/presentation/pages/report_detail lib/presentation/router.dart assets/translations test/sales_by_customer_translations_test.dart docs/BUSINESS_LOGIC.md CONTEXT.md
git commit -m "feat: Sales by Customer report data, customerId plumbing and translations"
```

---

### Task 3: Report screen — item and Customer row in the bottom sheet

**Files:**

- Modify: `lib/presentation/pages/report/report_range_selection.dart` —
  `ReportRangeSelection(this.type, {this.groupId, this.customerId})` (named optional; fields
  `int? groupId`, `int? customerId`)
- Modify: `lib/presentation/pages/report/report_page.dart`

**Interfaces:**

- Consumes: `ReportType.SALES_BY_CUSTOMER`; keys `customer`, `all` (existing); `Pages.customer_list`
  with `{'isSelection': true}` (pops `Customer`, `null` on Back); `Pages.report_detail` accepts
  `'customerId'`.

- [ ] **Step 1: Add the item** to the Sales group list (after `SALES_BY_ITEM`) and
  `SALES_BY_CUSTOMER` → `Icons.people_outline` in `_getIconForReportType`.

- [ ] **Step 2: Change `ReportRangeSelection`** as above and update its existing use
  `ReportRangeSelection(type, groupId)` →
  `ReportRangeSelection(type, groupId: groupId, customerId: customerId)`.

- [ ] **Step 3: Extend `showSelectDateRangeType`** with `bool showCustomer = false` next to
  `showGroup`; add local `int? customerId; String? customerName;`. When `showCustomer`, render a
  `ListTile` like the Group row: title `context.tr("customer")`, trailing
  `customerName ?? context.tr("all")` + chevron; `onTap` pushes `Pages.customer_list` with
  `{'isSelection': true}`, and on a non-null `Customer` result sets `customerId = c.id`,
  `customerName = c.name` inside `setSheetState`. Back (`null`) changes nothing.

- [ ] **Step 4: Update `onReportTypeTapped`**: pass
  `showCustomer: reportType == ReportType.SALES_BY_CUSTOMER`; add
  `'customerId': selection.customerId` to the `report_detail` arguments.

- [ ] **Step 5: Static checks**

Run: `dart format lib/presentation/pages/report` then `flutter analyze` → no new issues (baseline: 1
warning, `flutter_lints` not found).
Run: `flutter test` → all PASS.

- [ ] **Step 6: Manual check** (Android emulator or Windows; report what could not be run): Sales
  shows three items; Sales by customer sheet shows "Customer: All ›" (other Sales reports do not);
  All → every Customer, zeros for non-buyers, "No customer" last, Total equals Sales by item's Total
  for the same range; pick a Customer → only its row; Back from the picker keeps the previous
  choice; close and reopen sheet → All; settings button hides/shows columns.

- [ ] **Step 7: Commit**

```bash
git add lib/presentation/pages/report
git commit -m "feat: Sales by Customer on Report screen with Customer filter in date range sheet"
```
