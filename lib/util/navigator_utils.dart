import 'package:url_launcher/url_launcher.dart';

class NavigatorUtils {
  NavigatorUtils._();

  static Future<void> openUri(Uri uri) async {
    try {
      // Using externalApplication mode is more reliable for App Store/Play Store links
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // Handle potential PlatformExceptions gracefully
      print("NavigatorUtils: Error launching URI: $e");
    }
  }

  static Future<void> openUrl(String input) async {
    try {
      var uri = Uri.parse(input);
      await openUri(uri);
    } catch (e) {
      print("NavigatorUtils: Error parsing URL: $e");
    }
  }
}
