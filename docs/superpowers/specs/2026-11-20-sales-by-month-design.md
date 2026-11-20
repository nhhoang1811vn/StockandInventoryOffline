# Sales by Month report — design

Fourth report in the "Sales" group; same figures
as [Sales by Date](2026-11-20-sales-by-date-design.md).

## Intent

Show, for one chosen year, what was sold in each month, so the user can see seasonality and the
year's profit at a glance.

## Goals

- New report type **Sales by Month** under Sales on the Report screen.
- Tapping it opens a **Select year** bottom sheet (instead of the date-range sheet) listing the **5
  most recent years: this year and the 4 before it**, newest first (user decision). Tapping a year
  opens the report.
- 12 rows, months 1–12 in ascending order, always all 12 (zeros for months without sales, including
  future months). Columns: Month, Quantity, Amount, Cost, Profit; Total row; settings button
  shows/hides every column (existing machinery).
- Same figures as Sales by Date: outgoing Documents only; Amount = Σ quantity × `Transaction.price`
  (null → 0); Cost = Σ quantity × the Good's current `purchasePrice` (null or unknown Good → 0);
  Profit = Amount − Cost.
- The report's range is 1 Jan to 31 Dec of the chosen year, passed as `start` / `end` through the
  existing `Pages.report_detail` arguments (no new route arguments, cubit or page changes).

## Non-goals

- No year list derived from data, no custom year entry, no drill-down on row tap, no schema/SQL
  change, no new dependency.
- The "end today" rule for Current month/year does not apply: a chosen year always runs to 31 Dec.

## Constraints

- Reuse `loadOutgoingSales` (`lib/data/report_data/outgoing_sales_loader.dart`); aggregate months in
  a pure function, tested like the other Sales reports. A document belongs to the month of its local
  `date`.
- Row key = month number (1–12). The Month cell shows the number `1`…`12` (user wrote "1-12"); no
  month names, so no locale work for them.
- New strings in all 11 locales: `report_type_sales_by_month`, `select_year`, `month` (grep first
  that they are absent; `month` is not an existing key). Update docs (BUSINESS_LOGIC.md 15 types,
  CONTEXT.md).

## Approach

One sensible way: a pure `buildSalesByMonthRows` fed by `loadOutgoingSales`, plus a small
year-picker
bottom sheet in `report_page.dart` that feeds `start`/`end` into the existing flow. Alternatives
rejected: reusing the date-range sheet with a year option (the user asked for a dedicated Select
year), and aggregating `SalesByDateReportData` output by month (it formats strings; re-parsing them
is fragile).

## My calls (not yet confirmed)

- Month cell is the plain number (`1`…`12`) under the column title "Month".
- The year sheet has no default highlight; the first (current) year is simply the first row.
- Pure function signature takes the chosen `year` explicitly and ignores documents outside it.

## Left to the builder

- Exact signatures; tests: months without sales are zeros, 12 rows always, documents of another year
  ignored, boundary documents (1 Jan 00:00 and 31 Dec 23:59:59 included, 1 Jan next year excluded),
  incoming ignored, null price/cost, negative profit formatting.
- Whether to share row-building helpers with `sales_by_date_rows.dart`.
