# Sales by Item report — design

Second report in the "Sales" group; builds on [Sales by Date](2026-11-20-sales-by-date-design.md).

## Intent
Show, per Good, what was sold in a date range, so the user can see which Goods earn the most and
which do not sell at all. Optionally limited to one Group.

## Goals
- New report type **Sales by Item** under Sales on the Report screen.
- The date-range bottom sheet gets a **Group** row, default **All**, shown only for this report.
- One row per Good. Columns: Good name, Quantity, Amount, Cost, Profit. Total row; the settings
  button shows/hides every column (existing machinery).
- Same figures as Sales by Date: outgoing Documents only; Amount = Σ quantity × `Transaction.price`;
  Cost = Σ quantity × current `Good.purchasePrice` (null → 0); Profit = Amount − Cost.
- **All Goods listed, Goods with no sales show 0** (user decision).
- **All** → load every Good of the store, no group query. **Specific Group** → only Goods whose
  `groupId` equals that Group (user decision; sub-Groups are not included).

## Non-goals
- No sub-Group roll-up, no drill-down when tapping a row, no schema or SQL change.
- Goods with `groupId == null` appear only under All.

## Constraints
- Reuse the existing group tree page (`Pages.select_group`, returns `{groupId, groupName}`);
  picking the root (`groupId == null`) means All.
- `GoodsUseCases.getAllByStoreId(storeId)` for All; `GoodsUseCases.getGoodsByGroupId(int)` for a Group.
- New strings in all 11 locale files; reuse `quantity`, `amount`, `cost`, `profit`; check for an
  existing key for "Good name" and "Group" before adding.
- Follow AGENTS.md; update docs/BUSINESS_LOGIC.md (13 types) and CONTEXT.md.

## Approach
One sensible way, so no alternatives: a pure `buildSalesByItemRows` (tested like Sales by Date),
a `SalesByItemReportData`, and an optional `groupId` threaded Report page → router →
`ReportDetailPage` → `ReportDetailCubit.init` → `ReportDataFactory.create`. Alternatives (a separate
screen for the Group, or filtering after loading all Goods) were rejected: the first duplicates the
date-range flow, the second contradicts the user's "no group query for All / group query for a
Group" rule.

## My calls (not yet confirmed by the user)
- Column title uses "Good name" (glossary), not "Item name".
- Sorted by Good name, case-insensitive A→Z.
- Group row in the sheet reads "Group: All ›"; after picking, shows the Group name. Selection
  resets to All each time the sheet opens.
- The outgoing-Documents-and-Transactions loading in `SalesByDateReportData` is extracted into a
  shared helper so both reports use it (behaviour of Sales by Date unchanged).
- Row key = `good.id`.

## Left to the builder
- `ReportRangeSelection` (or similar) return type for the sheet; `StatefulBuilder` so the Group
  label updates after returning from the picker.
- Exact signatures, translation keys, tests (zero-sale Goods listed, other-Group lines ignored,
  null cost, sorting, Total unaffected).
