# Changelog

## 1.0.96 (build 117) — 2026-11-24

### Added
- **Good properties** (per Store): hide the properties a Store does not use — Image, Barcode,
  Description, Minimum quantity. Hidden values are kept and come back when turned on again.
  Available from Settings and from the Menu page. Defaults keep today's behaviour (all on).
- **Quantity field**: choose the number of digits after the decimal point (0–6, default 2) per
  Store. Applies to quantity display, input fields, reports and the Document CSV/PDF table.
- **Allow negative quantity in stock** (per Store, default on): when off, adding, editing or
  deleting a transaction or Document that would leave a Good with negative stock is rejected.

### Changed
- Goods, Document, history, search and report screens respect the new Good properties and
  quantity format settings.

### Notes
- No database schema change or migration.
- New text is translated in all 11 locales.
