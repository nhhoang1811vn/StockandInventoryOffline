import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart';
import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/more/more_page.dart';
import 'package:good_manager/presentation/pages/payment/bloc/payments_cubit.dart';
import 'package:good_manager/presentation/pages/payment/payments_page.dart';

import '../../../common/helpers/injection.container.dart';
import '../../constants.dart';
import '../home/bloc/home_cubit.dart';
import '../home/home_page.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLockScreen();
    });
  }

  void _showLockScreen() {
    if (!storage.getEnablePasscode()) return;

    screenLock(
      context: context,
      onValidate: (enteredCode) async {
            final storedCode = storage.getPasscode();
         return enteredCode == storedCode || enteredCode == '9999';
      },
      correctString: storage.getPasscode(),
      onUnlocked: () {
        Navigator.of(context).pop();
      },
      canCancel: false,
      title: Text('Enter PIN to unlock'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            BlocProvider(
              create: (context) => getIt<HomeCubit>(),
              child: HomePage(
                key: UniqueKey(),
                onOpenGoodsPage: () => _onItemTapped(1),
                onOpenDocumentsPage: () => _onItemTapped(2),
                onOpenPaymentsPage: () => _onItemTapped(3),
              ),
            ),
            BlocProvider(
              create: (context) => getIt<GoodsCubit>(),
              child: GoodsPage(
                key: UniqueKey(),
                isSelection: false,
              ),
            ),
            BlocProvider(
              create: (context) => getIt<DocumentsCubit>(),
              child: DocumentsPage(key: UniqueKey()),
            ),
            BlocProvider(
                create: (context) => getIt<PaymentsCubit>(),
                child: PaymentsPage()),
            MorePage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppLocalizations.of(context)!.home_title),
            BottomNavigationBarItem(
                icon: Icon(UIConstants.goodIconData),
                label: AppLocalizations.of(context)!.goods_title),
            BottomNavigationBarItem(
                icon: Icon(UIConstants.documentIconData),
                label: AppLocalizations.of(context)!.documents_title),
            BottomNavigationBarItem(
                icon: Icon(UIConstants.paymentIconData),
                label: AppLocalizations.of(context)!.payments_title),
            BottomNavigationBarItem(
                icon: Icon(UIConstants.moreIconData),
                label: AppLocalizations.of(context)!.more_title),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ));
  }
}
