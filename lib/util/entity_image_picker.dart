import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../common/platform_support.dart';
import '../data/app_settings.dart';
import '../presentation/widget/settings_ui.dart';
import 'image_compress_utils.dart';
import 'image_square_utils.dart';

class EntityImagePicker {
  static final _picker = ImagePicker();

  static Future<void> showSourceSheet(
    BuildContext context, {
    required Future<void> Function(Uint8List bytes) onImagePicked,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            SettingsBottomSheetTitle(title: context.tr("choose_gallery")),
            ListTile(
              contentPadding: kBottomSheetTilePadding,
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(context.tr("choose_gallery")),
              onTap: () async {
                Navigator.pop(context);
                final bytes = await pickSquareImage(ImageSource.gallery);
                if (bytes != null) {
                  await onImagePicked(bytes);
                }
              },
            ),
            if (isMobilePlatform)
              ListTile(
                contentPadding: kBottomSheetTilePadding,
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(context.tr("take_picture")),
                onTap: () async {
                  Navigator.pop(context);
                  final bytes = await pickSquareImage(ImageSource.camera);
                  if (bytes != null) {
                    await onImagePicked(bytes);
                  }
                },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static Future<Uint8List?> pickSquareImage(ImageSource source) async {
    final XFile? pickedFile;
    try {
      pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
    } on PlatformException catch (e) {
      // User denied camera / photo access: expected, not a crash.
      if (e.code == 'camera_access_denied' ||
          e.code == 'photo_access_denied') {
        return null;
      }
      rethrow;
    }
    if (pickedFile == null) return null;

    final size = AppSettings.getImageSize();

    // image_cropper has no desktop implementation: use the picked image as is.
    if (!isMobilePlatform) {
      return compressImageBytes(await pickedFile.readAsBytes(), size: size);
    }

    if (!AppSettings.getShowCropWindow()) {
      final squared = await centerCropSquare(await pickedFile.readAsBytes());
      return compressImageBytes(squared, size: size);
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'cropper'.tr(),
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          statusBarLight: false,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'cropper'.tr(),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );

    if (croppedFile == null) return null;
    final bytes = await croppedFile.readAsBytes();
    return compressImageBytes(bytes, size: size);
  }
}
