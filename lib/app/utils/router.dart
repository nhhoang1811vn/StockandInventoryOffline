import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/documents/documents_page.dart';
import 'package:good_manager/app/pages/documents/save_document.dart';
import 'package:good_manager/app/pages/goods/goods_page.dart';
import 'package:good_manager/app/pages/goods/save_good.dart';
import 'package:good_manager/app/pages/goods/save_group.dart';
import 'package:good_manager/app/pages/home_page.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/stores/save_store_page.dart';
import 'package:good_manager/app/pages/stores/stores_page.dart';
import 'package:good_manager/app/pages/suppliers/save_supplier_page.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_page.dart';

class AppRouter{
  final RouteObserver<PageRoute> routeObserver;
  AppRouter() : routeObserver = RouteObserver<PageRoute>();
  Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Pages.home:
        return _buildRoute(settings, HomePage());
      case Pages.store_list:
        return _buildRoute(settings, StoresPage());
      case Pages.save_store:
        return _buildRoute(settings, SaveStorePage());
      case Pages.good_list:
        return _buildRoute(settings, GoodsPageWidget());
      case Pages.save_good:
        return _buildRoute(settings, SaveGoodPage());
      case Pages.save_group:
        return _buildRoute(settings, SaveGroupPage());

      case Pages.supplier_list:
        return _buildRoute(settings, SuppliersPage());
      case Pages.save_supplier:
        return _buildRoute(settings, SaveSupplierPage());
      case Pages.document_list:
        return _buildRoute(settings, DocumentsPage());
      case Pages.save_document:
        return _buildRoute(settings, SaveDocumentPage());
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