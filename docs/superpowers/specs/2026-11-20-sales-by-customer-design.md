# Sales by Customer report — design

Third report in the "Sales" group; same shape
as [Sales by Item](2026-11-20-sales-by-item-design.md).

## Intent

Show, per Customer, what was sold in a date range, optionally for one Customer only.

## Goals

- New report type **Sales by Customer** under Sales on the Report screen.
- The date-range bottom sheet gets a **Customer** row, default **All**, shown only for this report.
  Tapping it opens the existing `CustomersPage(isSelection: true)` (pops a `Customer`).
- One row per Customer. Columns: Customer (name), Quantity, Amount, Cost, Profit; Total row;
  settings button shows/hides every column (existing machinery).
- Same figures as the other Sales reports: outgoing Documents only; Amount = Σ quantity ×
  `Transaction.price` (null → 0); Cost = Σ quantity × the Good's current `purchasePrice` (null or
  unknown Good → 0); Profit = Amount − Cost.
- **All**: every Customer of the store (zeros for those who bought nothing), plus a final-sorted **"
  No customer"** row for outgoing Documents without a Customer (user decision), so the Total
  equals Sales by Date / Sales by Item for the same range.
- **One Customer**: exactly one row for that Customer; no "No customer" row.

## Non-goals

- No drill-down on row tap, no schema or SQL change, no new dependency.
- No Customer search/filter beyond the existing selection page.

## Constraints

- Document → Customer link is `Document.personId` for outgoing Documents (`customerId` column,
  nullable, `ON DELETE SET NULL`). A `customerId` that matches no listed Customer (e.g. deleted
  Customer already nulled, or a Customer of another store) is treated as "No customer" under All and
  ignored under a single Customer.
- Row key: `customer.id`; the "No customer" row uses key `-1` (no real id is negative).
- Customers loaded with `CustomersUseCase.getAllByStoreId(AppSettings.getSelectedStoreId())`; for a
  single Customer use the id returned by the selection page (no extra query needed beyond
  confirming it exists in that list; if missing, empty table).
- Reuse `loadOutgoingSales` and the cost/amount rules from `sales_by_item_rows.dart`; Good prices
  come from `goodsUseCases.getAllByStoreId`.
- Thread an optional `customerId` like `groupId`: Report page → router → `ReportDetailPage` →
  `ReportDetailCubit.init` → `ReportDataFactory.create`. Generalise the sheet's selection result
  (`ReportRangeSelection`) rather than duplicating it.
- New strings in all 11 locales; reuse `customer`, `all`; new `report_type_sales_by_customer` and
  `no_customer` (check `no_customer` is absent first). Update docs (BUSINESS_LOGIC.md 14 types,
  CONTEXT.md).

## Approach

One sensible way: copy the Sales by Item structure (pure aggregation + table mapper + report data +
optional filter id through the existing plumbing). A separate screen or a post-filter of an
all-Customers table were rejected: the first duplicates the date-range flow, the second loads and
aggregates data the user did not ask for.

## My calls (not yet confirmed)

- First-column title uses the existing `customer` key ("Customer").
- Customers sorted by name case-insensitive A→Z; the "No customer" row always last.
- The sheet's Customer choice resets to All each time it opens; the row shows the Customer's name.
- Customer picking happens through `Pages.customer_list` with `{"isSelection": true}`; Back keeps
  the
  previous choice. Returning to All = close and re-open the sheet (user decision: no clear (×)
  button).

## Left to the builder

- Whether to share the group/customer row code in the sheet via a small helper widget.
- Exact signatures and tests: zero-purchase Customers listed, No customer row sums, single Customer
  excludes it, Total equals the sum of rows plus No customer, null cost/price, sorting, same-name
  Customers stay separate.
