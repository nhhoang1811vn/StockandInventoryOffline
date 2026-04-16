import 'package:url_launcher/url_launcher.dart';

class NavigatorUtils {
  NavigatorUtils._();

  static Future<void> openUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri
      );
    }
  }

  static Future<void> openUrl(String input) async {
    var uri = Uri.parse(input);
    await openUri(uri);
  }
}
