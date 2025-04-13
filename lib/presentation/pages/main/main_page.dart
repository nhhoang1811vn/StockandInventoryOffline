import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            BlocProvider(
              create: (context) => getIt<HomeCubit>(),
              child: HomePage(key: UniqueKey(),
                onOpenGoodsPage: () => _onItemTapped(1), 
                onOpenDocumentsPage: () => _onItemTapped(2),
                onOpenPaymentsPage: () => _onItemTapped(3),
              ),
            ),
            BlocProvider(create: (context) => getIt<GoodsCubit>(),
              child: GoodsPage(key: UniqueKey(),isSelection: false,),
            ),
            BlocProvider(create: (context) => getIt<DocumentsCubit>(),
              child: DocumentsPage(key: UniqueKey()),
            ),
            BlocProvider(create: (context) => getIt<PaymentsCubit>(), child: PaymentsPage()),
            MorePage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home_title),
            BottomNavigationBarItem(icon: Icon(UIConstants.goodIconData), label: AppLocalizations.of(context)!.goods_title),
            BottomNavigationBarItem(icon: Icon(UIConstants.documentIconData), label: AppLocalizations.of(context)!.documents_title),
            BottomNavigationBarItem(icon: Icon(UIConstants.paymentIconData), label: AppLocalizations.of(context)!.payments_title),
            BottomNavigationBarItem(icon: Icon(UIConstants.settingIconData), label: AppLocalizations.of(context)!.settings_title),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ));
  }
}
