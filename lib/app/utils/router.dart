import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/documents/documents_page.dart';
import 'package:good_manager/app/pages/documents/save_document.dart';
import 'package:good_manager/app/pages/goods/goods_view.dart';
import 'package:good_manager/app/pages/help/help_page_dart.dart';
import 'package:good_manager/app/pages/home_page.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/save_good/save_good.dart';
import 'package:good_manager/app/pages/save_group/save_group_view.dart';
import 'package:good_manager/app/pages/save_store/save_store_view.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_view.dart';
import 'package:good_manager/app/pages/stores/stores_view.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_view.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch(settings.name){
      case Pages.home:
        return _buildRoute(settings, HomePage());
      case Pages.store_list:
        return _buildRoute(settings, StoresPage());
      case Pages.save_store:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SaveStorePage(store: args['store'],isInsert: args['isInsert'],));
      case Pages.good_list:
        return _buildRoute(settings, GoodsPage());
      case Pages.save_good:
        return _buildRoute(settings, SaveGoodPage());
      case Pages.save_group:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings, SaveGroupPage(args['isInsert'], args['item']));

      case Pages.supplier_list:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SuppliersPage(isSelection: args['isSelection'],));
      case Pages.save_supplier:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SaveSupplierPage(isInsert: args['isInsert'], item: args['item'],));
      case Pages.document_list:
        return _buildRoute(settings, DocumentsPage());
      case Pages.save_document:
        return _buildRoute(settings, SaveDocumentPage());
      case Pages.help:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings, HelpPage(title: args['title'], content: args['content']));
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