# Image Size and Crop Settings Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let users set the stored image size (256–2048 px, default 512) and turn the crop window on/off from General Setting, and make every image pick/capture use both settings.

**Architecture:** Two new values in the `AppSettings` facade, surfaced through `SettingsGeneralCubit` on `SettingsGeneralPage`. The size is applied only in `compressImageBytes`; with the crop window off, `EntityImagePicker` center-crops to a square (with `dart:ui`) before compressing.

**Tech Stack:** Flutter, flutter_bloc + freezed + injectable, `AppSettings` (`shared_preferences` storage), `image_picker`, `image_cropper`, `flutter_image_compress`, `easy_localization`.

**Spec:** [docs/superpowers/specs/2026-11-17-image-size-setting-design.md](../specs/2026-11-17-image-size-setting-design.md)

**Commits:** the commit steps below run only if the user has asked for commits (project/session rule: commit only on request). Otherwise skip them.

## Global Constraints

- Size range 256–2048 px, default 512; one value for width and height; shown as `512 × 512 px`.
- Crop-window switch default **on**.
- JPEG quality stays 75 at pick and 80 at compress. `pickImage` call is not changed.
- No new dependency except `flutter_test` (SDK) as a dev dependency for the new `test/` folder. No DB schema change. Existing stored images are not resized.
- Both rows are shown only when `isMobilePlatform` (`lib/common/platform_support.dart`).
- New strings go in all 11 files in `assets/translations/`, edited directly. Domain wording per CONTEXT.md. Do not hand-edit `*.freezed.dart`, `*.g.dart`, `lib/di/di.config.dart`.
- Business logic stays out of widgets (validation in `AppSettings`, state in the cubit).

## Review Focus

1. Dialog input that is empty, non-numeric, decimal, negative or outside 256–2048 → inline error, OK disabled/refused (Task 1 + Task 3).
2. Stored value missing or corrupt (0, 99999) → `getImageSize()` returns a value inside 256–2048 (Task 1).
3. Very wide or tall photo (panorama, odd pixel sizes) → center square is correct and inside bounds (Task 2).
4. Photo smaller than the setting (e.g. 300 px picked with 2048 set) → not upscaled (Task 2, manual check).
5. User cancels the picker/cropper, or camera photo has EXIF rotation → returns `null` without error / result is upright (Task 2, manual check).

---

### Task 1: Settings storage and validation

**Files:**
- Modify: `lib/data/app_settings.dart` (near `getBatchScanDelayMs`, ~line 137)
- Modify: `pubspec.yaml` (add under `dev_dependencies`: `flutter_test:` / `sdk: flutter`) — SDK package, mention it to the user when reporting
- Create: `test/app_settings_image_size_test.dart`

**Interfaces:**
- Produces (all `static` on `AppSettings`):
  - `const int minImageSize = 256`, `maxImageSize = 2048`, `defaultImageSize = 512`
  - `int clampImageSize(int value)`
  - `int? parseImageSize(String? input)` — trims; returns the number only if it is a whole number within min..max, else `null`
  - `int getImageSize()` / `void setImageSize(int value)` — key `"ImageSize"`; get returns `clampImageSize(stored ?? defaultImageSize)`
  - `bool getShowCropWindow()` / `void setShowCropWindow(bool value)` — key `"ShowCropWindow"`; default `true`

- [ ] **Step 1: Write the failing tests** in `test/app_settings_image_size_test.dart` (import `package:good_manager/data/app_settings.dart`):
  - `clampImageSize(0) == 256`, `clampImageSize(99999) == 2048`, `clampImageSize(512) == 512`
  - `parseImageSize('256') == 256`, `parseImageSize(' 2048 ') == 2048`
  - `parseImageSize('255')`, `'2049'`, `''`, `null`, `'abc'`, `'512.5'`, `'-300'` all `== null`

- [ ] **Step 2: Run** `flutter test test/app_settings_image_size_test.dart` — Expected: FAIL (members not defined).

- [ ] **Step 3: Implement** the members listed in Interfaces in `app_settings.dart`, following the `getBatchScanDelayMs` / `setBatchScanDelayMs` pattern (`_storage.getInt` / `setInt` / `getBool` / `setBool`). `parseImageSize` uses `int.tryParse(input?.trim() ?? '')` then range check.

- [ ] **Step 4: Run** `flutter test test/app_settings_image_size_test.dart` — Expected: PASS.

- [ ] **Step 5: Commit** — `git add pubspec.yaml test lib/data/app_settings.dart` · `feat: add image size and crop window settings storage`

---

### Task 2: Image pipeline (center-crop, compress, picker)

**Files:**
- Create: `lib/util/image_square_utils.dart`
- Modify: `lib/util/image_compress_utils.dart`
- Modify: `lib/util/entity_image_picker.dart:66-104` (`pickSquareImage`)
- Test: `test/image_square_utils_test.dart`

**Interfaces:**
- Consumes: `AppSettings.getImageSize()`, `AppSettings.getShowCropWindow()` (Task 1)
- Produces:
  - `({int x, int y, int side}) centerSquareRect(int width, int height)` in `image_square_utils.dart` — `side = min(width, height)`, offsets are the integer-floor centering offsets
  - `Future<Uint8List> centerCropSquare(Uint8List bytes)` in the same file — decodes with `dart:ui` (`instantiateImageCodec`), draws the `centerSquareRect` region with `PictureRecorder`/`drawImageRect`, returns PNG bytes (`ImageByteFormat.png`)
  - `Future<Uint8List> compressImageBytes(Uint8List bytes, {required int size})` — same as today but `minWidth: size, minHeight: size`; still returns `bytes` unchanged when `!isMobilePlatform`

- [ ] **Step 1: Write the failing tests** `test/image_square_utils_test.dart` for `centerSquareRect`:
  - `(1000, 600)` → `x: 200, y: 0, side: 600`
  - `(600, 1000)` → `x: 0, y: 200, side: 600`
  - `(500, 500)` → `x: 0, y: 0, side: 500`
  - `(4000, 100)` → `x: 1950, y: 0, side: 100`
  - `(101, 50)` → `x: 25, y: 0, side: 50` (odd difference floors)

- [ ] **Step 2: Run** `flutter test test/image_square_utils_test.dart` — Expected: FAIL.

- [ ] **Step 3: Implement** `centerSquareRect` and `centerCropSquare` as specified above. Dispose the decoded `ui.Image`s after encoding.

- [ ] **Step 4: Run** `flutter test test/image_square_utils_test.dart` — Expected: PASS.

- [ ] **Step 5: Change `compressImageBytes`** to the new signature (the only callers are in `entity_image_picker.dart`).

- [ ] **Step 6: Change `pickSquareImage`.** Keep the `pickImage` call and the desktop early return (pass `size: AppSettings.getImageSize()`). On mobile: if `AppSettings.getShowCropWindow()` is true, crop as today; otherwise `centerCropSquare(await pickedFile.readAsBytes())` and skip the cropper. Both branches end in `compressImageBytes(bytes, size: AppSettings.getImageSize())`. Read the settings at call time, not in a static field.

- [ ] **Step 7: Verify** `flutter analyze` — Expected: no new issues in the touched files.

- [ ] **Step 8: Commit** — `git add lib/util test/image_square_utils_test.dart` · `feat: apply image size setting and optional center-crop`

---

### Task 3: Settings UI, state, translations, docs

**Files:**
- Modify: `lib/presentation/pages/settings/general/bloc/settings_general_state.dart` (add `@Default(AppSettings.defaultImageSize) int imageSize`, `@Default(true) bool showCropWindow`; import `AppSettings` in the cubit file as already done)
- Modify: `lib/presentation/pages/settings/general/bloc/settings_general_cubit.dart`
- Create: `lib/presentation/pages/settings/general/change_image_size_dialog.dart`
- Modify: `lib/presentation/pages/settings/general/settings_general_page.dart` (after the currency item, line ~66)
- Modify: all 11 files in `assets/translations/` (insert after the `"batch_scan_delay_value"` line, line 128)
- Modify: the relevant section of `docs/BUSINESS_LOGIC.md` (add a short "Image settings" note; link to the spec, do not copy it)

**Interfaces:**
- Consumes: `AppSettings.getImageSize/setImageSize/getShowCropWindow/setShowCropWindow/parseImageSize/minImageSize/maxImageSize` (Task 1)
- Produces:
  - Cubit: `void onImageSizeChanged(int value)` and `void onShowCropWindowChanged(bool value)` — persist via `AppSettings`, then `emit(state.copyWith(...))`; initial state reads the stored values in the constructor like `currency`
  - `class ChangeImageSizeDialogWidget extends StatefulWidget` with `const ChangeImageSizeDialogWidget(this.size)`; shows an `AlertDialog` with a number-only `TextField` (`FilteringTextInputFormatter.digitsOnly`, prefilled with the current size), inline `errorText` from `AppSettings.parseImageSize == null`, "Cancel" and "OK" actions; "OK" is disabled while invalid and pops the parsed `int`; Cancel pops `null`. Modelled on `change_batch_scan_delay_dialog.dart`.
- Translation keys (English copy; translate for the other 10 locales, keep the `{}` placeholders and the `×` sign):
  - `"image_size": "Image size"`
  - `"image_size_value": "{} × {} px"` (called with the same number twice)
  - `"image_size_error": "Enter a number from {} to {}"` (min, max)
  - `"show_crop_window": "Show crop window"`

- [ ] **Step 1: State and cubit.** Add the two fields and the two methods above. Run `dart run build_runner build --delete-conflicting-outputs`; Expected: completes without errors.

- [ ] **Step 2: Dialog widget** as specified in Interfaces. Reuse the existing `ok` and `cancel` keys.

- [ ] **Step 3: Page rows.** Inside the existing `SettingsMenuCard` children, after the currency item and only `if (isMobilePlatform)`:
  - `SettingsMenuItem(icon: Icons.photo_size_select_large_outlined, title: tr("image_size"), subtitle: tr("image_size_value", args: [size, size]))` → `showDialog<int>` with `ChangeImageSizeDialogWidget(state.imageSize)`; on a non-null result call `onImageSizeChanged`
  - `SettingsSwitchItem(icon: Icons.crop_rounded, title: tr("show_crop_window"), value: state.showCropWindow, onChanged: onShowCropWindowChanged)`
  Keep `isLast: true` on the last item of the card only (move it from "reset numeration" only if these rows are placed after it; otherwise leave as is).

- [ ] **Step 4: Translations.** Add the four keys to all 11 JSON files. Verify with `grep -c '"show_crop_window"' assets/translations/*.json` — Expected: `1` for every file. Verify each file is still valid JSON (`python -c "import json,sys;[json.load(open(f,encoding='utf-8')) for f in sys.argv[1:]]" assets/translations/*.json` — Expected: no output).

- [ ] **Step 5: Docs.** Add the "Image settings" note to `docs/BUSINESS_LOGIC.md` (range, default, crop switch, mobile-only, size applied at compress).

- [ ] **Step 6: Verify** `flutter analyze` and `flutter test` — Expected: no new analyzer issues; all tests pass.

- [ ] **Step 7: Manual check on an Android/iOS device or emulator** (report what could not be run):
  - General Setting shows `512 × 512 px`; tap, enter `100` → error, OK disabled; `256` and `2048` accepted; value persists after leaving and reopening the page.
  - Crop on: pick from gallery and take a photo, crop window appears, saved Good image is square and at most the set size.
  - Crop off: no crop window; result is a centered square; a small image (≈300 px) is not enlarged; camera photo is upright (EXIF); cancelling the picker does nothing.
  - The same behaviour from Store, Supplier, Customer, Group and the Good "images information" section.

- [ ] **Step 8: Commit** — `git add lib assets docs` · `feat: image size and crop window settings on General Setting`
