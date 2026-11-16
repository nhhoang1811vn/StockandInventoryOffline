import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:good_manager/common/platform_support.dart';

/// Thin wrapper over Firebase Analytics, which has no desktop implementation.
/// Events are dropped on platforms other than Android and iOS.
class AppAnalytics {
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!isMobilePlatform) return;
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
