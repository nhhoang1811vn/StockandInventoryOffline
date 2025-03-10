import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart';
import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/more/more_page.dart';

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
              child: HomePage(key: UniqueKey(),onOpenGoodsPage: () => _onItemTapped(1), onOpenDocumentsPage: () => _onItemTapped(2),),
            ),
            BlocProvider(create: (context) => getIt<GoodsCubit>(),
              child: GoodsPage(key: UniqueKey(),isSelection: false,),
            ),
            BlocProvider(create: (context) => getIt<DocumentsCubit>(),
              child: DocumentsPage(key: UniqueKey()),
            ),
            MorePage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Image(image: AssetImage('assets/images/dashboard.png'), width: 24), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Image(image: AssetImage('assets/images/box.png'), width: 24), label: 'Goods'),
            BottomNavigationBarItem(icon: Image(image: AssetImage('assets/images/document.png'), width: 24), label: 'Documents'),
            BottomNavigationBarItem(icon: Icon(UIConstants.moreIconData), label: 'More'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ));
  }
}
