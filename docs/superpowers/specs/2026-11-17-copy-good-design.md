# Copy a Good — design (short)

## Intent and why
Users often need a new Good that is almost the same as an existing one (a variant). Retyping name,
prices, barcode and picture is the cost. Long-press a Good in the Goods list → **Copy** → pick the
Store and Group → the Save Good screen opens pre-filled → the user adjusts and saves. Saving stays
in `save_good`; Copy itself creates nothing.

## Goals
- New option "Copy" in the Good long-press menu (`GoodsView.onLongPressedGood`), next to Move to
  group, History, Delete.
- Before opening `save_good`, a dialog lets the user choose the Store and the Group of the new
  Good. Defaults: the source Good's Store and Group.
- The pre-filled Good keeps: description, barcode (owner decision: copied as is), purchase price,
  sale price, min quantity, pictures (owner decision). Name is the source name + `" (copy)"`
  (owner decision, literal text, not translated).

## Non-goals / anti-goals
- Nothing is written to the database until the user presses Save in `save_good`; cancelling leaves
  no trace.
- Stock quantity and Document/Transaction history are not copied (quantity is derived and starts
  at 0).
- No change to Move to group / History / Delete, or to how `save_good` saves.
- Does not switch the selected Store. If the user picks another Store, the saved Good will not
  appear in the current list; no extra navigation or toast.

## Constraints
- Follow AGENTS.md: logic in the cubit, widgets only render; reuse existing screens; 11 translation
  files edited directly; codegen after DI changes; no new dependency; update docs.
- `select_group` is currently fixed to `AppSettings.getSelectedStoreId()`
  (`select_group_cubit.dart:27`), so it must be able to list another Store's groups.
- Barcodes are not unique in this app (CONTEXT.md), so copying one is allowed.

## Approaches
- **A (chosen):** Dialog with a Store dropdown and one Group row; tapping the Group row opens the
  existing `select_group` tree page. Reuses the tree picker; same UI as "Move to group".
- B: Dialog with two dropdowns, Group as a flat list. Rejected: nested groups read poorly when
  flattened and it needs new path-building code, while a tree picker already exists.

## Design (my calls)
- **Menu:** add `context.tr("action_copy")` (new key, all 11 locales) to the `items` list in
  `onLongPressedGood`, handled like the other entries.
- **Dialog:** new widget `lib/presentation/pages/goods/component/copy_good_dialog.dart`
  (StatefulWidget holding only the current selection). Title = the new key; Store dropdown
  (label `select_store`); Group row (label `group`, shows the group name or `no_group`);
  OK / Cancel (`ok`, `cancel`). Returns `{storeId, groupId}` or null.
  - Changing the Store resets the Group to "No group" (old group belongs to another Store).
  - Tapping the Group row pushes `Pages.select_group` with `{"id": null, "groupId": currentGroupId,
    "storeId": selectedStoreId}` and reads `groupId` (and the new `groupName`, below) from the result.
- **`select_group` changes (additive, old callers unaffected):** route passes `args["storeId"]`
  (may be absent → null) to `SelectGroupPage`; `SelectGroupCubit.init(id, groupId, storeId)` uses
  `storeId ?? AppSettings.getSelectedStoreId()`; the pop result also includes `"groupName"`
  (null for "No group"); existing callers read only `groupId`.
- **`GoodsCubit`:**
  - inject `StoresUseCase` (the real class name, `lib/domain/usecase/stores/stores_usecases.dart`); `Future<List<Store>> getStores()` for the dropdown;
    `Future<String?> getGroupName(int? groupId)` for the default group label (via `groupsUseCase.getById`).
  - `onCopyGood(Good source, int storeId, int? groupId)`: builds a new `Good` (id null) from the
    kept fields above with `storeId`/`groupId` from the dialog, `files` as a new list, then emits the
    existing `OpenSaveGoodPageState(copy)`. Field mapping lives in a small pure static function so
    it can be unit-tested. `GoodsView`'s existing listener already opens `save_good` and reloads the
    list on return.
- **Copy menu availability:** shown wherever the Good long-press menu is shown today (including
  selection mode), no special-casing.
- **Docs:** `docs/BUSINESS_LOGIC.md` (Goods: copy rules above); mention the new `storeId` argument of
  `select_group` wherever routes/args are documented.
- **Verification:** codegen (DI changed), `flutter analyze`, a unit test for the copy mapping
  (creates `test/`), and a manual run: copy within the same Store/Group, copy into another Store
  (group list switches), cancel in the dialog, cancel in `save_good`.

## Left to the builder
Exact dialog layout and wording of the new strings in the other 10 locales, where the new unit test
file lives, and how to show the group name while the default name is still loading.
