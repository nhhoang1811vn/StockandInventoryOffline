# Unlock with Fingerprint Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an "Unlock with fingerprint" toggle to General Settings (visible only while passcode lock is on) and, when it is on, prompt for fingerprint as soon as the app's lock screen opens.

**Architecture:** `local_auth` is wrapped in an injectable `BiometricAuthService`. `SettingsGeneralCubit` owns the toggle state and availability. `MainPage._showLockScreen()` keeps the existing `flutter_screen_lock` screen and calls the service from `onOpened`; a fingerprint button on the keypad retries. Passcode is always the fallback.

**Tech Stack:** Flutter, flutter_bloc + freezed + injectable, `flutter_screen_lock` 9.2.2+2, new `local_auth` (2.x), `easy_localization`.

**Spec:** [docs/superpowers/specs/2026-11-17-unlock-with-fingerprint-design.md](../specs/2026-11-17-unlock-with-fingerprint-design.md)

**Commits:** commit steps run only if the user has asked for commits; otherwise skip them.

## Global Constraints

- New dependency `local_auth` only (user-approved); use a 2.x release (`^2.3.0`), no other new package.
- Android permission `android.permission.USE_BIOMETRIC`; iOS `NSFaceIDUsageDescription`. `MainActivity` is already `FlutterFragmentActivity`; do not change it.
- Preference key `EnableFingerprint`, default false, in `AppSettings`.
- Toggle visible only when `enablePasscode && canUseBiometrics`. Turning passcode off sets fingerprint false.
- Enabling the toggle runs one successful `authenticate()` before saving `true`.
- Fingerprint is only offered with `biometricOnly: true` (device PIN is not offered; our passcode is the fallback). Any failure, cancel, lockout or exception → passcode screen stays usable.
- Passcode screen behaviour is unchanged when fingerprint is off. No re-lock on resume.
- Strings go in all 11 files in `assets/translations/`, edited directly. Do not hand-edit `*.freezed.dart`, `*.g.dart`, `lib/di/di.config.dart`; re-run codegen.
- No business logic in widgets; no schema change.

## Review Focus

1. Fingerprint fails, is cancelled, or the sensor is locked out → passcode keypad still unlocks (Task 1 test: `authenticate` returns false on exception/false; Task 3 manual).
2. Device with no enrolled fingerprint, unsupported hardware, or a plugin exception → toggle hidden, no crash (Task 1 tests on `isAvailable`).
3. User types the correct passcode while the prompt is open (or taps the retry button after unlocking) → only one `pop`, no popped-MainPage / black screen (Task 3 guard + manual).
4. Fingerprint on, then passcode turned off → fingerprint cleared, toggle hidden, app opens without lock (Task 2 manual).
5. Fingerprint enabled, then the user removes their enrolled fingerprints → app opens, prompt fails, passcode works (Task 3 manual).

---

### Task 1: Dependency, platform config, setting key and `BiometricAuthService`

**Files:**
- Modify: `pubspec.yaml` (add `local_auth: ^2.3.0` under dependencies)
- Modify: `android/app/src/main/AndroidManifest.xml` (add `USE_BIOMETRIC` permission next to the other `uses-permission` lines)
- Modify: `ios/Runner/Info.plist` (add `NSFaceIDUsageDescription`, value "Use Face ID to unlock the app.")
- Modify: `lib/data/app_settings.dart` (next to `EnablePasscodeKey`, ~line 35 and ~184)
- Modify: `lib/di/app_module.dart`
- Create: `lib/core/services/biometric_auth_service.dart`
- Test: `test/biometric_auth_service_test.dart`

**Interfaces:**
- Produces:
  - `AppSettings.EnableFingerprintKey = "EnableFingerprint"`, `static void setEnableFingerprint(bool value)`, `static bool getEnableFingerprint()` (default false).
  - `AppModule`: `@lazySingleton LocalAuthentication get localAuth => LocalAuthentication();`
  - `@lazySingleton class BiometricAuthService { BiometricAuthService(this._auth); Future<bool> isAvailable(); Future<bool> authenticate(String reason); }`
    - `isAvailable()` → `true` only if `isDeviceSupported()` is true and `getAvailableBiometrics()` is non-empty; any exception → `false`.
    - `authenticate(reason)` → `_auth.authenticate(localizedReason: reason, options: AuthenticationOptions(biometricOnly: true, stickyAuth: true))`; returns its result; any exception → `false`.

- [ ] **Step 1: Write the failing tests** in `test/biometric_auth_service_test.dart` using a `_FakeLocalAuth extends LocalAuthentication` that overrides `isDeviceSupported`, `getAvailableBiometrics`, `authenticate` with configurable results or thrown `PlatformException`. Tests (names exact):
  - `isAvailable is true when supported and a biometric is enrolled` → `[BiometricType.fingerprint]` ⇒ `true`
  - `isAvailable is false when the device is not supported` ⇒ `false`
  - `isAvailable is false when nothing is enrolled` (empty list) ⇒ `false`
  - `isAvailable is false when the plugin throws` ⇒ `false`
  - `authenticate returns true on success`
  - `authenticate returns false when the user fails or cancels` (fake returns false)
  - `authenticate returns false when the plugin throws` (e.g. lockout `PlatformException`)

- [ ] **Step 2: Run** `flutter test test/biometric_auth_service_test.dart` → Expected: FAIL (service/package not found).

- [ ] **Step 3: Add the package and platform config.** Run `flutter pub add local_auth:^2.3.0`; add the Android permission and iOS plist key as listed above.

- [ ] **Step 4: Implement `AppSettings` key/getter/setter, `AppModule.localAuth`, and `BiometricAuthService`** with the signatures above (file `lib/core/services/biometric_auth_service.dart`, `@lazySingleton` from `injectable`). Then run codegen per `docs/DEVELOPMENT.md` (`dart run build_runner build --delete-conflicting-outputs`).

- [ ] **Step 5: Run** `flutter test test/biometric_auth_service_test.dart` → Expected: 7 tests PASS. Run `flutter analyze` → no new issues.

- [ ] **Step 6: Commit** (only if asked): `feat: add BiometricAuthService and EnableFingerprint setting`

---

### Task 2: Settings cubit, state, toggle and translations

**Files:**
- Modify: `lib/presentation/pages/settings/general/bloc/settings_general_state.dart`
- Modify: `lib/presentation/pages/settings/general/bloc/settings_general_cubit.dart`
- Modify: `lib/presentation/pages/settings/general/settings_general_page.dart` (insert after the passcode `SettingsSwitchItem`, ~line 106)
- Modify: `assets/translations/*.json` (11 files; insert after `enter_pin_to_unlock`)

**Interfaces:**
- Consumes: `AppSettings.getEnableFingerprint/setEnableFingerprint`, `BiometricAuthService.isAvailable/authenticate` (Task 1; obtain via `@injectable` constructor parameter `SettingsGeneralCubit(this._biometric)`).
- Produces:
  - State fields: `@Default(false) bool enableFingerprint`, `@Default(false) bool canUseBiometrics`.
  - Cubit: `Future<void> loadBiometricAvailability()` (called from the constructor; emits `canUseBiometrics`), `Future<void> onEnableFingerprintChanged(bool value, String reason)` (when `value` is true it first `await`s `authenticate(reason)` and returns without change if false; otherwise saves and emits), and `onEnablePasscodeChanged` additionally sets fingerprint false when `value` is false.
  - Translation keys: `menu_item_fingerprint_title` ("Unlock with fingerprint" / vi "Mở khóa bằng vân tay"), `fingerprint_unlock_reason` ("Use your fingerprint to unlock the app" / vi "Dùng vân tay để mở khóa ứng dụng"). Translate into the other 9 locales; keep key order/format of each file.

- [ ] **Step 1: Add state fields and update the cubit** (initial `enableFingerprint: AppSettings.getEnableFingerprint()`); run codegen.
- [ ] **Step 2: Add the `SettingsSwitchItem`** (icon `Icons.fingerprint`, title `context.tr("menu_item_fingerprint_title")`, `value: state.enableFingerprint`, `onChanged` → `onEnableFingerprintChanged(value, context.tr("fingerprint_unlock_reason"))`), wrapped in `if (state.enablePasscode && state.canUseBiometrics)`. Keep `isLast` on the reset-numeration item.
- [ ] **Step 3: Add the two translation keys to all 11 files**; verify each file is valid JSON (`python -c "import json,sys;[json.load(open(f,encoding='utf-8')) for f in sys.argv[1:]]" assets/translations/*.json` prints nothing).
- [ ] **Step 4: Run** `flutter analyze` and `flutter test` → no new issues, all tests pass.
- [ ] **Step 5: Manual check** (device/emulator with an enrolled fingerprint): toggle hidden with passcode off; appears after enabling passcode; enabling requires a fingerprint scan; failed scan leaves it off; turning passcode off then on again shows the toggle off.
- [ ] **Step 6: Commit** (only if asked): `feat: add Unlock with fingerprint toggle to General Settings`

---

### Task 3: Fingerprint prompt on the lock screen, and docs

**Files:**
- Modify: `lib/presentation/pages/main/main_page.dart:118-134` (`_showLockScreen`)
- Modify: `docs/BUSINESS_LOGIC.md` (Passcode section, ~line 117)
- Modify: `CONTEXT.md` (technology stack table: add a row for `local_auth`; note unsupported/unused platforms if relevant)

**Interfaces:**
- Consumes: `AppSettings.getEnableFingerprint()`, `getIt<BiometricAuthService>().authenticate(String)`, translation key `fingerprint_unlock_reason` (Tasks 1–2).
- Produces: `_ScreenState` private `bool _lockOpen` and `Future<void> _unlockWithFingerprint()`.

- [ ] **Step 1: Implement in `_showLockScreen()`.** After the existing passcode check, set `_lockOpen = true`. In `onUnlocked`, only `Navigator.of(context).pop()` if `_lockOpen` is true, then set it false. When `AppSettings.getEnableFingerprint()` is true, pass `onOpened: _unlockWithFingerprint` and `customizedButtonChild: const Icon(Icons.fingerprint)` / `customizedButtonTap: _unlockWithFingerprint`. `_unlockWithFingerprint()` awaits `authenticate(context.tr("fingerprint_unlock_reason"))`; if it returns true and `_lockOpen && mounted`, set `_lockOpen = false` and `Navigator.of(context).pop()`; otherwise do nothing. No changes to passcode validation.
- [ ] **Step 2: Run** `flutter analyze` and `flutter test` → no new issues, all tests pass.
- [ ] **Step 3: Manual checks** (Android device with enrolled fingerprint): (a) fingerprint on, cold start → prompt appears at once, success opens the app; (b) cancel prompt → keypad usable, passcode unlocks; (c) tap the fingerprint button → prompt again; (d) type correct passcode while the prompt is open, then dismiss it → app stays open, no extra pop; (e) fingerprint off → behaviour identical to before; (f) remove enrolled fingerprints in system settings with toggle still on → app opens via passcode.
- [ ] **Step 4: Update docs.** In `docs/BUSINESS_LOGIC.md` Passcode section: when "Unlock with fingerprint" is on (only while passcode is on and the device has an enrolled biometric), `_showLockScreen` prompts via `BiometricAuthService` on open; passcode remains the fallback; turning passcode off clears it. In `CONTEXT.md` add `local_auth` to the stack table.
- [ ] **Step 5: Commit** (only if asked): `feat: unlock with fingerprint on app open`

---

## Self-review notes

- Spec coverage: toggle + visibility (T2), enable-confirm scan (T2), passcode-off clears (T2), `onOpened` + retry button + double-pop guard (T3), wrapper service (T1), key + strings + docs (T1–T3), platform config (T1). Failure fallbacks are covered by service tests (T1) and manual checks (T3).
- Not unit-tested (static `AppSettings`, platform dialogs): cubit and lock screen are checked manually; no test infrastructure exists for them.
- Windows: `local_auth` supports Windows Hello; `isAvailable()` decides if the toggle shows. Not verified on Windows.
