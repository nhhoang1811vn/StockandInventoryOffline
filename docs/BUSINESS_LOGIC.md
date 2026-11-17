# Business Logic

Only behaviour verified in source. Terms: see the glossary in [../CONTEXT.md](../CONTEXT.md).
Schema: [DATABASE.md](DATABASE.md).

## Data relationships

- Everything is scoped to a **Store** (`storeId`), except `PaymentCategory`.
- A **Group** can contain Groups and Goods (`groupId`); `Good.groupId == null` means root level
  (`lib/data/db/db_helper.dart`, `getGoodsByGroupId`).
- A **Document** belongs to a Store and has one counterparty: supplier if `incoming`, customer if
  `outgoing`. `Document.personId` maps to `supplierId` or `customerId` by type
  (`lib/domain/entity/document.dart`).
- A **Transaction** links a Document and a Good with `quantity` and `price`.
- A **Payment** belongs to a Store and optionally links a Wallet, Category, Document, Supplier,
  Customer (`lib/domain/entity/payment.dart`).

## Stock

- Quantity per good = sum of `incoming` transaction quantities − sum of `outgoing`
  (`DBHelper.getGoods`, `getGoodByBarcode`). It is not stored and not updated on write.
- Negative stock is allowed (owner-confirmed). No check exists when adding an outgoing
  transaction (`lib/presentation/pages/save_document/bloc/save_document_cubit.dart`,
  `saveThenAddTransaction`). Do not add one unless requested.
- Low stock: a good is low when `minQuantity != null && quantity < minQuantity`
  (`lib/core/services/low_stock_service.dart`). `MainPage` shows a notification when any good is
  low and `MinimumQuantitySettings.showAlert` is enabled
  (`lib/presentation/pages/main/main_page.dart`).
  Display options live in `MinimumQuantitySettings` (`showInItem`, `showInList`, `color`,
  `showAlert`).

## Documents and payments

- Document amount = sum (`quantity * price`) over its transactions; document quantity = sum of
  quantities. Paid = sum of linked payment amounts (`DBHelper.getDocuments`). Outstanding = amount −
  paid
  is implied. Debt reports (`lib/data/report_data/debt_of_*_report_data.dart`) take the selected
  store's
  suppliers / customers and the documents in the chosen date range (incoming for suppliers, outgoing
  for
  customers), group by `personId`, and show amount, paid and remaining = sum (amount − paid).
- `Documents.paymentStatus` exists as a column but is not used in Dart code outside `DBHelper`
  (the matching line in `lib/presentation/pages/save_document/bloc/save_document_cubit.dart` is
  commented out).
- Auto document number: per store counter `AutoDocumentName<storeId>` in preferences, incremented
  in `DocumentUseCases.insert`; `DocumentsCubit.getAutoDocumentNo` reads it
  (`lib/data/app_settings.dart`, `lib/presentation/pages/documents/bloc/documents_cubit.dart`).
  Generated name = localized `document_name_no` (en-US: `"No."`) immediately followed by the next
  counter value, e.g. `No.1`; the counter starts at 1
  (`lib/presentation/pages/documents/documents_view.dart`,
  `lib/presentation/pages/save_good/components/save_good_form.dart`,
  `assets/translations/en-US.json`).
  The user can reset it from `lib/presentation/pages/settings/general/settings_general_page.dart`.
- Saving a document requires a non-empty name (`formz` `NameInput`, `save_document_cubit.dart`).
- Adding a good by barcode scan (`findGood`): if found, either prompts for quantity (batch mode
  `MANUAL`) or adds quantity 1 at the good's purchase price (incoming) or sale price (outgoing); if
  not found, opens the save-good page with the barcode prefilled.

## Goods

- Barcodes may repeat (UNIQUE removed in migration 7); `getGoodByBarcode` is not limited to the
  selected store. `SameBarcodeException` exists but is not used.
- Excel/CSV import (`GoodsCubit.importGoodsFromExcel`): `.csv` and Excel files are accepted, a
  header row is detected and skipped, rows with an empty name are skipped; each
  remaining row is inserted as a new Good in the selected store and current group. No update or
  de-duplication. Column mapping is user-defined (`ExcelColumnMapping`).
- Export: goods of the current group as `.xlsx` (`GoodsCubit.exportGoodsToExcel`).

## Stores

- The last store cannot be deleted. Deleting the selected store selects the first remaining one
  (`lib/domain/usecase/stores/stores_usecases.dart`).
- First launch with no store goes to onboarding, which creates a Store and selects it
  (`lib/presentation/pages/onboarding/bloc/on_boarding_cubit.dart`).

## Free tier and Pro

- Limits: `FreeLimits` — customers 5, suppliers 5, stores 2, wallets 2
  (`lib/domain/free_limits.dart`).
- Each list cubit checks `count < limit || await RevenueCatService.isPro()` before opening the add
  form, else emits `OpenBuySubscriptionDialogState`
  (under `lib/presentation/pages/`: `customers/bloc/customers_cubit.dart`,
  `suppliers/bloc/suppliers_cubit.dart`, `stores/bloc/stores_cubit.dart`,
  `wallets/bloc/wallets_cubit.dart`, `home/bloc/home_cubit.dart`).
- Pro entitlement id: `stockandinventory_pro` (`lib/util/revenuecat_purchase_manager.dart`).
- Locked themes: all except blue, green, orange (`AppTheme.isLocked`, `lib/models/app_theme.dart`).
  That check uses `AppSettings.isPro()`, whose backing field is never set (initialisation is
  commented out in `lib/data/app_settings.dart`), and nothing in `lib/` assigns it, so it always
  returns `false`: locked theme options in
  `lib/presentation/pages/settings/view/settings_view_page.dart` stay locked even for Pro users.
- There are no other Pro-gated features (owner-confirmed): only the four limits above and the
  locked themes. `menu_page.dart` only shows a premium badge for Pro users (cosmetic).

## Reports

11 types (`lib/domain/entity/report_type.dart`): list of goods, list of documents, debts by
supplier, debts by customer, inbound payments, outbound payments, list of wallets, customer
payments, supplier payments, re-order, good info. Built by `ReportDataFactory`
(`lib/data/report_data/report_data_factory.dart`); export to Excel or PDF.

## Account, backup, sync

- A Firebase anonymous user is created at startup. Linking to email/Google/Apple uses
  `linkWithCredential`; direct email/Google/Apple sign-in and email sign-up also exist
  (`lib/presentation/pages/login/auth_cubit.dart`). `downloadUserData` fetches the cloud file and
  replaces
  local data.
- Upload: DB → JSON → `2026/<uid>/data.json`. Download replaces local data through
  `DbService.importFromFile`.
- Sign-out signs in anonymously again and **deletes the local database**
  (`lib/presentation/pages/menu/bloc/menu_cubit.dart`).
- Realtime DB push (`DbServiceRealtime.syncLocalToNetwork`): assigns a 6-char `networkId` to stores
  without one, computes goods/document quantities in memory, writes membership entries for the
  current uid as `"admin"`. Purpose (owner-confirmed): push local data to the
  Online app's Realtime Database. Context: `docs/adr/0003-keep-home-migration-banner.md`.

## Passcode

When enabled, `MainPage` shows a lock screen and compares the entered code with the stored one
(`lib/presentation/pages/main/main_page.dart`, `_showLockScreen`).

"Unlock with fingerprint" (General Setting, `EnableFingerprint`) is shown only while the passcode is
on and the device has an enrolled biometric (`BiometricAuthService.isAvailable`). Enabling it needs
one successful scan. When on, `_showLockScreen` prompts for the fingerprint as soon as the lock
screen opens (and from the keypad's fingerprint button); success unlocks, any failure or cancel
leaves the passcode keypad usable. Turning the passcode off turns fingerprint off.

"Lock after N minutes of inactivity" (General Setting row, always visible, no on/off switch;
`AutoLockMinutes` default 30, range 1–1440) re-locks the app after N minutes without a touch. It has
no effect when the passcode is off. `AppLockService` (`lib/core/services/app_lock_service.dart`)
keeps the idle clock (updated by a `Listener` around the app in `lib/app.dart`), checks every 10
seconds and on app resume (background time counts), and shows the same lock screen as the cold start
over any open screen; it is active only after `MainPage` has started it. The rule is
`shouldAutoLock` (`lib/core/services/app_lock_rules.dart`). Unlocking resets the clock.

## Image settings

General Setting (Android/iOS only) holds two values used by every image pick/capture
(`EntityImagePicker`, `lib/util/entity_image_picker.dart`):

- Image size: 256–2048 px, default 512, one value for width and height. It is applied only when the
  image is compressed (`compressImageBytes`), so stored images are at most size × size.
- Show crop window: default on. When off, the picked image is center-cropped to a square without
  the cropper.

Existing stored images are not resized. Design:
`docs/superpowers/specs/2026-11-17-image-size-setting-design.md`.
