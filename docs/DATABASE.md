# Database

Source of truth: `lib/data/db/db_helper.dart` (`DBHelper`). Do not rely on this file over the code
when they differ — fix this file.

## Engine and location

- `sqflite`, file `main.db`, schema `version: 8` (`DBHelper.initDb`).
- Path: `<application documents dir>/main.db`; on Windows
  `<documents>/AppViet_GoodManager/main.db` (`lib/common/path_utils.dart`).
- `DBHelper` is a singleton (`@LazySingleton` plus `factory DBHelper()`), lazily opened.
- `sqflite_common_ffi` is a dependency but `sqfliteFfiInit` / `databaseFactoryFfi` are not used in
  `lib/`. Windows/desktop is not supported (owner-confirmed), so the Windows path above is unused
  leftover code.

## Tables (created in `_onCreate`)

Constants in `DBHelper`; entity classes in `lib/domain/entity/`.

| Table                    | Entity                 | Key columns / relations                                                                                                                      |
|--------------------------|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `Stores`                 | `Store`                | name, description, `networkId`, `file`                                                                                                       |
| `Suppliers`, `Customers` | `Supplier`, `Customer` | address, email, phone, taxID, bankDetail, `file`, `storeId` → Stores (cascade)                                                               |
| `Groups`                 | `Group`                | barCode, `storeId` (cascade), `groupId` self-reference (cascade), `files`, `file`                                                            |
| `Goods`                  | `Good`                 | barCode, purchasePrice, salePrice, `minQuantity`, `storeId` (cascade), `groupId` → Groups (cascade), `files`                                 |
| `Documents`              | `Document`             | date, `type` (0 incoming, 1 outgoing), paymentStatus, `storeId` (cascade), `supplierId`/`customerId` (set null)                              |
| `Transactions`           | `DocumentTransaction`  | `documentId`, `goodId`, `storeId` (all cascade), `quantity` REAL, `price` REAL, `documentType`                                               |
| `Payments`               | `Payment`              | date, amount, `type` (0 inbound, 1 outbound), `categoryId`/`walletId`/`documentId`/`supplierId`/`customerId` (set null), `storeId` (cascade) |
| `PaymentCategory`        | `PaymentCategory`      | type, icon (not store-scoped)                                                                                                                |
| `Wallets`                | `Wallet`               | color, `storeId` (cascade)                                                                                                                   |
| `Medias`                 | — (via `Good.files`)   | `goodId` (cascade), `media` BLOB                                                                                                             |
| `Expenses`               | `Expense`              | name, date, amount, `storeId`; created but not part of backup/restore                                                                        |

Enum values are stored as the enum `index` (`DocumentType`, `PaymentType`). Dates are stored as
epoch milliseconds in `createdDate`, `updatedDate`, `date`.

## Entity mapping

Hand-written: each entity has `Entity.map(dynamic row)` and `toMap()` over `BaseModel`
(`lib/domain/entity/base_model.dart`). No ORM. `json_serializable` is used only for settings models
stored as JSON in preferences (for example `lib/domain/entity/minimum_quantity_settings.dart`), not
for table rows.
Computed, non-persisted fields: `Good.quantity`, `Document.quantity/amount/paid`,
`Supplier/Customer.numberDocument` (filled by `DBHelper` queries).

## Migrations

`DBHelper.migrationScripts`: `Map<int, List<String>>` of raw SQL, run for
`oldVersion+1 … newVersion` in `_onUpgrade`.

| Ver | Change                                                                                                               |
|-----|----------------------------------------------------------------------------------------------------------------------|
| 2   | `Transactions.quantity` INT→REAL via temp table; create `Medias`                                                     |
| 3   | Drop and recreate `Payments` (drops rows); `CREATE IF NOT EXISTS PaymentCategory` (with `color`; no-op if it exists) |
| 4   | Create `Wallets`; recreate `Payments` and `PaymentCategory` (drops existing rows)                                    |
| 5   | `Goods.minQuantity`                                                                                                  |
| 6   | Rebuild `Groups` (removes `groupId` FK); `Stores.networkId`                                                          |
| 7   | Rebuild `Goods` without UNIQUE on `barCode`                                                                          |
| 8   | Add `file` to `Groups`, `Suppliers`, `Customers`, `Stores`                                                           |

Note: `_onCreate` defines the *current* shape directly; `Groups` created there has
`groupId` FK with cascade, while the v6 migration creates `Groups` without it. Existing installs
upgraded from < v6 therefore differ from fresh installs in that constraint.

## Known risks (verified in code)

1. `_onUpgrade` and `_onCreate` are `void … async` (`lib/data/db/db_helper.dart`), so sqflite cannot
   await
   them; queries can start before migrations finish.
2. `migrationScripts[i]!` throws if a version has no entry. `onDowngrade` is an empty callback.
3. `PRAGMA foreign_keys = ON` is executed (not awaited) only inside some delete methods, never in
   `onConfigure`. Cascades and set-null behaviour depend on that having run on the connection.
4. `getGoodByBarcode` has no `storeId` filter.
5. Stock quantities and counts are computed with per-row queries (`getGoods`, `getSuppliers`,
   `getDocuments`).
6. `DBHelper.reset()` deletes the database file (used by sign-out,
   `lib/presentation/pages/menu/bloc/menu_cubit.dart`).

## Backup and restore (`lib/data/db_service.dart`)

- Export: `stock_inventory_backup_<ddMMyyyy_HH_mm>.json` in the documents directory, with
  `meta.version = 1` and JSON keys `stores`, `suppliers`, `customers`, `groups`, `goods`,
  `documents`,
  `documentTransactions`, `payments`, `paymentCategories`, `wallets`, `media` (BLOB → base64).
  `Expenses` is excluded.
- Import: in one transaction, clears Transactions, Goods, Groups, Suppliers, Customers,
  PaymentCategory, Wallets, Payments, Medias and Stores, then inserts with
  `ConflictAlgorithm.replace`. `Documents` is not in the explicit delete list. `meta.version` is
  not checked.
- Cloud copy: `2026/<uid>/data.json` in Firebase Storage
  (`lib/presentation/pages/login/auth_cubit.dart`,
  `lib/presentation/pages/menu/bloc/menu_cubit.dart`,
  `lib/presentation/pages/settings/data/settings_data_page.dart`).
- Realtime DB push: `lib/data/realtime/db_service_realtime.dart` (one-way, local → network).
  Database rules: UNKNOWN (no rules file in the repo).

## Checklist for a schema change

1. Bump `version` in `initDb` and add `migrationScripts[N]`. Never edit older entries.
2. Update `_onCreate` to the new shape.
3. Update the entity `map`/`toMap` and the queries in `DBHelper`.
4. Update export/import in `lib/data/db_service.dart` and the realtime entity mapping if the table
   is synced.
5. Update this file and test an upgrade from the previous version.
