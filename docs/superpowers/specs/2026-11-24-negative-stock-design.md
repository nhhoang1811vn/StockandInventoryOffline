# Allow negative quantity in stock — design

Status: awaiting approval. Size: small-to-medium change (short design).

## Intent

A Store that does not want to sell or issue more than it has can turn off "Allow negative quantity
in
stock". While it is off, no transaction change may leave a Good with negative stock; the user gets
an
error instead. Default is **on**, which is today's behaviour (negative stock allowed).

## Goals

- New switch `GoodPropertiesSettings.allowNegativeStock` (`@Default(true) bool`), per Store, in the
  "Quantity field" section of Good properties, after the decimal-digits row.
- Rule when the switch is off, for the Store of the transaction: a change is **rejected** if it
  lowers
  a Good's stock and the resulting stock is below 0. Covered changes:
    - add a transaction (outgoing line, from the goods list, barcode scan, quick insert or Save
      Good);
    - edit a transaction (the change is new effect minus old effect: raising an outgoing quantity or
      lowering an incoming one);
    - delete a transaction or a whole Document (deleting an incoming line / incoming Document lowers
      stock; deleting an outgoing one never does).
- A change that does not lower stock is always allowed, even when the Good is already negative (so
  stock can be received to recover a negative Good).
- Error: the change is not saved and a toast says there is not enough stock, with the quantity in
  stock (and the Good's name when known); text in all 11 locales.

## Non-goals / anti-goals

- No change when the switch is on; no migration of Goods that are already negative.
- Stock stays derived (incoming minus outgoing); no stored balance, no schema change.
- Not checked: backup restore, cloud sync, Excel import (no stock), deleting a Good (its lines go).
- The date of a Document does not matter (stock is a running total, not per date).

## Constraints

- All writes go through
  `DocumentUseCases.insertTransaction/updateTransaction/deleteTransaction/delete`;
  the rule lives there (like Unique barcode), reading the setting of the transaction's `storeId`.
- Stock of a Good is read as sum (incoming) − sum (outgoing) with
  `DocumentTransactionRepository.getSumQuantityByGoodId(type, goodId)`; compare with a small
  tolerance (`< -1e-9`) so 0.1 + 0.2 − 0.3 is not "negative".
- Flows that write several things must check **before** the first write: quick insert (it creates a
  Document first) and the Save Good transaction edit (it saves the Good and Document first), so a
  rejected change leaves no empty Document and no half-saved state.
- `DocumentUseCases.deleteTransaction` needs the transaction (type, good, quantity), so its
  signature
  changes from the id to the `DocumentTransaction` (one caller).
- No new dependency; generated files via build_runner; 11 locale files; follow AGENTS.md.

## Approaches

- **Check in `DocumentUseCases` (chosen):** one place covers every current and future entry point;
  the UI only shows the error.
- Check in each cubit: simpler per screen but easy to miss a flow (six entry points today).
- Database trigger or constraint: strongest, but needs a schema migration (risky here) and cannot
  express the per-Store switch.

## Design

- New exception `InsufficientStockException({int goodId, String? goodName, double available})` in
  `lib/domain/exception/`.
- `DocumentUseCases` gets a private check that, for a list of (goodId, delta) pairs, rejects when
  delta < 0 and stock + delta < -1e-9, only when the Store's switch is off. Used by insert (delta =
  ±quantity), update (new effect − stored effect; the stored line comes from `getTransactions`),
  `deleteTransaction` and `delete(documentId)` (sum per Good of the Document's lines when it is
  incoming).
- Presentation: a `BaseState` error (`InsufficientStockError`) emitted by
  `GoodsCubit.addTransaction`,
  `SaveDocumentCubit` (add via scan or dialog, delete line), `DocumentsCubit` and `HomeCubit`
  (delete
  Document), and `SaveGoodCubit` (quick insert, transaction edit); each view shows the toast
  `error_negative_stock` ("Not enough stock. In stock: %s", quantity formatted with the Store's
  decimals).
- Settings UI: a `SettingsSwitchItem` "Allow negative quantity in stock" with the usual hint, in the
  Quantity field card; cubit method `onAllowNegativeStockChanged(bool)`.
- Docs: replace the "negative stock is allowed, do not add a check" sentence in `BUSINESS_LOGIC.md`
  with the rule; note it in `ARCHITECTURE.md`.

## Left to the builder

- Exact wording of the strings; how the batch-scan loop continues after a rejected scan (keep
  scanning, show the toast).
- Tests: use-case tests with fake repositories (add, edit up/down, delete line, delete Document,
  already-negative Good, switch on, other Store, float tolerance) and settings/cubit tests.
