import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/menu/bloc/menu_cubit.dart';
import 'package:good_manager/presentation/pages/menu/menu_page.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/report_page.dart';
import 'package:good_manager/presentation/utils.dart';

import '../../../core/services/app_lock_service.dart';
import '../../../core/services/low_stock_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/app_settings.dart';
import '../../../di/di.dart';
import '../../../domain/entity/entity.dart';
import '../home/bloc/home_cubit.dart';
import '../home/home_page.dart';
import '../pages.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<GoodsCubit>(create: (_) => getIt<GoodsCubit>()),
        BlocProvider<ReportCubit>(create: (_) => getIt<ReportCubit>()),
        BlocProvider<MenuCubit>(create: (_) => getIt<MenuCubit>()),
      ],
      child: MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenState();
}

class _ScreenState extends State<MainView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomePage(
        onOpenGoodsPage: () => setState(() => _currentIndex = 1),
        onOpenDocumentsPage: () {
          Navigator.of(context).pushNamed(Pages.document_list, arguments: {
            "documentType": null,
            "isSelection": false,
            "setting": null,
          });
        },
        onOpenMenuPage: () => setState(() => _currentIndex = 3),
      ),
      GoodsPage(isSelection: false),
      ReportPage(),
      MenuPage(),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lock = getIt<AppLockService>();
      lock.showLock();
      lock.start();
    });

    var isShowLowStockAlert =
        AppSettings.getMinimumQuantitySettings().showAlert;
    if (isShowLowStockAlert) {
      _requestPermissions();
      Future.delayed(const Duration(seconds: 3), () {
        _checkLowStockAndShowAlert();
      });
    }
  }

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> _checkLowStockAndShowAlert() async {
    final lowStockService = getIt<LowStockService>();
    final hasLowStock = await lowStockService.hasLowStock();

    if (hasLowStock && mounted) {
      await NotificationService.showNotification(
        id: 0,
        title: context.tr("notification_low_stock_alert_title"),
        body: context.tr("notification_low_stock_alert_message"),
        payload: "reorder",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? (isDark ? Colors.black : Colors.white),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // The bar height comes from its content (the 60px scan button plus
      // padding); SafeArea adds the platform's bottom inset (home indicator /
      // navigation bar) under it, so no fixed height is needed.
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              Icons.home_outlined,
              Icons.home_rounded,
              context.tr("home"),
            ),
            _buildNavItem(
              1,
              Icons.inventory_2_outlined,
              Icons.inventory_2_rounded,
              context.tr("inventory"),
            ),
            _buildScanButton(),
            _buildNavItem(
              2,
              Icons.analytics_outlined,
              Icons.analytics_rounded,
              context.tr("reports"),
            ),
            _buildNavItem(
              3,
              Icons.settings_outlined,
              Icons.settings_rounded,
              context.tr("setting"),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final theme = Theme.of(context);
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() => _currentIndex = index);
            if (index == 0) {
              context.read<HomeCubit>().refreshSelectedStore();
              context.read<HomeCubit>().initState();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSelected ? activeIcon : icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Semantics(
      button: true,
      label: context.tr("menu_item_barcode_scanner"),
      child: GestureDetector(
        onTap: () async {
          String? barcode = await Utils.scanBarcode(context);
          if (barcode != null && barcode.isNotEmpty && context.mounted) {
            final homeState = context.read<HomeCubit>().state;
            final existingGood = homeState.allGoods
                .where((g) => g.barCode == barcode)
                .firstOrNull;

            if (existingGood != null) {
              Navigator.of(context).pushNamed(
                Pages.save_good,
                arguments: {'item': existingGood},
              );
            } else {
              final newGood = Good();
              newGood.barCode = barcode;
              newGood.name = barcode;
              newGood.storeId = AppSettings.getSelectedStoreId();
              Navigator.of(context).pushNamed(
                Pages.save_good,
                arguments: {'item': newGood},
              );
            }
          }
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: theme.colorScheme.onPrimary,
            size: 30,
          ),
        ),
      ),
    );
  }
}
