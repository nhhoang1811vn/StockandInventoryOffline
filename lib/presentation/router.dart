import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/main.dart';
import 'package:good_manager/common/helpers/injection.container.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/barcode_scanner_page.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart';
import 'package:good_manager/presentation/pages/customers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/customers/customers_page.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart';

import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart';
import 'package:good_manager/presentation/pages/expenses/expenses_page.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/help/help_page_dart.dart';
import 'package:good_manager/presentation/pages/help/helps_page_dart.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/home_page.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/report_page.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:good_manager/presentation/pages/report_detail/report_detail_page.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart';
import 'package:good_manager/presentation/pages/save_customer/save_customer_page.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';
import 'package:good_manager/presentation/pages/save_document/save_document_view.dart';
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart';
import 'package:good_manager/presentation/pages/save_expense/save_expense_page.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/pages/save_good/save_good_view.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/presentation/pages/save_group/save_group_view.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/save_store_page.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';
import 'package:good_manager/presentation/pages/save_supplier/save_supplier_page.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';
import 'package:good_manager/presentation/pages/select_group/select_group_page.dart';
import 'package:good_manager/presentation/pages/settings/settings_page.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart';
import 'package:good_manager/presentation/pages/stores/stores_page.dart';
import 'package:good_manager/presentation/pages/suppliers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/suppliers/suppliers_page.dart';
import 'package:good_manager/presentation/pages/take_picture_screen.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.store_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<StoresCubit>(),
                  child: StoresPage(isSelection: args["isSelection"]),
                ));
      case Pages.save_store:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveStoreCubit>(),
                  child: SaveStorePage(item: args["item"]),
                ));
      case Pages.home:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<HomeCubit>(),
                  child: HomePage(),
                ));
      case Pages.document_list:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<DocumentsCubit>(),
                  child: DocumentsPage(),
                ));
      case Pages.save_document:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveDocumentCubit>(),
                  child: SaveDocumentPage(args["item"]),
                ));
      case Pages.good_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<GoodsCubit>(),
                  child: GoodsPage(
                    isSelection: args['isSelection'],
                    document: args['document']
                  ),
                ));
      case Pages.save_good:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveGoodCubit>(),
                  child: SaveGoodPage(
                      item: args['item'],
                      document: args['document'],
                      transaction: args['transaction'],
                      quantity: args['quantity']),
                ));
      case Pages.save_group:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveGroupCubit>(),
                  child: SaveGroupPage(item: args['item']),
                ));
      case Pages.supplier_list:
        Map<dynamic, dynamic>? args = settings.arguments as Map?;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SuppliersCubit>(),
                  child: SuppliersPage(isSelection: args?['isSelection']??false),
                ));
      case Pages.save_supplier:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveSupplierCubit>(),
                  child: SaveSupplierPage(
                    item: args['item'],
                  ),
                ));
      case Pages.customer_list:
        Map<dynamic, dynamic>? args = settings.arguments as Map?;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<CustomersCubit>(),
              child: CustomersPage(isSelection: args?['isSelection']??false),
            ));
      case Pages.save_customer:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<SaveCustomerCubit>(),
              child: SaveCustomerPage(
                item: args['item'],
              ),
            ));
      case Pages.helps:
        return _buildRoute(settings, HelpsPage());
      case Pages.help:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, HelpPage(title: args['title'], content: args['content']));
      case Pages.take_picture:
        return _buildRoute(settings, TakePictureScreen(camera: cameras.first));
      case Pages.expenses:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => getIt<ExpensesCubit>(), child: ExpensesPage()));
      case Pages.report:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => getIt<ReportCubit>(), child: ReportPage()));
      case Pages.report_detail:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(create: (context) => getIt<ReportDetailCubit>(), child: ReportDetailPage(args["type"],args["start"],args["end"])));


      case Pages.save_expense:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveExpenseCubit>(),
                  child: SaveExpensePage(
                    item: args["item"],
                  ),
                ));
      case Pages.settings:
        return _buildRoute(settings, SettingsPage());
      case Pages.select_group:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SelectGroupCubit>(),
                  child: SelectGroupPage(
                    args["id"],
                    args["groupId"],
                  ),
                ));
      case Pages.barcode_scanner:
        //Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) =>
                BlocProvider(create: (context) => getIt<BarcodeScannerCubit>(), child: BarcodeScannerPage()));
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
