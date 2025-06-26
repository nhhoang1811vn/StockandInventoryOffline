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
  void _onItemTappedWithContext(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      context.read<HomeCubit>().initState();
    }else if (index == 1){
      context.read<GoodsCubit>().initState(false, null);
    }else if (index == 2){
      context.read<DocumentsCubit>().initState();
    }else if (index == 3){
      context.read<PaymentsCubit>().init(null);
    }
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<GoodsCubit>(create: (_) => getIt<GoodsCubit>()),
        BlocProvider<DocumentsCubit>(create: (_) => getIt<DocumentsCubit>()),
        BlocProvider<PaymentsCubit>(create: (_) => getIt<PaymentsCubit>()),
      ],
      child: Builder(
        builder: (mContext) {
          return Scaffold(
              body: IndexedStack(
                index: _selectedIndex,
                children: [
                  HomePage(
                    onOpenGoodsPage: () => _onItemTappedWithContext(1, mContext),
                    onOpenDocumentsPage: () => _onItemTappedWithContext(2, mContext),
                    onOpenPaymentsPage: () => _onItemTappedWithContext(3, mContext),
                  ),
                  GoodsPage(isSelection: false),
                  DocumentsPage(),
                  PaymentsPage(),
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
                //selectedItemColor: Colors.blue,
                //unselectedItemColor: Colors.grey,
                //showUnselectedLabels: true,
                onTap: (index){
                  _onItemTappedWithContext(index, mContext);
                },
              ));
        }
      ),
    );
  }
}
