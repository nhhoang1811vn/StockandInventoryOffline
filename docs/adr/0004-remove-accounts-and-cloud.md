# Remove accounts and cloud features

Release 1.0.97 removes sign-up, sign-in, account linking, sign-out, delete account, cloud backup
(Firebase Storage) and the one-way Realtime Database push. The app is purely local.
The Home card for the Online app is kept, but it no longer syncs data: it only offers to download
the app, and its popup returns under new prefs keys. Amends [0003](0003-keep-home-migration-banner.md).

## Consequences

- Local SQLite data is untouched: no schema change, no migration. The only code paths that deleted or
  overwrote local data from account actions (`MenuCubit.signOut`, `AuthCubit.downloadUserData`) are gone.
- Pro stays tied to the store account in RevenueCat. The app stops calling `Purchases.logIn` and
  `logOut`, so devices keep the cached app user id. Reinstall or a new phone uses Menu > Restore
  purchases. This relies on the RevenueCat project setting "Transfer to new App User ID".
- Cloud copies already uploaded stay in Firebase Storage but the app can no longer download them.
  Users keep a copy with Backup and restore (JSON file). The 1.0.97 What's new says so.
- Packages removed: `firebase_auth`, `firebase_storage`, `firebase_database`, `google_sign_in`,
  `sign_in_with_apple`, `desktop_webview_auth`. `firebase_core`, Analytics and Crashlytics stay.
- Not changed, to avoid signing risk that only CI can verify: `ios/Runner/Runner.entitlements`
  (Sign in with Apple capability), `GoogleService-Info.plist`, `ios/Podfile.lock`.
