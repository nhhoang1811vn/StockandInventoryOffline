# Image size and crop settings — design (short)

Status: awaiting approval. Date: 2026-11-17.

## Intent and why
Users want lighter images (smaller database and backup). General Setting gets two options that
control images picked or captured for Goods, Stores, Suppliers, Customers and Groups.

## Goals
- Row "Image size" on `SettingsGeneralPage`, shows current value as `512 × 512 px`.
  Tap opens a dialog with a numeric field. Valid range 256–2048, default 512. Out-of-range or
  empty input shows an inline error and the dialog cannot be confirmed.
- Switch "Show crop window", default **on** (keeps today's behaviour).
- Every image pick/capture path uses both settings. All paths already go through
  `EntityImagePicker.pickSquareImage` (`lib/util/entity_image_picker.dart`).

## Non-goals / anti-goals
- One value for width and height (the cropper is locked to square). No separate fields.
- Existing stored images are not resized.
- JPEG quality (75 at pick, 80 at compress) is unchanged.
- No new dependency. No change to the DB schema.

## Approaches
- **A (chosen by user, final). Resize only in the final compress step**: best crop quality (crop
  runs on the original), stored size equals the setting. The cropper still loads the
  full-resolution image, as it does today.
- B. Resize at pick time (`maxWidth`/`maxHeight` on `pickImage`): lighter for the cropper, but a
  small crop region can end up below the setting. Considered first, then dropped by the user.
- A + B: not needed.

## Design
- `AppSettings`: add `getImageSize()` / `setImageSize()` (int, default 512, clamped to 256–2048)
  and `getShowCropWindow()` / `setShowCropWindow()` (bool, default true), stored through
  `_storage` like `getBatchScanDelayMs`. Min/max/default constants live in `AppSettings`.
- `SettingsGeneralCubit` / state: add `imageSize` and `showCropWindow` fields and
  `onImageSizeChanged`, `onShowCropWindowChanged` (same pattern as currency). Regenerate freezed.
- `settings_general_page.dart`: one `SettingsMenuItem` (opens the dialog) and one
  `SettingsSwitchItem`, placed after Currency. The dialog is a small new widget file next to the
  page, in the style of `change_batch_scan_delay_dialog.dart`. Validation lives in the dialog/cubit,
  not in the page.
- `EntityImagePicker.pickSquareImage`: `pickImage` call unchanged. If the crop window is on, crop
  as today. If off, skip the cropper and **center-crop** the picked image to a square (largest
  centered square, so the result is always 1:1). Either way the bytes then go through
  `compressImageBytes`.
- Center-crop helper (new, in `lib/util/`, next to `image_compress_utils.dart`): decode with
  `dart:ui` (`instantiateImageCodec`), draw the centered square region with `PictureRecorder` /
  `drawImageRect`, encode back to bytes. No new dependency (`image` package is not in
  `pubspec.yaml`). Mobile only, like the rest of the pipeline.
- `compressImageBytes`: replace the fixed 500 with the setting (`minWidth`/`minHeight` = size).
  This is the only place the size is applied, so the final image is at most size × size. Quality
  stays 80.
- Translations: add keys for the row title, dialog title, error message and switch title to all
  11 files in `assets/translations/`.

## Calls made by the builder (not decided by the user — please check)
1. Switch default is **on**, so nothing changes for existing users except the 500 → 512 size.
2. With the crop window off, images are center-cropped to a square (user's decision), so every
   place that shows images keeps working. Builder must check that camera photos keep the right
   orientation (EXIF) after the `dart:ui` decode; if not, fix inside the helper.
3. On Windows no crop/compress runs (`isMobilePlatform`), so neither setting has any effect
   there. Proposal: show the two rows only on mobile.
4. Dialog uses a number-only text field, no slider.

## Verification
`flutter analyze`, codegen, manual check on a device or emulator (pick + camera, crop on and
off, value at the 256/2048 limits). No test suite exists; add a small unit test for clamping
if logic is extracted.
