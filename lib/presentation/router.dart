import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/helpers/injection.container.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/barcode_scanner_page.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart';
import 'package:good_manager/presentation/pages/customers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/customers/customers_page.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart';
import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart';
import 'package:good_manager/presentation/pages/expenses/expenses_page.dart';
import 'package:good_manager/presentation/pages/forgotpassword/forgot_password_page.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/help/help_page_dart.dart';
import 'package:good_manager/presentation/pages/help/helps_page_dart.dart';
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/item_history_view.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';
import 'package:good_manager/presentation/pages/login/loading_data.dart';
import 'package:good_manager/presentation/pages/login/login_page.dart';
import 'package:good_manager/presentation/pages/main/main_page.dart';
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart';
import 'package:good_manager/presentation/pages/onboarding/on_boarding_page.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/payment/bloc/payments_cubit.dart';
import 'package:good_manager/presentation/pages/payment/payments_page.dart';
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
import 'package:good_manager/presentation/pages/save_payment/bloc/save_payment_cubit.dart';
import 'package:good_manager/presentation/pages/save_payment/save_payment_page.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/save_store_page.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';
import 'package:good_manager/presentation/pages/save_supplier/save_supplier_page.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';
import 'package:good_manager/presentation/pages/select_group/select_group_page.dart';
import 'package:good_manager/presentation/pages/settings/settings_page.dart';
import 'package:good_manager/presentation/pages/signup/signup_page.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart';
import 'package:good_manager/presentation/pages/stores/stores_page.dart';
import 'package:good_manager/presentation/pages/suppliers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/suppliers/suppliers_page.dart';
import 'package:good_manager/presentation/pages/take_picture_screen.dart';

import '../main.dart';

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
      case Pages.loading_data:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<AuthCubit>(),
                  child: LoadingData(),
                ));
      case Pages.main:
        return MaterialPageRoute(builder: (_) => MainPage());
      // case Pages.home:
      //   return MaterialPageRoute(
      //       builder: (_) => BlocProvider(
      //             create: (context) => getIt<HomeCubit>(),
      //             child: HomePage(),
      //           ));
      case Pages.document_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<DocumentsCubit>(),
                  child: DocumentsPage(
                    key: UniqueKey(),
                    isSelection: args["isSelection"],
                    selectionType: args["selectionType"],
                  ),
                ));
      case Pages.save_document:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveDocumentCubit>(),
                  child: SaveDocumentPage(args["item"]),
                ));
      // case Pages.payment_list:
      //   Map<dynamic, dynamic> args = settings.arguments as Map;
      //   return MaterialPageRoute(
      //       builder: (_) => BlocProvider(
      //             create: (context) => getIt<PaymentsCubit>(),
      //             child: PaymentsPage(args["documentId"]),
      //           ));
      case Pages.save_payment:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SavePaymentCubit>(),
                  child: SavePaymentPage(args["item"]),
                ));
      case Pages.good_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<GoodsCubit>(),
                  child: GoodsPage(isSelection: args['isSelection'], document: args['document'], key: UniqueKey()),
                ));
      case Pages.save_good:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<SaveGoodCubit>(),
                  child: SaveGoodPage(
                      item: args['item'],
                      //quickInsertDocument: args['quickInsertDocument'],
                      document: args['document'],
                      transaction: args['transaction']),
                ));
      case Pages.good_history:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<ItemHistoryCubit>(),
                  child: ItemHistoryPage(
                    goodId: args['goodId'],
                    start: args['start'],
                    end: args['end'],
                  ),
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
                  child: SuppliersPage(isSelection: args?['isSelection'] ?? false),
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
                  child: CustomersPage(isSelection: args?['isSelection'] ?? false),
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
            builder: (_) => BlocProvider(
                create: (context) => getIt<ReportDetailCubit>(),
                child: ReportDetailPage(
                  args["type"],
                  args["start"],
                  args["end"],
                  args["groupId"],
                  args["groupName"],
                )));

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
      case Pages.signup:
        return _buildRoute(settings, BlocProvider(create: (context) => getIt<AuthCubit>(), child: SignUpScreen()));

      case Pages.signIn:
        return _buildRoute(settings, BlocProvider(create: (context) => getIt<AuthCubit>(), child: LoginScreen()));

      case Pages.forgotPassword:
        return _buildRoute(
            settings, BlocProvider(create: (context) => getIt<AuthCubit>(), child: ForgotPasswordScreen()));
      case Pages.onboarding:
        return _buildRoute(
            settings, BlocProvider(create: (context) => getIt<OnBoardingCubit>(), child: OnBoardingPage()));

      default:
        return _buildRoute(settings, MainPage());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
