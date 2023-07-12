import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/app/main.dart';
//import 'package:good_manager/presentation/pages/customers/customers_view.dart';
import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/expenses/expenses_view.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/help/help_page_dart.dart';
import 'package:good_manager/presentation/pages/home/home_view.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';
import 'package:good_manager/presentation/pages/save_supplier/save_supplier_page.dart';
import 'package:good_manager/presentation/pages/settings/settings_view.dart';
import 'package:good_manager/presentation/pages/stores/stores_view.dart';
import 'package:good_manager/presentation/pages/suppliers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/suppliers/suppliers_page.dart';
import 'package:good_manager/presentation/pages/take_picture_screen.dart';
import 'package:good_manager/common/helpers/injection.container.dart';

import '../domain/usecases/suppliers/suppliers_usecases.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  //SuppliersCubit suppliersCubit = getIt();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.home:
        return _buildRoute(settings, HomePage());
      case Pages.store_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, StoresPage(isSelection: args['isSelection']));
      //case Pages.save_store:
      //  Map<dynamic, dynamic> args = settings.arguments as Map;
      //  return _buildRoute(settings, SaveStorePage(store: args['item']));
      case Pages.good_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            GoodsPage(
              isSelection: args['isSelection'],
              documentType: args['documentType'],
              transactions: args['transactions'],
            ));
      //case Pages.save_good:
      //  Map<String, dynamic> args = settings.arguments as Map;
      //  return _buildRoute(
      //      settings, SaveGoodPage(args['item'], args['enableAddTransactions']));
      //case Pages.save_group:
      //  Map<String, dynamic> args = settings.arguments as Map;
      //  return _buildRoute(settings, SaveGroupPage(args['item']));

      case Pages.supplier_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<SuppliersCubit>(),
              child: SuppliersPage(
                isSelection: args['isSelection']
              ),));
      case Pages.save_supplier:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<SaveSupplierCubit>(),
              child: SaveSupplierPage(
          item: args['item'],
        ),));
      /*case Pages.customer_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            CustomersPage(
              isSelection: args['isSelection'],
            ));*/
      /*case Pages.save_customer:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            SaveCustomerPage(
              item: args['item'],
            ));*/
      case Pages.document_list:
        return _buildRoute(settings, DocumentsPage());
     /* case Pages.save_document:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SaveDocumentPage(args['item']));*/
      case Pages.help:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings, HelpPage(title: args['title'], content: args['content']));
      case Pages.take_picture:
        return _buildRoute(settings, TakePictureScreen(camera: cameras.first));
      case Pages.expenses:
        return _buildRoute(settings, ExpensesPage());
      /*case Pages.save_expense:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            SaveExpensePage(
              item: args['item'],
            ));*/
      case Pages.settings:
        return _buildRoute(settings, SettingsPage());
      /*case Pages.select_group:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SelectGroupPage(args['groupId']));*/
      //case Pages.barcode_scanner:
      //  return _buildRoute(settings, BarcodeScannerPage());
      default:
        return _buildRoute(settings, HomePage());
    }
  }
  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}