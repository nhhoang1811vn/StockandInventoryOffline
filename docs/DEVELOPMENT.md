# Development

## Prerequisites

- Dart `>=3.3.0 <4.0.0` (`pubspec.yaml`). Flutter SDK `3.47.7` (owner-confirmed; set in
  `codemagic.yaml`, not pinned elsewhere in the repo).
- Supported platforms: Android and iOS only.
- Android: `compileSdk 36`, `minSdkVersion 24`, `targetSdkVersion 36`, application id
  `com.steam.goodmanagerflutter` while the Gradle `namespace` is `com.ssteam.goodmanagerflutter`
  (`android/app/build.gradle`); do not unify them.
- iOS: bundle id in CI is `com.ssteam.goodmanagerflutter` (`codemagic.yaml`). It differs from
  Android's id intentionally (owner-confirmed); do not "fix" it.
- CocoaPods; Swift Package Manager is disabled (`pubspec.yaml`,
  `flutter: config: enable-swift-package-manager: false`).

## Setup and run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -t lib/main.dart
```

Code generation is required after a fresh checkout: `*.freezed.dart` and `*.g.dart` are git-ignored
(`.gitignore`). `lib/di/di.config.dart` is generated but tracked. Re-run codegen when changing:
`@freezed` classes and states, `@injectable` / `@LazySingleton` annotations, `@HiveType`
models, `@JsonSerializable` settings (`lib/domain/entity/*_setting*.dart`).

## Build

```bash
flutter build appbundle --release -t lib/main.dart
flutter build ipa --release -t lib/main.dart
```

No flavors and no `--dart-define` usage were found in `lib/` or the Android Gradle config.
Environment separation is therefore **UNKNOWN / none**.

## CI/CD

`codemagic.yaml`, two workflows, both triggered on push to `release/*` and `master`:

- `android-release`: `flutter pub get` → build_runner → `flutter build appbundle`; publishes to the
  Google Play **production** track.
- `ios-release`: code signing → build_runner → `flutter build ipa`; publishes to TestFlight and submits the build to App Store review (`submit_to_app_store`).

Neither workflow runs `flutter analyze` or tests. There is no `.github/` directory.

## Localization

- Runtime: `easy_localization`, JSON files `assets/translations/<lang>-<COUNTRY>.json`
  (en-US, es-ES, fr-FR, de-DE, zh-CN, ar-SA, hi-IN, pt-BR, ru-RU, ja-JP, vi-VN), registered in
  `lib/main.dart`.
- Workflow (owner-confirmed): translations are edited **directly in the JSON files**; there is no
  `gen-l10n` / ARB step. Add or change a key in all 11 files.
- Legacy, not part of the current workflow: `translation/translation.xlsx` and the scripts in
  `translation/` (`export_key.py`, `export_values.py`, `generate_arb_from_sheet.py`), and the
  `lib/l10n` / `gen-l10n` instructions in `README.md` (no `lib/l10n` or `l10n.yaml` exists).
- Use keys via `context.tr("key")` / `"key".tr()`.

## Testing

No `test/` or `integration_test/` directory exists. The only test files are the default iOS and
macOS `RunnerTests`. Static analysis config: `analysis_options.yaml` (`flutter_lints`; build and
platform folders excluded).

```bash
flutter analyze
flutter test      # currently has nothing to run
```

## Coding conventions (observed)

- File layout:
  `pages/<feature>/{<feature>_page|_view.dart, bloc/<feature>_cubit.dart, bloc/<feature>_state.dart, components/}`.
- Constants for tables in `DBHelper`; route names in `Pages`.
- Several files use `print` (12 occurrences) and commented-out code; do not extend either practice.
- Misspelling in an existing file name, `lib/domain/usecase/goods/goods_usercases.dart` and
  `lib/domain/usecase/payment/payment_usercases.dart`; keep imports
  intact when touching them, do not rename as a side effect.

## Known risks and debt

Data-layer risks: [DATABASE.md](DATABASE.md#known-risks-verified-in-code).

- Signing keystores `android/stockandinventory.jks` and `android/upload-key-good-manager.jks` are
  tracked in git on purpose (owner-confirmed). Do not remove or rewrite them, and never print or
  copy their contents or passwords. Where their passwords live: **UNKNOWN**.
- `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/GoogleService-Info.plist`
  and `ios/Runner/GoogleService-Info.plist` are tracked (normal for Firebase client config; security
  depends on Firebase rules, which are not in the
  repo).
- RevenueCat public SDK keys are hardcoded; any non-Android platform uses the iOS key
  (`lib/util/revenuecat_purchase_manager.dart`).
- `AppSettings.isPro()` is always false
  (see [BUSINESS_LOGIC.md](BUSINESS_LOGIC.md#free-tier-and-pro)).
- Passcode stored and compared as plain text (`lib/data/app_settings.dart`,
  `lib/presentation/pages/main/main_page.dart`).
- `README.md` also says to copy translations to `lib/l10n/` (stale).
