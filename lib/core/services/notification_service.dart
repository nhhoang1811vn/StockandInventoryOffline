import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:good_manager/common/platform_support.dart';
import 'package:good_manager/presentation/pages/pages.dart';

import '../../data/app_settings.dart';
import '../../domain/entity/entity.dart';

class NotificationService {
  static late GlobalKey<NavigatorState> _navigatorKey;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    _navigatorKey = navigatorKey;
    if (!isMobilePlatform) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;
    if (payload == "reorder" && AppSettings.isMinQuantityEnabled()) {
      _navigatorKey.currentState?.pushNamed(
        Pages.report_detail,
        arguments: {"type": ReportType.RE_ORDER},
      );
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!isMobilePlatform) return;
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'low_stock_alert_id',
      'low_stock_alert',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } on PlatformException catch (e) {
      // iOS "Error 2003: Source is not authorized" = notifications denied
      // by the user. Expected, not a crash.
      if (e.code != 'Error 2003') rethrow;
    }
  }
}
