import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_native_contact_picker_plus/flutter_native_contact_picker_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact_import_mapper.dart';

/// Picks one contact with the system picker and maps it to [ContactFields].
class ContactImportService {
  ContactImportService._();

  /// The system contact picker exists on Android and iOS only.
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Only Android asks for contacts permission (to get email, address,
  /// company and notes). On iOS the plugin reads `CNContact.note` once access
  /// is granted, which can raise an uncatchable native exception without the
  /// notes entitlement, so iOS stays on the permission-free name + phones path.
  static bool shouldRequestPermission(TargetPlatform platform) =>
      platform == TargetPlatform.android;

  /// Asks for contacts permission where [shouldRequestPermission] says so (a
  /// denial is fine: the plugin then returns name and phone only), opens the
  /// picker and returns the mapped contact.
  /// Returns null when the user cancels or the picker fails.
  static Future<ContactFields?> pickContact() async {
    try {
      if (!kIsWeb && shouldRequestPermission(defaultTargetPlatform)) {
        await Permission.contacts.request();
      }
      final contact = await FlutterContactPickerPlus().selectContact();
      if (contact == null) return null;
      return mapContact(contact);
    } on PlatformException {
      return null;
    }
  }
}
