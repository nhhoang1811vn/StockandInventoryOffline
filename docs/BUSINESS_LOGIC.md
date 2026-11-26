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
- Negative stock is allowed by default (owner-confirmed). Each Store can turn it off with "Allow
  negative quantity in stock" (`GoodPropertiesSettings.allowNegativeStock`, Quantity field section).
  When off, `DocumentUseCases` (`insertTransaction`, `updateTransaction`, `deleteTransaction`,
  `delete`, and `ensureTransactionAllowed` for flows that write several things) rejects, before
  any write, a change that lowers a Good's stock and leaves it below zero
  (`InsufficientStockException`, toast "Not enough stock. In stock: N"). Covered: adding an outgoing
  line, raising an outgoing or lowering an incoming quantity, deleting an incoming line, deleting an
  incoming Document (judged per Good over all its lines). A change that does not lower stock is
  always allowed, so a Good that is already negative can be restocked. Stock = incoming sum −
  outgoing sum with a `1e-9` tolerance. Quick insert and the Save Good transaction edit check first,
  so a rejected change leaves no Document or half-saved Good. Each check and the write after it run
  one at a time, so two quick scans of the last unit cannot both pass. Backup restore is not checked.
- Low stock: a good is low when `minQuantity != null && quantity < minQuantity`
  (`lib/core/services/low_stock_service.dart`). `MainPage` shows a notification when any good is
  low and `MinimumQuantitySettings.showAlert` is enabled
  (`lib/presentation/pages/main/main_page.dart`).
  Display options live in `MinimumQuantitySettings` (`showInItem`, `showInList`, `color`,
  `showAlert`).

## Good properties

- Each Store can hide Image, Barcode, Description, Purchase price, Sale price and Minimum quantity
  (`GoodPropertiesSettings`, default all shown). Purchase/Sale price means the Good's own default
  prices: they are hidden in the save-good form, goods rows, the goods summary totals, the
  list-settings sheet and Excel. Document transaction prices and amounts, and reports, are not
  affected, except when a Document line is created: for an incoming Document the Purchase price
  decides and for an outgoing one the Sale price decides (`GoodPropertiesSettings.showPriceFor`).
  If it is hidden, the add-quantity dialog, the quick-insert dialog and the transaction edit form
  show only the quantity, and a new line gets price `null` (stored as no price) instead of the
  Good's hidden default price (`defaultPriceFor`); batch barcode scan follows the same rule.
  The Good rows on the Save Document page follow the toggles too: image (Image), barcode (Barcode)
  and price + line amount (Purchase/Sale price by Document type). Stored prices are not changed.
  The Document amount follows the same rule by Document type: the Save Document summary bar and
  every `DocumentItemRow` (list, history, Home, search) hide it, and the Documents list summary
  hides "Amount" when any Document type in the list has its price hidden
  (`GoodPropertiesSettings.showPriceForAll`). The Home incoming/outgoing totals hide the amount
  the same way. The Document CSV/PDF table (`buildDocumentTable`) drops the Description, Barcode,
  price and amount columns of hidden properties. Report columns are dropped centrally in
  `ReportDetailCubit` through `ColumnInfo.visibleWhen` / `applyColumnVisibility`:
  Barcode (good info, list of goods, reorder), Purchase price (good info, reorder price and
  amount, cost, supplier debt amount, purchase reports' amount), Sale price (good info, customer
  debt amount, sales reports' amount), profit needs both prices, and the list-of-documents amount
  needs both. Payment columns, `paid`/`remaining` in debt reports, wallets and the payment status
  badge are not affected. Hidden means not displayed: stored values are kept and reappear when
  turned
  back on.
- Hidden properties disappear from the save-good form, goods list/grid rows, search results, the
  list-settings and sort sheets (barcode sort is ignored while Barcode is hidden), and the Excel
  column mapping, import and export.
- Minimum quantity is also a master switch: when off, the effective visibility is off regardless of
  `MinimumQuantitySettings`, and the low-stock notification, the Home low-stock tile, the row
  low-stock indicator and the Reorder report entry are all disabled. `MinimumQuantitySettings` is
  not modified.

## Quantity field

- Each Store sets "Number of digits after decimal point" (`GoodPropertiesSettings.quantityDecimals`,
  0..6, default 2) in the "Quantity field" section of Good properties.
- Display: every quantity (Good and Document rows and totals, history, dialogs including the "In
  stock" line, minimum quantity, reports and their totals, the Document CSV/PDF table) is rounded to
  that many digits and shown without trailing zeros (2 digits: 5.12, 5, 5.2). Reports keep thousands
  separators, and their money columns are unchanged. Stored values are never rounded.
- Input: the quantity fields (Save Good transaction quantity and minimum quantity, add-quantity and
  quick-insert dialogs) accept at most that many decimals (digits only at 0) and calculator results
  are rounded to it (a decimal comma is typed as a dot). Excel import and barcode-scan flows are
  not rounded.
- Stock status (out of stock, low stock, reorder) and report totals use the stored values, not the
  rounded text, so a quantity of 0.3 shown as "0" at 0 digits is still in stock.
- Code: `lib/util/quantity_format.dart` (`formatQuantity`, `roundQuantity`,
  `QuantityInputFormatter`), `lib/util/quantity_input.dart`, `StringUtils.getQuantityText`,
  `getQuantityTextForReport` / `formatColumnTotal` (`ColumnInfo.isQuantity`).

## Uniqueness rules

Two per-Store switches in the "Uniqueness" section of Good properties
(`GoodPropertiesSettings.uniqueBarcode`, `uniqueGroupName`), both off by default, so existing
behaviour (duplicates allowed) is unchanged.

- **Unique barcode**: a trimmed barcode may be used by only one Good or Group of a Store. A Good
  cannot take the barcode of another Good or of a Group, and a Group cannot take the barcode of a
  Good or of another Group (`ensureBarcodeUnique`, called from `GoodsUseCases` and
  `GroupsUseCases` insert/update, throws `DuplicateBarcodeException`). An empty barcode never
  conflicts. Save Good and Save Group show "Another Good or Group already uses this barcode".
  Excel import skips the conflicting rows (existing Goods or Groups, or earlier rows of the same
  file).
- **Unique group**: `GroupsUseCases.insert/update` reject a Group whose trimmed name equals,
  ignoring case, the name of another Group of the same Store at any folder level
  (`DuplicateGroupNameException`). The Save Group screen shows "Another Group already has this
  name". Copying a Group goes through Save Group, so the default "(copy)" name is accepted.
- Editing is only blocked when the barcode / name actually changes: a Good or Group that was a
  duplicate before the switch was turned on can still be edited and moved. Turning a switch on does
  not touch existing duplicates. Each Store's own switch applies to its own Goods and Groups. Data
  restored from a backup is not checked.

## Document properties

- Each Store can hide Image (the leading incoming/outgoing icon tile of `DocumentItemRow`, so on
  every list that uses it), Document no, Date & Time and Description (`DocumentPropertiesSettings`,
  key `DocumentPropertiesSettings_<storeId>`, default all shown; page
  `Pages.settings_document_properties`, linked next to Good properties). Hidden means not
  displayed: the Document still gets its auto number and its date, and keeps them if the property
  is turned back on.
- Document no hidden: the save-document field, the PDF/CSV line and the report column are hidden,
  search no longer matches the number, and every place that titled a Document with its number (rows,
  delete confirmation, history, payment rows, save payment) shows the type label (
  "Incoming"/"Outgoing") instead (`DocumentPropertiesSettings.displayName`).
- Date & Time hidden: the save-document and quick-insert fields, the date on the row, the date
  group headers in the Documents list, the PDF/CSV line, the report "date" column and the date
  sort (newest first is used, the saved sort is untouched).
- Description hidden: the save-document and quick-insert fields, the row text, the PDF/CSV line,
  and search no longer matches it.
- Not affected: payment dates and descriptions, the Good-related Document price rules above,
  Sales-by-date report (its "date" column is a grouping, not the Document's date).

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
- Copy (long-press a Good → Copy): a dialog (`CopyDestinationDialog`) picks the Store and Group of
  the
  new Good (default: the source's; changing the Store resets the Group to "No group"). The save-good
  page then opens with an unsaved copy (`buildCopyOfGood`): name + `" (copy)"`, description,
  barcode (copied as is), purchase/sale price, min quantity and pictures. Quantity starts at 0 and
  history is not copied. Nothing is written until Save is pressed.
- Copy a Group (long-press a Group in the Goods list → Copy): same dialog, where the Group row picks
  the **parent** group of the copy. The save-group page opens with an unsaved copy
  (`buildCopyOfGroup`): name + `" (copy)"`, description, barcode, file and files. Only the group
  itself is copied, not its goods or sub-groups. `SaveGroupCubit.init` prefills an unsaved group
  that already has a name. The Search page's group menu has no Copy.

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

19 types (`lib/domain/entity/report_type.dart`): list of goods, list of documents, debts by
supplier, debts by customer, inbound payments, outbound payments, list of wallets, customer
payments, supplier payments, re-order, good info, sales by date, sales by item, sales by customer, sales by month, purchase by date, purchase by item, purchase by
supplier, purchase by month. Built by `ReportDataFactory`
(`lib/data/report_data/report_data_factory.dart`); export to Excel or PDF.

Sales by date (group "Sales" on the Report screen): one row per calendar day in the chosen range,
including days without sales, newest first, plus a Total row. Only outgoing Documents count.
Quantity = sum of Transaction quantity; Amount = quantity × `Transaction.price`; Cost =
quantity × the Good's **current** `purchasePrice` (null or deleted Good → 0); Profit = Amount −
Cost. Because no purchase price is stored per Transaction, editing a Good's purchase price changes
Cost and Profit of past days. Logic: `lib/data/report_data/sales_by_date_rows.dart`.

Sales by item: one row per Good (name A→Z), Good name / Quantity / Amount / Cost / Profit, plus a
Total row; Goods without sales show 0. The date-range sheet has a Group row (default All). All
lists every Good of the store; a chosen Group lists only Goods whose `groupId` equals it (sub-Groups
are not included, Goods without a Group appear only under All). Same Amount/Cost/Profit rules as
Sales by date. Logic: `lib/data/report_data/sales_by_item_rows.dart`.

Sales by customer: one row per Customer of the store (name A→Z, zeros for those who bought nothing)
plus a last "No customer" row for outgoing Documents whose `customerId` is null or matches no listed
Customer, so the Total equals Sales by date / Sales by item for the same range. The date-range
sheet has a Customer row (default All); choosing one Customer shows only that row (no "No
customer" row). Same Amount/Cost/Profit rules as Sales by date. Logic:
`lib/data/report_data/sales_by_customer_rows.dart`.

Sales by month: a "Select year" sheet lists the 5 most recent years (this year and the 4 before it);
the report then covers 1 Jan to 31 Dec of the chosen year (no "end today" cut). Always 12 rows,
months 1–12, zeros for months without sales (including future months); a Document belongs to the
month of its local `date`. Same Amount/Cost/Profit rules as Sales by date. Logic:
`lib/data/report_data/sales_by_month_rows.dart`.

Purchase reports (group "Purchase" on the Report screen: by date, by item, by supplier, by month)
reuse the Sales report code with `DocumentType.incoming` and show only Quantity and Amount
(Amount = quantity × `Transaction.price`; no Cost or Profit). Same row rules as the Sales
counterparts: by date lists every day, by item lists every Good (All or one Group), by supplier lists
every Supplier plus a last "No supplier" row (or one chosen Supplier), by month asks for one of the
5 most recent years and lists months 1–12.

## Backup and Pro

- There are no accounts. Backup is a JSON file exported and imported through `DbService`
  (Settings > Backup and restore). Import replaces local data.
- Pro is a RevenueCat entitlement tied to the store account. The app never calls `Purchases.logIn`;
  RevenueCat keeps the app user id cached on the device. After a reinstall or a new phone the user
  restores Pro from Menu > Restore purchases (`RevenueCatService.restorePurchases`). The RevenueCat
  project setting "Transfer to new App User ID" makes the entitlement follow the restoring user.
- Removed in 1.0.97: sign-up/sign-in, cloud backup (`2026/<uid>/data.json`), the Realtime DB push and
  the Home banner for the Online app (`docs/adr/0004-remove-accounts-and-cloud.md`).

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
