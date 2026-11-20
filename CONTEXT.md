# StockandInventory — Project Context

Local/guest-first stock and inventory app (Dart package `good_manager`, see `pubspec.yaml`).
Visual language follows the Online version; this app remains a separate product
(`docs/adr/0001-online-repo-as-visual-source.md`).

This file is the entry point. Detail lives in the documents listed in [References](#references).
Anything not verified in source is marked **UNKNOWN**. File paths are relative to the repository
root.

## Language

Use these terms in code, UI copy and docs.

**Store**: A local inventory workspace. _Avoid_: workspace, shop, warehouse

**Good**: A stockable item. _Avoid_: product, item

**Group**: A folder of goods (groups can nest via `groupId`).

**Document**: An incoming or outgoing stock movement. _Avoid_: order, invoice, receipt

**Transaction**: One line of a Document (good, quantity, price). Table `Transactions`.

**Wallet**: A money account used to record payments. _Avoid_: bank, account, cash register

**Payment**: Money inbound or outbound against a wallet. _Avoid_: transaction

**Pro**: The RevenueCat entitlement `stockandinventory_pro`; lifts free-tier limits.

**Online version**: Stock Inventory Online — visual and information-architecture reference only,
not this app's runtime. _Avoid_: cloud app, v2, collaboration app (when meaning the UI source)

**This app / StockandInventory**: The local/guest-first listing.
_Avoid_: offline app (in user-facing copy unless contrasting with the Online version)

## Project overview

- Stock/inventory manager: stores, goods, groups, suppliers, customers, stock documents,
  wallets, payments, reports. (`lib/domain/entity/`)
- SQLite is the source of truth. Firebase Anonymous Auth is signed in at startup (`lib/main.dart`).
  Cloud backup/restore and a one-way Realtime Database push are optional.
- Version: `1.0.94+114` (`pubspec.yaml`).
- Platforms: Android and iOS (built in CI, `codemagic.yaml`) and Windows (debug build and launch
  verified with Visual Studio "Desktop development with C++"; not built in CI). macOS, Linux and web
  folders are
  unsupported scaffolding. On Windows `sqflite` runs through `sqflite_common_ffi` (`lib/main.dart`);
  RevenueCat (Pro is always off), Crashlytics, Analytics, notifications, Google/Apple sign-in, image
  crop/compress and camera capture are disabled via `isMobilePlatform`
  (`lib/common/platform_support.dart`).
  The barcode scanner (`mobile_scanner`) is not supported on Windows.

## Technology stack

| Concern       | Package                                                                            |
|---------------|------------------------------------------------------------------------------------|
| State         | `flutter_bloc` (Cubit), `freezed`, `formz`                                         |
| DI            | `get_it`, `injectable` (+ `injectable_generator`)                                  |
| Database      | `sqflite`                                                                          |
| Key-value     | `shared_preferences` (via `lib/common/storage/`), `hive` (box `settings`)          |
| Backend       | `firebase_core/auth/storage/database/analytics/crashlytics`                        |
| Sign-in       | `google_sign_in`, `sign_in_with_apple`, email/password (`firebase_auth`)           |
| Purchases     | `purchases_flutter`, `purchases_ui_flutter`                                        |
| i18n          | `easy_localization` — 11 locales, JSON in `assets/translations/`                   |
| Files/reports | `csv`, `archive`, `xml`, `pdf`, `printing`, `file_picker`, `share_plus`            |
| Scanning      | `mobile_scanner`, `camera`                                                         |
| Biometrics    | `local_auth` (fingerprint unlock, `lib/core/services/biometric_auth_service.dart`) |

Declared in `pubspec.yaml` but not imported anywhere in `lib/`: `camera_windows`,
`desktop_webview_auth`, `fluttertoast`, `open_file`. Do not build on them.

Dart and Flutter SDK versions: see [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md#prerequisites).

## Architecture overview

`Presentation (Cubit) → UseCase → Repository → DBHelper (raw SQL)`. Details:
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Folder structure

```
lib/
  main.dart, app.dart, app_cubit.dart   startup, MaterialApp, theme/language cubit
  common/ constant/ util/ models/       paths, storage wrapper, constants, helpers, Hive models
  core/services/                        notification_service, low_stock_service
  data/                                 db/db_helper.dart, db_service.dart, realtime/, report_data/, app_settings.dart
  di/                                   di.dart, app_module.dart, di.config.dart (generated, tracked)
  domain/                               entity/, usecase/, free_limits.dart, exception/
  repo/                                 one repository per aggregate
  presentation/                         router.dart, pages/<feature>/{bloc/,...}, widget/, dialog/, criteria/, markdown/,
                                        blocs/ (add_quantity_and_price), models/, utils/, review_manager.dart
assets/translations/                    locale JSON (edited directly)   translation/  legacy python + xlsx
docs/adr/                               architecture decision records
```

## Main modules

| Module       | Responsibility                                                           | Where                                            |
|--------------|--------------------------------------------------------------------------|--------------------------------------------------|
| Entities     | Data models with hand-written `map()`/`toMap()`                          | `lib/domain/entity/`                             |
| Use cases    | Thin orchestration over repositories; a few rules                        | `lib/domain/usecase/`                            |
| Repositories | Pass-through to `DBHelper`; set timestamps; read selected store          | `lib/repo/`                                      |
| DBHelper     | Schema, migrations, all SQL                                              | `lib/data/db/db_helper.dart`                     |
| AppSettings  | Static facade for preferences (selected store, filters, theme, passcode) | `lib/data/app_settings.dart`                     |
| Backup/sync  | JSON export/import; Realtime DB push                                     | `lib/data/db_service.dart`, `lib/data/realtime/` |
| Reports      | 19 report types                                                          | `lib/data/report_data/`                          |
| Pages        | One folder per feature with its cubit                                    | `lib/presentation/pages/`                        |

## State management conventions

Cubit + freezed state, created per route by `BlocProvider(create: (_) => getIt<XCubit>())`.
Exceptions: `AuthCubit` and `WalletsCubit` use plain (non-freezed) state classes; `AppCubit` is not
injected; the add-quantity cubit is built inside a widget.
UI actions are signalled through a `BaseState` field inside the state
(`lib/presentation/pages/base/base_state.dart`).
Details: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Dependency injection

`injectable` annotations; generated `lib/di/di.config.dart`. Repositories, use cases and `DBHelper`
are `@LazySingleton`; cubits are `@injectable` (factory). Regenerate with `build_runner`
(see [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)).

## Data flow

User action → page → cubit method → use case → repository → `DBHelper` → SQLite → entity →
`emit(state.copyWith(...))` → `BlocBuilder`/`BlocConsumer`.
Selected store comes from `AppSettings.getSelectedStoreId()`, not from a parameter, in
repositories and many cubits.

## Database overview

SQLite file `main.db`, schema version 8, 12 tables. See [docs/DATABASE.md](docs/DATABASE.md).

## Backend integrations

- Firebase Auth: anonymous at startup; can be linked to email, Google or Apple, or the user can sign
  in /
  sign up directly, after which cloud data is downloaded
  (`lib/presentation/pages/login/auth_cubit.dart`).
- Firebase Storage: backup file `2026/<uid>/data.json`.
- Firebase Realtime Database: user lookup index and one-way store sync (`lib/main.dart`,
  `lib/data/realtime/db_service_realtime.dart`).
- Analytics (route observer, a few events) and Crashlytics (`lib/main.dart`, `lib/app.dart`).
- RevenueCat: entitlement check (`lib/util/revenuecat_purchase_manager.dart`).

## Important business rules

Summary; full list in [docs/BUSINESS_LOGIC.md](docs/BUSINESS_LOGIC.md).

- Stock quantity is derived: sum (incoming) − sum (outgoing) per good. It is never stored.
- Free limits: 5 customers, 5 suppliers, 2 stores, 2 wallets (`lib/domain/free_limits.dart`).
- The last remaining store cannot be deleted.
- Barcodes are not unique.

## Technical constraints

Known risks are listed in full in [docs/DATABASE.md](docs/DATABASE.md) and
[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md). The ones to know before editing:

- Migrations are not awaited by sqflite and foreign keys are not enabled globally.
- No automated tests and no CI beyond Codemagic builds.
- `*.freezed.dart` and `*.g.dart` are git-ignored; run codegen after a fresh checkout.

## References

- [AGENTS.md](AGENTS.md) — rules for AI coding agents
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/BUSINESS_LOGIC.md](docs/BUSINESS_LOGIC.md)
- [docs/DATABASE.md](docs/DATABASE.md)
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)
- [docs/adr/](docs/adr/) — decisions on the Online app as visual source, navigation shell, migration
  banner
