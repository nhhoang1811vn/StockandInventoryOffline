# Unlock with fingerprint — design (short)

## Intent and why
Passcode users want a faster way to open the app. Add an "Unlock with fingerprint" toggle in
General Settings; when on, opening the app prompts for fingerprint instead of making the user type
the passcode.

## Goals
- Toggle "Unlock with fingerprint" in General Settings, visible only while passcode lock is on.
- App start with the toggle on: the fingerprint prompt appears immediately; success unlocks.
- Passcode always remains the fallback (cancel, failure, lockout, unsupported).

## Non-goals / anti-goals
- Not a replacement for the passcode: fingerprint never works without a passcode set.
- No custom lock screen, no re-lock on resume (current behaviour: lock only at `MainPage` start).
- Must never lock a user out of the app.

## Constraints
- New dependency `local_auth` — approved by the user. Android: `USE_BIOMETRIC` permission
  (`MainActivity` is already `FlutterFragmentActivity`). iOS: `NSFaceIDUsageDescription`.
- `flutter_screen_lock` 9.2.2+2 provides `onOpened`, `customizedButtonChild`, `customizedButtonTap`.
- Follow AGENTS.md: Cubit logic in `SettingsGeneralCubit`, preferences via `AppSettings`, strings in
  all 11 files in `assets/translations/`, update docs, run codegen/analyze.

## Approaches
- **A (chosen):** keep the existing `screenLock` in `_showLockScreen()`; call
  `local_auth.authenticate()` from `onOpened`; a fingerprint icon in `customizedButtonChild` retries.
  Least code, passcode is always on screen as fallback.
- B: fingerprint first, show `screenLock` only on failure. Closer to "instead of passcode" but
  needs a cover screen to avoid exposing content; more code and risk.
- C: custom lock screen. Too heavy for this feature.

## Design (my calls, open to correction)
- `AppSettings`: new key `EnableFingerprint` with `setEnableFingerprint` / `getEnableFingerprint`
  (default false).
- Settings state + `SettingsGeneralCubit`: add `enableFingerprint` and `canUseBiometrics`
  (from `LocalAuthentication.canCheckBiometrics` / `getAvailableBiometrics`, false on Windows if
  unsupported). Toggle shown only if `enablePasscode && canUseBiometrics`.
- Enabling the toggle runs one `authenticate()`; only a success saves `true`.
- Turning passcode off also sets fingerprint to false.
- `MainPage._showLockScreen()`: if `getEnableFingerprint()`, `onOpened` calls `authenticate()`;
  on success `Navigator.pop`; on any failure/exception do nothing (passcode stays). Retry via the
  fingerprint button. Guard against double pop if the user types the passcode meanwhile.
- Wrap `local_auth` in a small helper/service (injectable) so it is testable and kept out of widgets.
- Translations: label for the toggle, the biometric prompt reason, and a not-available message,
  added to all 11 locales.
- Docs: update `docs/BUSINESS_LOGIC.md` (passcode section) and `CONTEXT.md` stack table.

## Left to the builder
Exact helper name/location, icon choice, exact translation wording, whether `onOpened` needs a
post-frame delay on iOS.
