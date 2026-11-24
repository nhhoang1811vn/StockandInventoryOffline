# Allow Negative Stock Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox
> (`- [ ]`) syntax for tracking.

**Goal:** A per-Store switch "Allow negative quantity in stock" (default on); when off, adding,
editing or deleting transactions (and Documents) that would leave a Good with negative stock is
rejected with an error.

**Architecture:** `GoodPropertiesSettings.allowNegativeStock` holds the switch. `DocumentUseCases`
enforces the rule (stock = incoming − outgoing sums, check = stock + change) and throws
`InsufficientStockException`; cubits catch it and emit an `InsufficientStockError` state that each
view shows as a toast.

**Tech Stack:** Flutter, flutter_bloc, freezed/json_serializable, easy_localization.

**Spec:** [docs/superpowers/specs/2026-11-24-negative-stock-design.md](../specs/2026-11-24-negative-stock-design.md)

## Global Constraints

- `allowNegativeStock` default **true**; per Store, in `GoodPropertiesSettings`; old JSON without
  the key reads true.
- Rule applies only when the switch of the transaction's `storeId` is off, and only to a change that
  lowers a Good's stock **and** leaves it below zero; compare with tolerance `< -1e-9`.
- A change that does not lower stock (incoming add, outgoing delete, edits that raise stock) is
  always allowed, also for a Good that is already negative.
- Stock = `getSumQuantityByGoodId(incoming, goodId) − getSumQuantityByGoodId(outgoing, goodId)`; do
  not store a balance; no schema change.
- Check **before the first write** in flows that write several things (quick insert, Save Good
  transaction edit); a rejected change leaves no new Document and no half-saved Good.
- Error toast text `error_negative_stock` = "Not enough stock. In stock: %s" (quantity formatted
  with the Store's decimals), in all 11 locales; no new dependency; generated files via
  build_runner; do not commit unless the user asks.
- `DocumentUseCases.deleteTransaction` takes the `DocumentTransaction` (its only caller changes).

## Review Focus

- A Good that is already negative with the switch off: receiving stock is allowed (even if still
  negative), issuing more is rejected (Task 2 test).
- Float noise: receive 0.1 and 0.2, issue 0.3 → allowed (Task 2 test).
- Editing a line is judged against the **stored** line, not the in-memory object (Task 2 test with a
  mutated object).
- Deleting an incoming Document with several lines for the same Good aggregates them; deleting an
  outgoing Document is never rejected (Task 2 tests).
- A rejected change writes nothing (fake repositories record writes) and a rejected quick insert
  creates no Document (Task 2 and Task 3 tests).

---

## File Structure

- Create `lib/domain/exception/insufficient_stock_exception.dart`.
- Modify `lib/domain/usecase/documents/document_usecases.dart` — the rule.
- Modify `lib/domain/entity/good_properties_settings.dart`, the Good properties cubit/state/page,
  `assets/translations/*.json`.
- Modify `lib/presentation/pages/base/base_state.dart` and the cubits/views listed in Task 3.
- Tests: `test/negative_stock_test.dart`, `test/negative_stock_settings_test.dart`,
  `test/insufficient_stock_message_test.dart`.

---

### Task 1: The switch

**Files:**

- Modify: `lib/domain/entity/good_properties_settings.dart`,
  `lib/presentation/pages/settings/good_properties/bloc/good_properties_{state,cubit}.dart`,
  `good_properties_page.dart`, `assets/translations/*.json` (11)
- Test: `test/negative_stock_settings_test.dart`

**Interfaces:**

- Produces: `GoodPropertiesSettings.allowNegativeStock` (`@Default(true) bool`);
  `GoodPropertiesState.allowNegativeStock`; `GoodPropertiesCubit.onAllowNegativeStockChanged(bool)`;
  translation keys `allow_negative_stock`, `allow_negative_stock_hint`, `error_negative_stock`.

- [ ] **Step 1: Write failing tests** (prefs/Hive setup as in
  `test/quantity_decimals_cubit_test.dart`): default `allowNegativeStock` is true; JSON
  `{"showImage":false}` reads true; `onAllowNegativeStockChanged(false)` saves false for the
  selected Store, leaves other flags and `quantityDecimals` unchanged, bumps
  `goodPropertiesRevision`; another Store still reads true; a fresh cubit `init()` restores false.
- [ ] **Step 2: Run** `flutter test test/negative_stock_settings_test.dart` → Expected: FAIL
  (symbols missing).
- [ ] **Step 3: Implement** entity field, state field, cubit init/save/handler; run build_runner. In
  the page add a
  `SettingsSwitchItem(icon: Icons.inventory_2_outlined, title: allow_negative_stock, subtitle: allow_negative_stock_hint)`
  as the **first** item of the Quantity field card (so the decimals row stays last with
  `isLast: true`).
- [ ] **Step 4: Translations.** Add the three keys to all 11 files next to `decimal_digits_error`
  (en: "Allow negative quantity in stock", "Turn off to block transactions that make stock
  negative", "Not enough stock. In stock: %s"); translate the other ten.
- [ ] **Step 5: Run** the test → PASS; `flutter analyze`; each key appears in 11 files.

---

### Task 2: The rule in `DocumentUseCases`

**Files:**

- Create: `lib/domain/exception/insufficient_stock_exception.dart`
- Modify: `lib/domain/usecase/documents/document_usecases.dart`
- Test: `test/negative_stock_test.dart`

**Interfaces:**

- Consumes: Task 1 `allowNegativeStock`;
  `DocumentTransactionRepository.getSumQuantityByGoodId(DocumentType, int goodId) → Future<double>`,
  `getTransactions(documentId)`, `insert/update/delete`; `DocumentRepository.get(id)`, `delete(id)`.
- Produces:
    -
    `class InsufficientStockException implements Exception { final int goodId; final String? goodName; final double available; }`
    -
    `Future<void> DocumentUseCases.ensureTransactionAllowed(DocumentTransaction transaction, {int? goodId})` —
    insert check when `transaction.id == null`, update check otherwise; `goodId` overrides
    `transaction.goodId` (null with a brand-new Good means stock 0).
    - `insertTransaction`, `updateTransaction`,
      `Future<bool> deleteTransaction(DocumentTransaction item)` and `delete(int documentId)` all
      run the check first and throw before any write.

- [ ] **Step 1: Write failing tests** `test/negative_stock_test.dart` with `Fake` repositories that
  hold lines in memory, sum by type like the real ones and count writes:
    - switch **on** (default): issuing more than stock is allowed.
    - switch **off**: issue 5 with stock 3 → `InsufficientStockException(available: 3)` and zero
      writes; issue 3 with stock 3 → allowed (stock 0); another Store with the switch on is
      unaffected.
    - already negative (stock −2, off): incoming add 1 allowed; outgoing add 1 rejected.
    - tolerance: incoming 0.1 + 0.2 then outgoing 0.3 allowed.
    - edit outgoing 2→3 with stock 1 left (stored 2) rejected; 3→2 allowed; edit incoming 5→1 when 4
      were already issued rejected; 1→5 allowed; the check uses the **stored** line even when the
      passed object was mutated.
    - `deleteTransaction`: incoming line that backs issued stock rejected (no delete call); outgoing
      line always allowed.
    - `delete(documentId)`: incoming Document with two lines of the same Good aggregates (reject
      when the sum exceeds stock); outgoing Document always allowed; nothing deleted on rejection.
    - `ensureTransactionAllowed` with `goodId: null` for a new Good rejects an outgoing line (stock
      0) and accepts an incoming one.
- [ ] **Step 2: Run** `flutter test test/negative_stock_test.dart` → Expected: FAIL.
- [ ] **Step 3: Implement.** Private `_stock(goodId)` = incoming sum − outgoing sum; private
  `_ensure(storeId, [(goodId, goodName, delta)])` throwing when the Store's switch is off and
  `delta < 0 && stock + delta < -1e-9`; effect of a line = `+quantity` for incoming, `-quantity` for
  outgoing; update uses `getTransactions(item.documentId)` to find the stored line by id (delta =
  new effect − stored effect); document delete uses `repository.get(id)` for type/store and
  `getTransactions(id)` for the lines, summing per Good (only for incoming Documents). Good name
  comes from `transaction.good.name` when that late field is set (use try/catch or a nullable
  accessor), otherwise null.
- [ ] **Step 4: Run** the test → PASS; `flutter test` for regressions.

---

### Task 3: Error handling in the app

**Files:**

- Modify: `lib/presentation/pages/base/base_state.dart` (+ a pure message helper),
  `lib/presentation/pages/goods/bloc/goods_cubit.dart` + `goods_view.dart`,
  `lib/presentation/pages/save_document/bloc/save_document_cubit.dart` + `save_document_view.dart`,
  `lib/presentation/pages/documents/bloc/documents_cubit.dart` + `documents_view.dart`,
  `lib/presentation/pages/home/bloc/home_cubit.dart` + `home_page.dart`,
  `lib/presentation/pages/save_good/bloc/save_good_cubit.dart` + `components/save_good_form.dart`
- Test: `test/insufficient_stock_message_test.dart`

**Interfaces:**

- Consumes: Task 2 exception and use case methods.
- Produces:
  `class InsufficientStockError extends BaseState { final InsufficientStockException error; }`;
  `String insufficientStockMessage(InsufficientStockException e, int decimals, String Function(String key) tr)`
  in `lib/presentation/pages/base/` (returns `error_negative_stock` with `%s` replaced by the
  quantity formatted like `formatQuantity`, prefixed by `goodName: ` when known);
  `SaveGoodCubit.canQuickInsert(DocumentType type, double quantity) → Future<bool>` (checks, emits
  `InsufficientStockError` and returns false when rejected).

- [ ] **Step 1: Write failing test** `test/insufficient_stock_message_test.dart`: with
  identity-plus-`%s` translator, `available: 2.5` and 2 decimals → "Not enough stock. In stock:
  2.5"; 0 decimals → "…: 3"; with `goodName: "Cola"` the text starts "Cola: ".
- [ ] **Step 2: Run** the test → FAIL.
- [ ] **Step 3: Implement** the helper and the `InsufficientStockError` state, then catch
  `InsufficientStockException` in each entry and emit it (the toast is
  `ToastUtils.showErrorToast(insufficientStockMessage(...))` in the view listener):
    - `GoodsCubit.addTransaction` (add from the goods list) — emit before the existing failed state.
    - `SaveDocumentCubit.saveThenAddTransaction` (scan and dialog) and
      `deleteTransaction(DocumentTransaction)` (now passes the item; keep scanning after a rejected
      scan).
    - `DocumentsCubit.delete` and `HomeCubit.deleteDocument` (nothing reloads on rejection).
    - `SaveGoodCubit.onSaveClicked`: call
      `documentsUseCases.ensureTransactionAllowed(state.transaction!, goodId: state.item?.id)`
      **before** `insertOrUpdateGood()` when a transaction is present; on rejection emit the error
      and stop.
    - Quick insert (`save_good_form.dart` `saveTransaction`):
      `await cubit.canQuickInsert(type, quantity)` before `insertDocument`; await the transaction
      insert instead of firing it unawaited.
- [ ] **Step 4: Run** the message test, `flutter analyze`, and the whole suite → PASS.
- [ ] **Step 5: Manual check list** (note in the report, not run): switch off, issue more than stock
  from the goods list, by scan, via Save Good, quick insert and the edit screen; delete an incoming
  line and an incoming Document backing issued stock; no empty Document is left after a rejected
  quick insert.

---

### Task 4: Docs and final verification

**Files:**

- Modify: `docs/BUSINESS_LOGIC.md` (replace "Negative stock is allowed … do not add one unless
  requested" with the rule; keep the default and the already-negative behaviour),
  `docs/ARCHITECTURE.md` (one line), `CONTEXT.md` only if a stated fact changes.

- [ ] **Step 1:** Update the docs; link instead of duplicating.
- [ ] **Step 2: Run** `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`,
  `flutter test` → Expected: no new analyzer issues, all tests pass; verify the three keys exist in
  11 locale files.
- [ ] **Step 3:** Report what ran, results and what was not verified (device flows in Task 3 Step
  5).
