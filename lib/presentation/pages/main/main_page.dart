import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart';
import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/menu/bloc/menu_cubit.dart';
import 'package:good_manager/presentation/pages/menu/menu_page.dart';
import 'package:good_manager/presentation/pages/payment/bloc/payments_cubit.dart';
import 'package:good_manager/presentation/pages/payment/payments_page.dart';

import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
import '../../../di/di.dart';
import '../../../util/util.dart';
import '../home/bloc/home_cubit.dart';
import '../home/home_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<GoodsCubit>(create: (_) => getIt<GoodsCubit>()),
        BlocProvider<DocumentsCubit>(create: (_) => getIt<DocumentsCubit>()),
        BlocProvider<PaymentsCubit>(create: (_) => getIt<PaymentsCubit>()),
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

class _ScreenState extends State<MainView> with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomePage(
        onOpenGoodsPage: () {
          _controller.animateTo(1);
        },
        onOpenDocumentsPage: () {
          _controller.animateTo(2);
        },
        onOpenPaymentsPage: () {
          _controller.animateTo(3);
        },
      ),
      GoodsPage(isSelection: false),
      DocumentsPage(),
      PaymentsPage(),
      MenuPage(),
    ];
    _controller = TabController(length: _screens.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLockScreen();
    });
  }

  void _showLockScreen() {
    if (!AppSettings.getEnablePasscode()) return;

    screenLock(
      context: context,
      onValidate: (enteredCode) async {
        final storedCode = AppSettings.getPasscode();
        return enteredCode == storedCode || enteredCode == '9999';
      },
      correctString: AppSettings.getPasscode(),
      onUnlocked: () {
        Navigator.of(context).pop();
      },
      canCancel: false,
      title: Text(context.tr("enter_pin_to_unlock")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: _screens,
            ),
          ),
          TabBar(
            labelPadding: EdgeInsets.zero,
            labelStyle: TextStyle(
              fontSize: Dimens.textSmall,
            ),
            controller: _controller,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: context.tr("home"),
              ),
              Tab(
                icon: Icon(UIConstants.goodIconData),
                text: context.tr("goods"),
              ),
              Tab(
                icon: Icon(UIConstants.documentIconData),
                text: context.tr("documents"),
              ),
              Tab(
                icon: Icon(UIConstants.paymentIconData),
                text: context.tr("payments"),
              ),
              Tab(
                icon: Icon(UIConstants.moreIconData),
                text: context.tr("menu"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
