# Remove sign-up / sign-in, make the app purely local (1.0.97)

Branch `1.0.97`. Status: design, awaiting approval.

## Intent and why

The owner wants this app to be a purely local app: no accounts, no cloud. Today it signs a Firebase
anonymous user in at startup and offers email, Google and Apple sign-in, cloud backup and a push to
the Online app's Realtime Database. All of that goes. The user's SQLite data must come through
untouched.

## Goals

- No sign-up, sign-in, sign-out, delete-account, forgot-password or account-linking UI or code.
- No network call for identity at startup. App works the same offline and online.
- Existing local data is unchanged: no schema change, no migration, nothing written or deleted at
  upgrade.
- Pro keeps working for everyone who has it (signed in or anonymous), and can be recovered after a
  reinstall.
- Cloud backup/restore (Firebase Storage), the Realtime DB push and the Home "Online Collaboration"
  banner are removed.

## Non-goals

- No change to JSON file backup/restore (`DbService`, Settings > Backup and restore).
- No change to Crashlytics, Analytics, RevenueCat entitlement id, free limits, Passcode.
- No cleanup of unused translation keys; no refactor of unrelated files.
- No data migration tool for people who only have a cloud copy.

## Anti-goals (failure even if it compiles)

- Any user losing local data on upgrade. Any user who paid for Pro losing Pro with no way back.
- Startup breaking: the app must still land on Main (store exists) or Onboarding (no store).

## Constraints

- AGENTS.md: follow patterns, no hand-edited generated files (`di.config.dart`), codegen after DI
  changes, `flutter analyze`, update docs in the same change, new ADR for the decision.
- Schema stays at version 8. `DBHelper` is not touched.
- 11 locales in `assets/translations/` need the "What's new" entry (the What's new text lives in
  `lib/presentation/markdown/md_resource_*.dart` — builder to confirm where it is stored).

## Approaches considered

- **A. Remove it all in 1.0.97 (chosen by the owner).** Delete auth code and the Firebase Auth,
  Storage, Database, Google and Apple packages in one release. Cleanest, matches the goal; most
  files change, so it needs builds on every platform.
- **B. Hide UI only.** Keeps anonymous sign-in and `logIn(uid)`; smallest diff but not purely local.
- **C. Two releases.** UI now, packages in 1.0.98. Easy rollback, but leaves dead code for a release.

## Design

### Startup gate (keep, relocate)
`LoadingData` + `AuthCubit.checkStore/updateSelectedStore` are the startup gate (`initialRoute:
Pages.loading_data` in `app.dart`). Keep the behaviour, move it out of `login/` into a small
`StartupCubit` (`@injectable`, plain or freezed state) that only calls `StoresUseCase.getAll()` and
`AppSettings` — exactly the current `checkStore` logic, including the `StartupFailure` retry screen.
Drop the `justLogin` branch and the global `justLogin` in `main.dart`. Route constant and path
(`Pages.loading_data`) stay so nothing else changes. Builder decides folder/file names (e.g.
`pages/startup/`).

### Delete
- Pages: `login/` (except the relocated gate), `signup/`, `forgotpassword/`, `linkwith/`;
  `AuthCubit`, `auth_state.dart`, `auth_input.dart`, `social_button_style.dart` (if unused after),
  `presentation/utils/auth_listeners.dart`.
- `Pages.signup`, `Pages.login`, `Pages.link_with`, `Pages.forgotPassword` and their cases in
  `router.dart`.
- `lib/data/realtime/` (`DbServiceRealtime`) and `SettingsDataCubit.syncToRealtimeDB`.
- Menu: profile card and guest card (`_buildProfileCard`, `_buildAnonymousInfo`), Account section
  (`_buildAccountActionsCard`, sign out, delete account), `MenuCubit.signOut/deleteAccount/upload`,
  the cloud upload dialog near line 606.
- Home: header avatar from Firebase, `_buildAnnouncementCard` and `onSyncDataPressed`.
- Settings > Backup and restore: the Cloud section, `loadCloudFileUpdatedTime`, `onCloudPressed`,
  `onSaveDataToCloudVersion2`, Firebase imports.
- `main.dart`: auth listener, anonymous sign-in, Realtime DB user index, `FirebaseAuth` import.
  `Firebase.initializeApp`, Crashlytics hooks stay.
- `pubspec.yaml`: `firebase_auth`, `firebase_storage`, `firebase_database`, `google_sign_in`,
  `sign_in_with_apple`, `desktop_webview_auth`. Keep `firebase_core`, analytics, crashlytics. Builder
  checks nothing else imports them and that Windows/iOS/Android plugin files still resolve.

### Keep the Menu usable
With the profile card gone, Menu starts at the "inventory" section. Whether a small Pro badge or
a plain header replaces the card is a UI call for the builder (keep it simple; show the existing
premium badge when `_isPro`).

### Pro (RevenueCat)
- Stop calling `Purchases.logIn(uid)` and `Purchases.logOut()`; remove `updateUser` and
  `logoutUser`. `Purchases.configure` is unchanged, so the SDK keeps using the app user id it already
  cached on the device (the uid for people who signed in; an anonymous id otherwise). **Builder must
  verify this in the SDK/docs before relying on it** — it is the assumption Pro continuity rests on.
- Add `RevenueCatService.restorePurchases()` wrapping `Purchases.restorePurchases()` and a
  "Restore purchases" row in Menu next to the premium row. Show a success/failure toast; refresh Pro
  state afterwards. New user-visible string in all 11 locales.
- The RevenueCat project "Stock and Inventory" has "Transfer to new App User ID" (checked in the
  dashboard on 2026-11-26), so a restore moves the entitlement to the current id.
- RevenueCat has no Windows SDK; Pro stays off there as today.

### Data safety
No change to `DBHelper`, tables or `AppSettings` keys. The two paths that deleted or overwrote local
data from account actions (`MenuCubit.signOut` → `DBHelper.reset`, `AuthCubit.downloadUserData` →
`importFromFile`) are removed. Existing Firebase sessions on devices are simply left unused.

### Docs and release
- New ADR `docs/adr/0004-remove-accounts-and-cloud.md`, superseding ADR 0003 (banner removed) and
  0001 where it mentions the banner if relevant.
- Update `CONTEXT.md` (overview, stack, backend integrations, Sign-in row, version), ARCHITECTURE
  (startup flow, Auth section), BUSINESS_LOGIC ("Account, backup, sync"), DATABASE ("Cloud copy").
- Version bump to `1.0.97` and a "What's new" entry in 11 locales saying accounts and cloud backup
  are gone and Pro can be restored from Menu. Follow the previous release commit as the pattern.

### Verification
`flutter pub get`, codegen (`build_runner`), `flutter analyze`, `flutter test`; add a unit test for
the startup decision (stores empty → onboarding, non-empty → main, error → failure) if it can be
made without Firebase. Run on Windows (available here); Android/iOS builds are CI-only, so say so.

## Left to the builder
Folder and class names for the startup gate, exact Menu layout without the profile card, which
dead helpers (`social_button_style`, unused strings in `Config`) disappear with the code, and
removing any further import that becomes unused.

## Risks to watch
- Pro continuity assumption above.
- Hidden users of removed packages (e.g. Windows plugin registrants in the modified generated files).
- People whose only copy of data is in the cloud lose the in-app way to get it; covered by the
  What's new note, not by code.
