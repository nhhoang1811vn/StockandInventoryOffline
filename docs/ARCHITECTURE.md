# Architecture

Current implementation only. Entry summary: [../CONTEXT.md](../CONTEXT.md).

## Layers

```
Presentation  lib/presentation/   pages, widgets, Cubits (bloc/ folders), router
Domain        lib/domain/         entities, use cases, FreeLimits
Repository    lib/repo/           one class per aggregate
Data          lib/data/           DBHelper (SQL), DbService (backup), realtime/, report_data/, AppSettings
```

Dependency flow: Cubit → UseCase → Repository → `DBHelper` (`lib/data/db/db_helper.dart`).
Registered with `@LazySingleton` / `@injectable` (`lib/domain/usecase/**`, `lib/repo/*.dart`).

Observed deviations from strict layering:

- Repositories read `AppSettings.getSelectedStoreId()` (static) instead of receiving a store id
  (`lib/repo/goods_repository.dart`, `lib/repo/documents_repository.dart`).
- `DocumentUseCases.insert` increments the auto document number through `AppSettings`
  (`lib/domain/usecase/documents/document_usecases.dart`).
- `SettingsDataCubit` constructs `DbServiceRealtime` itself from injected repositories
  (`lib/presentation/pages/settings/data/bloc/settings_data_cubit.dart`).
- `AuthCubit` and `MenuCubit` call `DBHelper` / `DbService` / `FirebaseStorage` directly
  (`lib/presentation/pages/login/auth_cubit.dart`,
  `lib/presentation/pages/menu/bloc/menu_cubit.dart`).
- `DbService` (backup) and `DbServiceRealtime` are not registered in DI.
- Widgets contain logic in places, so "no business logic in widgets" (AGENTS.md) is a target, not
  the
  current state: `home_page.dart` calls `getIt<SettingsDataCubit>().syncToRealtimeDB()`,
  `settings_view_page.dart` reads `AppSettings.isPro()`, `save_good_form.dart` builds a `Document`.
- Not every cubit follows the pattern below: `AuthCubit` and `WalletsCubit` have non-freezed states;
  `AppCubit` is not `@injectable`; the add-quantity cubit is created inside a widget
  (`blocs/add_quantity_and_price/`).

## Startup

`lib/main.dart`, in order: `EasyLocalization.ensureInitialized` → `configureDependencies` →
`Hive.initFlutter` → `PrefStorage.init` + `AppSettings.initialize` → `RevenueCatService.init` →
`availableCameras` → `Firebase.initializeApp` → Crashlytics hooks → `authStateChanges` listener (for
a user with a non-empty email: writes `users_by_email` / `users_by_id` to Realtime DB; then
`RevenueCatService.updateUser`) →
`signInAnonymously` if no user → `runApp(EasyLocalization(MyApp))`.

`MyApp` (`lib/app.dart`) provides `AppCubit` (theme, language, selected tab) and starts at route
`Pages.loading_data`. `LoadingData` runs `AuthCubit.checkStore()` (or `downloadUserData()` when the
global `justLogin` in `main.dart` is true) and then replaces the stack with `Pages.main` (a store
exists) or `Pages.onboarding` (no store) (`lib/presentation/pages/login/loading_data.dart`). On
failure `AuthCubit`
emits `StartupFailure` and the page shows a retry button.

## State management

- `flutter_bloc` Cubits with `freezed` states. Pattern:
  `part 'x_cubit.freezed.dart'; part 'x_state.dart';`
  and `@freezed class XState with _$XState { const factory XState.initial({...}) = _Initial; }`
  (example: `lib/presentation/pages/goods/bloc/goods_state.dart`).
- Cubits are `@injectable` (new instance per `getIt<X>()` call) and are provided per route in
  `lib/presentation/router.dart`.
- A `state` field of type `BaseState` carries one-shot UI signals such as
  `OpenSaveGoodPageState`, `LoadSuccessState`, `OpenBuySubscriptionDialogState`
  (`lib/presentation/pages/base/base_state.dart`). Pages react in `BlocConsumer` listeners.
- Forms use `formz` inputs (for example `NameInput` in `lib/domain/entity/models/name.dart`).
- Async cubit methods guard with `if (isClosed) return;` before `emit`.
- `AppCubit` is not injected; it is created directly in `lib/app.dart`.

## Dependency injection

- `lib/di/di.dart`: `getIt` + `@InjectableInit(initializerName: 'init', asExtension: true)`.
- `lib/di/app_module.dart`: `@preResolve SharedPreferences`.
- `lib/di/di.config.dart` is generated and **tracked in git**.
- `getIt` is used directly in `lib/presentation/router.dart`,
  `lib/presentation/pages/home/home_page.dart`, `lib/presentation/pages/main/main_page.dart`,
  `lib/presentation/pages/onboarding/on_boarding_page.dart`.

## Navigation

- Named routes through one `AppRouter.getRoute` switch (`lib/presentation/router.dart`); names are
  constants in `lib/presentation/pages/pages.dart`.
- Arguments are an untyped `Map` read as `settings.arguments as Map` (`args["isSelection"]`).
- No authentication guard. The only gate is the store check in `LoadingData`.
- Observers: `RouteObserver<PageRoute>` and `FirebaseAnalyticsObserver` (`lib/app.dart`).
- Navigation shell decisions: `docs/adr/0002-match-online-navigation-shell.md`
  (verified in `lib/presentation/pages/main/main_page.dart`: Home, Inventory, a centre Scan button,
  Reports, Settings; four pages in an `IndexedStack`, the scan button is not a page).

## Settings and local storage

`AppSettings` (`lib/data/app_settings.dart`) is a static class. Two stores:

- `PrefStorage` over `SharedPreferences` (`lib/common/storage/`): selected store id and name,
  per-store auto document number, list filter/sort settings, passcode, scanner options.
- Hive box `settings`: theme, language, currency (adapters registered in `AppSettings.initialize`).
- Per-Store Good properties (`GoodPropertiesSettings`, key `GoodPropertiesSettings_<storeId>`, JSON
  in preferences): `AppSettings.getGoodPropertiesSettings({storeId})` /
  `setGoodPropertiesSettings`. Edited at `Pages.settings_good_properties`
  (`lib/presentation/pages/settings/good_properties/`), linked from the Settings page and the menu
  tab. Every save increments `AppSettings.goodPropertiesRevision`; `GoodsCubit`, `HomeCubit` and
  `ReportPage` listen to it because those tabs stay alive in `MainPage`'s `IndexedStack`. Like all
  other preferences these are not part of backup/restore. Rules:
  [BUSINESS_LOGIC.md](BUSINESS_LOGIC.md#good-properties).
- Per-Store Document properties follow the same pattern (`DocumentPropertiesSettings`,
  `AppSettings.getDocumentPropertiesSettings`, `AppSettings.documentPropertiesRevision`,
  `lib/presentation/pages/settings/document_properties/`); `HomeCubit` listens to both
  revisions. Rules: [BUSINESS_LOGIC.md](BUSINESS_LOGIC.md#document-properties).
- Quantity formatting is central: `AppSettings.getQuantityDecimals()` (falls back to 2 when storage
  is not initialised) feeds `StringUtils.getQuantityText`, the report helpers in
  `lib/data/report_data/utils.dart` and the input helpers in `lib/util/quantity_input.dart`.
  Rules: [BUSINESS_LOGIC.md](BUSINESS_LOGIC.md#quantity-field).
- The negative stock rule lives in `DocumentUseCases` (it throws `InsufficientStockException`); the
  cubits that write transactions or delete Documents catch it and emit `InsufficientStockError`,
  which the views show with `insufficientStockMessage`.
- Every successful transaction or Document write bumps `DocumentUseCases.stockRevision`; the
  Inventory tab's `GoodsCubit` (not the Select Good screen) listens and reloads its goods, because
  that tab stays alive in `MainPage`'s `IndexedStack`.
- The passcode is stored in preferences and compared as a plain string
  (`lib/presentation/pages/main/main_page.dart`, `_showLockScreen`).

## Cross-cutting

- i18n: `easy_localization`, fallback `en-US`, `saveLocale: true` (`lib/main.dart`).
- Notifications: `NotificationService.init` is called from `MyAppState.initState`; the call in
  `main()` is commented out. A low-stock notification is shown from
  `lib/presentation/pages/main/main_page.dart`.
- Filtering/sorting: criteria objects in `lib/presentation/criteria/` and per-page `criteria/`,
  `sort/` folders.
- Theme: Material `ColorScheme.fromSeed` with `AppTheme` colour and mode (`lib/app.dart`).

## Open questions

- None currently. Supported platforms are Android and iOS only (owner-confirmed); desktop and web
  are unsupported, so there is no desktop SQLite bootstrap (see [DATABASE.md](DATABASE.md)).
