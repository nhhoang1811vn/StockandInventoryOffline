# Quantity field (decimal digits) — design

Status: awaiting approval. Size: small-to-medium change (short design).

## Intent

Let each Store choose how many digits after the decimal point a quantity has. Every place that shows
a
quantity formats it with that setting, and the quantity input fields stop accepting more digits than
the setting allows. The default is **2**, so quantities that already have decimals (for example 2.5
or 1.25) look exactly as they do today.

## Goals

- New section **Quantity field** on the Good properties page with one setting, "Number of digits
  after decimal point" (number text input, integer 0..6, default 2), saved per Store with the other
  Good properties.
- Display rule: round to N digits, then drop trailing zeros and a trailing dot. With N = 2:
  5.12 → "5.12", 5.00 → "5", 5.20 → "5.2", 5.126 → "5.13". With N = 0: 2.5 → "3".
- Applies to every quantity shown: Good rows and totals, Document rows and totals, history,
  add-quantity and quick-insert dialogs ("In stock" line included), Save Good, minimum quantity
  (rows,
  form, Reorder report), reports (all quantity columns and totals) and the Document CSV/PDF table.
- Input (option B): quantity fields accept at most N decimals (N = 0: digits only); calculator
  results are rounded to N before they are written to the field.

## Non-goals / anti-goals

- Stored values are never rounded or rewritten; only how they are shown and typed changes.
- Excel import and barcode-scan flows are not rounded (option C was declined).
- No locale-specific decimal comma (the app uses ".") and no thousands separator in the app screens.
- Money formatting (prices, amounts) is untouched.
- The two empty bullets in the request are ignored; only this one setting is built.

## Constraints

- Today `StringUtils.getQuantityText` prints the full-precision value (18 call sites in 12 files).
  Reports use `getDoubleText` (`NumberFormat('#,###')`), which already rounds quantities to whole
  numbers, and also formats money, so quantity cells need their own helper. The Document CSV/PDF
  table, the "In stock" text and the calculators print the raw `toString()`. The Save Good
  calculator
  truncates with `toInt()`. `SaveDocumentCubit` rounds the Document total quantity to 2 digits.
- Per-Store settings live in `GoodPropertiesSettings` (JSON in preferences); old saved JSON must
  default `quantityDecimals` to 2.
- No schema change, no new dependency, no hand-edited generated files; 11 locale files.

## Approaches

- A: display only. Simple, but typing 1.234 with N = 2 shows 1.23 while 1.234 is stored, so totals
  can
  look wrong.
- **B (chosen): display + input limit.** New numbers always match what is shown; existing data is
  not
  touched.
- C: B plus rounding on Excel import and scan. Strictest, but it silently changes imported data.

## Design

- `GoodPropertiesSettings.quantityDecimals` (`@Default(2) int`), clamped to 0..6 when read and when
  saved. `AppSettings.getQuantityDecimals()` returns it for the selected Store.
- `lib/util/quantity_format.dart`: pure functions `formatQuantity(double, int decimals)`,
  `roundQuantity(double, int decimals)` and a `QuantityInputFormatter(int decimals)`
  (`TextInputFormatter`: digits and at most one ".", at most N decimals, nothing but digits when 0).
- `StringUtils.getQuantityText(double)` keeps its signature and reads the setting, so its 18 call
  sites update with no change. Other sites are switched to it: report quantity cells and totals
  (grouped with thousands separators as before), `buildDocumentTable`, the "In stock" sprintf, the
  calculator callbacks, and the minimum quantity field.
- `SaveDocumentCubit`: replace the fixed `toStringAsFixed(2)` rounding of the total quantity with
  the
  setting. Save Good calculator: `toInt()` becomes `roundQuantity(value, N)`.
- Input: the formatter is passed to the quantity `AppTextField`s (Save Good transaction quantity,
  add-quantity dialog, quick-insert dialog, minimum quantity) and the keyboard becomes decimal when
  N > 0.
- Settings UI: a "Quantity field" section header and one row showing the current value; tapping it
  opens a dialog with a number text field (same pattern as the existing auto-lock and image-size
  dialogs), validated to 0..6. Strings in all 11 locales.
- Refresh: reuse `AppSettings.goodPropertiesRevision` so the Goods/Home/Report tabs refresh.
- Docs: `BUSINESS_LOGIC.md` (display and input rule) and `ARCHITECTURE.md` (formatter).

## Left to the builder

- The exact list of quantity widgets and report cells (grep `getQuantityText`, `getDoubleText` for
  quantity, `quantity.toString()`), and the wording of the dialog hint/error text.
- Tests: pure tests for the formatter and input formatter (including the examples above, N = 0,
  negative
  values and "-0"), the setting default/clamp/per-Store behaviour, and the report/Document table
  text.
