# Sales by Date report — design

## Intent
Add a "Sales" group to the Report screen. Its first item, **Sales by Date**, shows per-day
sales figures so the user can see revenue, cost and profit over a date range.

## Goals
- New report group **Sales** at the top of the Report screen, with a "New" tag on the UI.
- Item **Sales by Date** reuses the existing "Select date range" flow.
- One row per day in the range. Columns: Date, Quantity, Amount, Cost, Profit.
  - Quantity = sum of Transaction quantity over outgoing Documents dated that day.
  - Amount = sum of quantity × `Transaction.price`.
  - Cost = sum of quantity × `Good.purchasePrice`.
  - Profit = Amount − Cost.
- A Total row (Quantity, Amount, Cost, Profit).
- The settings button can show/hide every column (existing `ColumnDisplayDialog`).

## Non-goals
- No schema change, no new SQL, no drill-down on the Date cell.
- No historical purchase price (not stored).
- No CSV/PDF changes beyond what the shared detail page already does.

## Anti-goals
- Amount must not disagree with Document amounts in List of Documents.

## Constraints
- Follow `ReportData` / `ReportDataFactory` / `ReportDetailCubit` pattern.
- Strings go in all 11 files in `assets/translations/` (edit JSON directly).
- Cost uses the *current* `Good.purchasePrice`, so past days change if the price is edited.
  Known limitation, to be mentioned in docs/BUSINESS_LOGIC.md.

## Approaches
- **A. Compute in Dart (chosen).** `documentUseCases.getInRange` → outgoing Documents →
  Transactions per Document → goods map for `purchasePrice` → group by local day. Same pattern as
  `ListOfGoodsReportData`; no DB change.
- **B. SQL aggregate in `DBHelper`.** Faster on big data, but adds DB/repo/use-case code and
  risks day-boundary mismatch versus the displayed date. Rejected for a first report.

## Decisions (agreed)
- Amount uses `Transaction.price`, not `Good.salePrice`.
- Days with no sales still appear, with zeros.
- Sort: newest day first.
- Good with null `purchasePrice` → Cost 0 for that line.
- Date cell not tappable.

## Left to the builder
- Add `ReportType.SALES_BY_DATE`, `SalesByDateReportData`, factory case, title key, icon
  (`Icons.point_of_sale`), and the Sales section in `report_page.dart`.
- "New" tag widget and its translation key (check for an existing key first).
- Number formatting via existing `getDoubleText`; Total row handled by `showTotal: true`.
- Update docs/BUSINESS_LOGIC.md (11 → 12 report types, the Cost rule).
- Verify: `flutter analyze`; no tests exist, so state what could not be run.
