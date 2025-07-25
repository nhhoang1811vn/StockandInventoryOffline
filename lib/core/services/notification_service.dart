import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:good_manager/domain/entities/report_type.dart';
import 'package:good_manager/presentation/pages/pages.dart';

class NotificationService {
  static late GlobalKey<NavigatorState> _navigatorKey;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init({required GlobalKey<NavigatorState> navigatorKey}) async {
    _navigatorKey = navigatorKey;

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: (NotificationResponse  response){
      _handleNotificationTap(response.payload);
    });
  }
  static void _handleNotificationTap(String? payload) {
    if (payload == null) return;
    if (payload == "reorder"){
      _navigatorKey.currentState?.pushNamed(Pages.report_detail, arguments: {"type": ReportType.RE_ORDER});
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails('low_stock_alert_id', 'low_stock_alert',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, notificationDetails, payload: payload);
  }
}
