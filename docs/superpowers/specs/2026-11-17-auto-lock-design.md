# Lock after N minutes of inactivity — design (short)

## Intent and why
The lock screen only appears once, at app start. Users who leave the app open (or in the
background) stay unlocked indefinitely. Re-lock the app after N idle minutes.

## Goals
- One row "Lock after N minutes of inactivity" in General Settings, always visible (no on/off switch),
  where the user types the number of minutes (the row title shows the current N).
- Default **30 minutes**, always active, but it only has an effect for users who have passcode lock on
  (owner decision). Users without passcode are never locked.
- After N minutes with no touch, the existing lock screen (passcode, plus fingerprint if enabled)
  is shown over whatever screen is open.
- Idle time counts while the app is in the background: returning after >= N minutes locks at once.

## Non-goals / anti-goals
- No lock for users with passcode off. Never lock the lock screen twice. Never block unlocking.
- Not a security timeout for long operations: a backup/scan running while locked keeps running.
- No new dependency.

## Constraints
- Follow AGENTS.md (cubit logic, `AppSettings` facade, 11 translation files, docs, codegen).
- Existing cold-start lock behaviour is unchanged; fingerprint behaviour reused as is.

## Approaches
- **A (chosen):** `AppLockService` (app level) owns the idle clock and showing the lock;
  a `Listener` in `MaterialApp.builder` and a lifecycle observer in `MyAppState` feed it.
- B: logic inside `MainPage` — rejected: pushed routes/dialogs are outside it, so touches there
  would not count and locking could not cover them.
- C: idle-detection package — rejected: needless dependency.

## Design (my calls)
- `AppSettings`: `AutoLockMinutes` (int, default 30,
  range 1–1440). Pure static `clampAutoLockMinutes` / `parseAutoLockMinutes(String?)` returning
  null for empty/non-integer/out-of-range (same style as image size), plus getters/setters.
- `lib/core/services/app_lock_service.dart`, `@lazySingleton`:
  `start(GlobalKey<NavigatorState>)`, `markActivity()`, `onLifecycleChanged(AppLifecycleState)`,
  `showLock()` (extracted from `MainPage._showLockScreen`, includes `_lockOpen` guard and
  fingerprint), and a pure `static bool shouldLock({required DateTime lastActivity,
  required DateTime now, required int minutes})`.
  A 10-second periodic timer compares timestamps; it locks only when passcode is on, no lock is open, and the elapsed time >= N minutes. Unlocking resets the clock.
- Active only after `MainPage` starts it (so the cold-start lock stays in `MainPage` and there is
  no double lock at startup). `MainPage._showLockScreen` calls `AppLockService.showLock()`.
- Hooks: `Listener(onPointerDown/Move/Up)` wrapping the app in `MaterialApp.builder` calls
  `markActivity()`; `MyAppState` becomes a `WidgetsBindingObserver`: on resume check elapsed time
  and lock if needed; on pause record the timestamp.
- UI: a single always-visible row titled "Lock after N minutes of inactivity" (N filled in) that
  opens a number dialog titled with the same sentence (modelled on `ChangeImageSizeDialogWidget`,
  inline error outside 1–1440, OK refused). `SettingsGeneralCubit` gets
  `onAutoLockMinutesChanged(int)`. There is no switch to turn auto-lock off.
- Translations (all 11): row title with `{}` for N, dialog title with a literal "N", minutes suffix, range error.
- Docs: `docs/BUSINESS_LOGIC.md` Passcode section; mention in `CONTEXT.md` if the module list needs it.

## Left to the builder
Exact string wording, timer interval fine-tuning, widget placement details, whether the
`Listener` needs `HitTestBehavior.translucent`.
