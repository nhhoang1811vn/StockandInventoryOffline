import 'package:flutter/material.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/app/pages/customers/customers_view.dart';
import 'package:good_manager/app/pages/documents/documents_view.dart';
import 'package:good_manager/app/pages/goods/goods_view.dart';
import 'package:good_manager/app/pages/help/help_page_dart.dart';
import 'package:good_manager/app/pages/main_page.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/save_customer/save_customer_view.dart';
import 'package:good_manager/app/pages/save_document/save_document_view.dart';
import 'package:good_manager/app/pages/save_good/save_good_view.dart';
import 'package:good_manager/app/pages/save_group/save_group_view.dart';
import 'package:good_manager/app/pages/save_store/save_store_view.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_view.dart';
import 'package:good_manager/app/pages/stores/stores_view.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_view.dart';
import 'package:good_manager/app/pages/take_picture_screen.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.main:
        return _buildRoute(settings, MainPage());
      case Pages.store_list:
        return _buildRoute(settings, StoresPage());
      case Pages.save_store:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SaveStorePage(store: args['item']));
      case Pages.good_list:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            GoodsPage(
              isSelection: args['isSelection'],
              documentType: args['documentType'],
              transactions: args['transactions'],
            ));
      case Pages.save_good:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings, SaveGoodPage(args['item'], args['quantity']));
      case Pages.save_group:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SaveGroupPage(args['item']));

      case Pages.supplier_list:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            SuppliersPage(
              isSelection: args['isSelection'],
            ));
      case Pages.save_supplier:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            SaveSupplierPage(
              item: args['item'],
            ));
      case Pages.customer_list:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            CustomersPage(
              isSelection: args['isSelection'],
            ));
      case Pages.save_customer:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            SaveCustomerPage(
              item: args['item'],
            ));
      case Pages.document_list:
        return _buildRoute(settings, DocumentsPage());
      case Pages.save_document:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SaveDocumentPage(args['item']));
      case Pages.help:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings, HelpPage(title: args['title'], content: args['content']));
      case Pages.take_picture:
        return _buildRoute(settings, TakePictureScreen(camera: cameras.first));
      default:
        return null;
    }
  }
  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}