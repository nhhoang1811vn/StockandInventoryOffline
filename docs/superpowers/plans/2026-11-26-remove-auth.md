# Remove sign-up / sign-in (1.0.97) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove every account, sign-in, cloud-backup and Online-app-sync feature so the app is purely local, without touching existing user data or Pro entitlements.

**Architecture:** Keep the startup gate (`/loading_data` → Main or Onboarding) but move it out of the auth code into a small `StartupCubit`. Remove UI and code surface by surface (Menu, Home, Backup page), then delete the auth code and packages once nothing references them, so every commit builds. RevenueCat keeps its cached app user id; a "Restore purchases" row replaces account-based recovery.

**Tech Stack:** Flutter, `flutter_bloc` Cubit, `injectable`/`get_it` (codegen), `easy_localization`, `purchases_flutter`, `flutter_test`.

**Spec:** [docs/superpowers/specs/2026-11-26-remove-auth-design.md](../specs/2026-11-26-remove-auth-design.md)

## Global Constraints

- Branch `1.0.97`. Schema stays at version 8; `lib/data/db/db_helper.dart` is not touched. No migration.
- JSON file backup/restore (`DbService`), Crashlytics, Analytics, Passcode, free limits are unchanged.
- Keep packages `firebase_core`, `firebase_analytics`, `firebase_crashlytics`; remove `firebase_auth`, `firebase_storage`, `firebase_database`, `google_sign_in`, `sign_in_with_apple`, `desktop_webview_auth`.
- RevenueCat entitlement id `stockandinventory_pro` unchanged. Pro stays off on Windows (`isMobilePlatform`).
- Route constant `Pages.loading_data = '/loading_data'` and the l10n keys `loading_data`, `startup_retry`, `startup_data_error` are kept.
- New user-visible strings go into all 11 files in `assets/translations/` (`ar-SA de-DE en-US es-ES fr-FR hi-IN ja-JP pt-BR ru-RU vi-VN zh-CN`), edited directly. Unused old keys stay.
- Do not hand-edit `lib/di/di.config.dart`, `*.freezed.dart`, `*.g.dart`; run `dart run build_runner build --delete-conflicting-outputs`.
- Do not touch `ios/Runner/Runner.entitlements`, `GoogleService-Info.plist` or `ios/Podfile.lock` (signing and CocoaPods can only be verified in CI). Say so in the final report.
- Version becomes `1.0.97+118`.
- Each task ends with `flutter analyze` clean for the touched files and `flutter test` green.

## Review Focus

1. Upgrade for a user with a persisted non-anonymous Firebase session and data: opens Main on the same store, nothing deleted. (Task 1 tests.)
2. Saved selected store id points at a store that no longer exists: first store becomes selected, no crash. (Task 1 tests.)
3. Database read fails at startup: retry screen shows, retry recovers. (Task 1 tests.)
4. Restore purchases with nothing to restore, or with no network: clear message, no crash, row hidden on Windows. (Task 2.)
5. A locale missing a new key renders the raw key. (Task 2 translation test.)

---

### Task 1: StartupCubit replaces the auth-based startup gate

**Files:**
- Create: `lib/presentation/pages/startup/bloc/startup_cubit.dart`, `lib/presentation/pages/startup/bloc/startup_state.dart` (`part of`), `lib/presentation/pages/startup/startup_page.dart`
- Modify: `lib/presentation/router.dart:124-130` (route case), `lib/presentation/router.dart:24` (import), `lib/di/di.config.dart` (regenerated)
- Test: `test/startup_cubit_test.dart`

**Interfaces:**
- Produces: `StartupCubit(StoresUseCase useCase)` (`@injectable`), `void load()`, state classes `StartupState` (abstract), `StartupLoading`, `StartupHasStore`, `StartupNoStore`, `StartupFailure(String message)`. `StartupPage` widget; route `Pages.loading_data` builds `BlocProvider(create: (_) => getIt<StartupCubit>(), child: StartupPage())`.
- Consumes: `StoresUseCase.getAll()`, `AppSettings.getSelectedStoreId/setSelectedStoreId/setSelectedStoreName` (same logic as `AuthCubit.checkStore/updateSelectedStore` in `lib/presentation/pages/login/auth_cubit.dart:50-86`).

- [ ] **Step 1: Write failing tests** in `test/startup_cubit_test.dart`, same `AppSettings.initialize` setup as `test/good_properties_cubit_test.dart`. Use a `_FakeStoresUseCase implements StoresUseCase` overriding only `getAll()` (plus `noSuchMethod`) that returns a configurable list or throws. Tests:
  - `empty store list emits StartupNoStore`
  - `non-empty list emits StartupHasStore`
  - `selected id still valid is kept` (`AppSettings.getSelectedStoreId()` unchanged)
  - `selected id missing selects first store id and name`
  - `getAll throwing emits StartupFailure` and a second `load()` after the fake stops throwing emits `StartupHasStore`
  Assert the emitted sequence with `emitsInOrder([isA<StartupLoading>(), isA<StartupHasStore>()])` on `cubit.stream`.
- [ ] **Step 2: Run** `flutter test test/startup_cubit_test.dart` → FAIL (files missing).
- [ ] **Step 3: Implement `StartupCubit`** with the exact logic of `checkStore` + `updateSelectedStore`; failure message `"startup_data_error".tr()`; guard `isClosed` before each emit as the old cubit does. Plain state classes, no freezed.
- [ ] **Step 4: Implement `StartupPage`** by copying `lib/presentation/pages/login/loading_data.dart` minus `justLogin`: `initState` calls `context.read<StartupCubit>().load()`; listener pushes `Pages.main` on `StartupHasStore` and `Pages.onboarding` on `StartupNoStore` (both `pushNamedAndRemoveUntil(..., (r) => false)`); retry button calls `load()`.
- [ ] **Step 5: Point the router at it**: replace the `Pages.loading_data` case's provider/child, fix imports. Run codegen.
- [ ] **Step 6: Run** `flutter test test/startup_cubit_test.dart` → PASS; `flutter analyze` → no new issues.
- [ ] **Step 7: Commit** `git add lib/presentation/pages/startup lib/presentation/router.dart lib/di/di.config.dart test/startup_cubit_test.dart` · `refactor: move startup gate out of auth into StartupCubit`

### Task 2: Menu without accounts, plus Restore purchases

**Files:**
- Modify: `lib/presentation/pages/menu/menu_page.dart` (remove `_buildProfileCard`, `_buildAnonymousInfo`, `_buildAccountActionsCard`, `onDeleteAccountItemPressed`, `onLogoutItemPressed`, `_finishSignOut`, the `isAnonymous`/Account section in `build`, Firebase and `Pages.link_with` references; add Restore row after the `subscriptions_title` row near line 331), `lib/presentation/pages/menu/bloc/menu_cubit.dart` (remove `deleteAccount`, `signOut`, `upload` and their imports; the class stays, empty body), `lib/util/revenuecat_purchase_manager.dart` (add `restorePurchases`), all 11 `assets/translations/*.json`
- Test: `test/restore_purchases_translations_test.dart`

**Interfaces:**
- Produces: `enum RestoreResult { proActive, nothingToRestore, failed }`; `static Future<RestoreResult> RevenueCatService.restorePurchases()` (calls `Purchases.restorePurchases()`, `proActive` when `entitlements.active` contains `entitlementIdenditifer`, `failed` on any exception). New keys: `restore_purchases`, `restore_purchases_success`, `restore_purchases_not_found`, `restore_purchases_failed`.

- [ ] **Step 1: Write failing test** `restore_purchases_translations_test.dart` modelled on `test/translations_copy_key_test.dart`: for each of the 11 locales and each of the 4 keys, the value is a non-empty `String`.
- [ ] **Step 2: Run** `flutter test test/restore_purchases_translations_test.dart` → FAIL.
- [ ] **Step 3: Add the 4 keys to all 11 JSON files** (translated per locale; English: "Restore purchases", "Purchases restored. Pro is active.", "No purchases found to restore.", "Could not restore purchases. Try again.").
- [ ] **Step 4: Run** the test → PASS.
- [ ] **Step 5: Implement `RevenueCatService.restorePurchases`** (returns `failed` without calling the SDK when `!isMobilePlatform`).
- [ ] **Step 6: Edit `menu_page.dart`**: the list starts with `SettingsSectionHeader(context.tr("inventory"))`; no profile card, no Account section. Add `SettingsMenuItem(icon: Icons.restore, title: restore_purchases)` inside `if (isMobilePlatform)`; on tap call `RevenueCatService.restorePurchases()`, toast the matching key with `ToastUtils.showSuccessToast`/`showErrorToast`, then `_isPro = await RevenueCatService.isPro()` and `setState`. Keep the existing premium badge logic only if it still has a home; otherwise remove `_buildStockPremiumBadge` when analyze reports it unused. Remove `MenuCubit` deletions; keep `MenuCubit` provided in `main_page.dart:33`.
- [ ] **Step 7: Run** `flutter analyze` and `flutter test` → green.
- [ ] **Step 8: Commit** · `feat: remove account UI from Menu, add Restore purchases`

### Task 3: Home without the Online banner and Firebase avatar

**Files:**
- Modify: `lib/presentation/pages/home/home_page.dart` — delete `_buildAnnouncementCard` (line 760), `onSyncDataPressed`, `_showVersionInfoDialog`, `_buildFeatureRow` (only used there), the call at line 156 with its trailing `SizedBox`, and the `FirebaseAuth` photo code in `_buildHeader` (lines 200-206; the menu avatar shows `Icons.person` only).
- Test: existing `test/home_windows_banner_test.dart` must still pass.

**Interfaces:** Consumes nothing new. Keep `HomeWindowsBanner` and its spacing intact.

- [ ] **Step 1: Make the edits**; keep the `_cardGap` rhythm between the remaining cards.
- [ ] **Step 2: Run** `flutter analyze` (remove imports it reports unused, including `firebase_auth`, `SettingsDataCubit`, `shared_preferences` if unused) and `flutter test` → green.
- [ ] **Step 3: Commit** · `feat: remove Online migration banner and Firebase avatar from Home`

### Task 4: Backup page without Cloud; delete Realtime sync

**Files:**
- Modify: `lib/presentation/pages/settings/data/settings_data_page.dart` (remove `user`, `cloudFileUpdatedTime`, `loadCloudFileUpdatedTime`, `onCloudPressed`, `onSaveDataToCloudVersion2`, the Cloud section in `_buildBody` and the Firebase imports; the commented-out blocks may stay), `lib/presentation/pages/settings/data/bloc/settings_data_cubit.dart` (remove `syncToRealtimeDB`, all repository fields and constructor parameters; keep the class and state), `lib/di/di.config.dart` (regenerated)
- Delete: `lib/data/realtime/` (whole folder)

**Interfaces:** Produces `SettingsDataCubit()` with no constructor arguments; router provider at `router.dart:336` already uses `getIt<SettingsDataCubit>()`.

- [ ] **Step 1: Make the edits and delete the folder**; run codegen.
- [ ] **Step 2: Run** `flutter analyze` and `flutter test` → green. Confirm the backup and restore rows still render (Windows run in Task 7).
- [ ] **Step 3: Commit** · `feat: remove cloud backup and Realtime DB sync`

### Task 5: Delete the auth code and stop signing in

**Files:**
- Delete: `lib/presentation/pages/login/` (all files), `lib/presentation/pages/signup/`, `lib/presentation/pages/forgotpassword/`, `lib/presentation/pages/linkwith/`, `lib/presentation/utils/auth_listeners.dart`
- Modify: `lib/presentation/router.dart` (remove the `signup`, `signIn`, `link_with`, `forgotPassword` cases and their imports, plus the commented `upgrade_account` block), `lib/presentation/pages/pages.dart` (remove `signup`, `signIn`, `forgotPassword`, `link_with`), `lib/main.dart` (remove `justLogin`, the `authStateChanges` listener, the anonymous sign-in, imports of `firebase_auth`, `firebase_database`; keep `Firebase.initializeApp` and the Crashlytics hooks), `lib/util/revenuecat_purchase_manager.dart` (remove `updateUser`, `logoutUser`), `lib/di/di.config.dart` (regenerated)

- [ ] **Step 1: Delete and edit**; run codegen.
- [ ] **Step 2: Verify nothing is left**: `Grep` for `AuthCubit|FirebaseAuth|justLogin|auth_listeners|Pages\.(signup|signIn|link_with|forgotPassword)|updateUser|logoutUser` in `lib/` and `test/` → no matches.
- [ ] **Step 3: Run** `flutter analyze` and `flutter test` → green.
- [ ] **Step 4: Commit** · `feat: delete sign-in, sign-up and account linking`

### Task 6: Remove the packages

**Files:** Modify `pubspec.yaml` (remove the 6 packages listed in Global Constraints), `pubspec.lock`, the tracked plugin registrants under `linux/ macos/ windows/` (regenerated by `flutter pub get`; they already have uncommitted edits from before this work — inspect `git diff` and keep only the removals that follow from this change).

- [ ] **Step 1: Verify no import remains**: `Grep` `package:(firebase_auth|firebase_storage|firebase_database|google_sign_in|sign_in_with_apple|desktop_webview_auth)` in `lib/` and `test/` → none.
- [ ] **Step 2: Edit `pubspec.yaml`, run** `flutter pub get`, then codegen.
- [ ] **Step 3: Run** `flutter analyze` and `flutter test` → green.
- [ ] **Step 4: Run** `flutter build windows --debug` → succeeds (the only platform buildable here; Android and iOS are CI-only).
- [ ] **Step 5: Commit** · `chore: remove auth, storage, database and social sign-in packages`

### Task 7: Docs, ADR, version, What's new

**Files:**
- Create: `docs/adr/0004-remove-accounts-and-cloud.md` (decision, consequences: Pro via restore, cloud copies no longer reachable, supersedes ADR 0003)
- Modify: `docs/adr/0003-keep-home-migration-banner.md` (add a "Superseded by 0004" line), `CONTEXT.md` (version, Project overview, stack table Sign-in row, `Backend integrations`, glossary "Pro" untouched), `docs/ARCHITECTURE.md` (auth/startup sections around lines 26-49), `docs/BUSINESS_LOGIC.md` ("Account, backup, sync" at line 251, rewrite as "Backup" + Pro restore), `docs/DATABASE.md` ("Cloud copy" at line 90), `pubspec.yaml` (`version: 1.0.97+118`), `lib/presentation/markdown/md_resource_{ar,de,en,es,fr,hi,ja,pt,ru,vn,zh}.dart` (new top entry for 1.0.97 dated 2026-11-26, same format as the 1.0.96 entry)
- Test: extend nothing; rely on analyze.

- [ ] **Step 1: Write the 1.0.97 What's new** in all 11 files: accounts, sign-in, cloud backup and the Online banner are gone; local data is unchanged; Pro can be restored from Menu > Restore purchases; back up to a file to keep a copy.
- [ ] **Step 2: Update the docs and ADR** so no doc still describes sign-in, cloud backup or Realtime sync as present; run `Grep` for `Firebase Auth|signInAnonymously|2026/<uid>|syncLocalToNetwork|link_with` across `CONTEXT.md docs` → only ADR history mentions remain.
- [ ] **Step 3: Bump the version**, run `flutter pub get`.
- [ ] **Step 4: Run** `flutter analyze` and `flutter test` → green.
- [ ] **Step 5: Commit** · `docs: record removal of accounts and cloud, prepare 1.0.97`

### Task 8: Verify end to end

- [ ] **Step 1: Run** `flutter analyze` and `flutter test` (full) → record counts.
- [ ] **Step 2: Run the app on Windows** (`flutter run -d windows`) using the existing `main.db` of a dev profile: app opens, goes to Main with the previous store, Menu has no Account/profile, Backup page has only Back up and Restore, Home has no Online card.
- [ ] **Step 3: Check the RevenueCat assumption** in the `purchases_flutter` docs/source: with `Purchases.configure` and no `appUserID`, the SDK reuses the cached id. If it does not, stop and bring this back to the owner before release.
- [ ] **Step 4: Report** what was run, and what could not be verified here: Android/iOS builds, CocoaPods lockfile, a real sandbox purchase restore.

