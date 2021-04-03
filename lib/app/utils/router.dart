import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/home_page.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/stores/save_store_page.dart';
import 'package:good_manager/app/pages/stores/stores_page.dart';

class AppRouter{
  final RouteObserver<PageRoute> routeObserver;
  AppRouter() : routeObserver = RouteObserver<PageRoute>();
  Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Pages.home:
        return _buildRoute(settings, HomePage());
      case Pages.store_list:
        return _buildRoute(settings, StoresPageWidget());
      case Pages.save_store:
        return _buildRoute(settings, SaveStorePageWidget());

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