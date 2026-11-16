import 'dart:io';

/// True on Android and iOS, the only platforms where the mobile-only plugins
/// (RevenueCat, Crashlytics, Analytics, notifications, image compress/crop,
/// Google/Apple sign-in) are available.
bool get isMobilePlatform => Platform.isAndroid || Platform.isIOS;

/// True on Windows, Linux and macOS.
bool get isDesktopPlatform =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;
