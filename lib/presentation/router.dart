import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/barcode_scanner_page.dart';
import 'package:good_manager/presentation/pages/barcode_scanner_settings/barcode_scanner_settings_page.dart';
import 'package:good_manager/presentation/pages/barcode_scanner_settings/bloc/barcode_scanner_settings_cubit.dart';
import 'package:good_manager/presentation/pages/customers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/customers/customers_page.dart';
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart';
import 'package:good_manager/presentation/pages/documents/documents_view.dart';
import 'package:good_manager/presentation/pages/documents_history/bloc/documents_history_cubit.dart';
import 'package:good_manager/presentation/pages/documents_history/documents_history_page.dart';
import 'package:good_manager/presentation/pages/forgotpassword/forgot_password_page.dart';
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart';
import 'package:good_manager/presentation/pages/goods/goods_view.dart';
import 'package:good_manager/presentation/pages/help/help_page_dart.dart';
import 'package:good_manager/presentation/pages/help/helps_page_dart.dart';
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart';
import 'package:good_manager/presentation/pages/history/item_history_view.dart';
import 'package:good_manager/presentation/pages/linkwith/link_with_page.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';
import 'package:good_manager/presentation/pages/login/loading_data.dart';
import 'package:good_manager/presentation/pages/login/login_page.dart';
import 'package:good_manager/presentation/pages/main/main_page.dart';
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart';
import 'package:good_manager/presentation/pages/onboarding/on_boarding_page.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/payment/bloc/payments_cubit.dart';
import 'package:good_manager/presentation/pages/payment/payments_page.dart';
import 'package:good_manager/presentation/pages/payment_categories/bloc/payment_categories_cubit.dart';
import 'package:good_manager/presentation/pages/payment_categories/payment_categories_page.dart';
import 'package:good_manager/presentation/pages/payment_history/bloc/payment_history_cubit.dart';
import 'package:good_manager/presentation/pages/payment_history/payment_history_view.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/report_page.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';
import 'package:good_manager/presentation/pages/report_detail/report_detail_page.dart';
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart';
import 'package:good_manager/presentation/pages/save_customer/save_customer_page.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';
import 'package:good_manager/presentation/pages/save_document/save_document_view.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';
import 'package:good_manager/presentation/pages/save_good/save_good_view.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/presentation/pages/save_group/save_group_view.dart';
import 'package:good_manager/presentation/pages/save_payment/bloc/save_payment_cubit.dart';
import 'package:good_manager/presentation/pages/save_payment/save_payment_page.dart';
import 'package:good_manager/presentation/pages/save_payment_category/bloc/save_payment_category_cubit.dart';
import 'package:good_manager/presentation/pages/save_payment_category/save_payment_category_page.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/save_store_page.dart';
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart';
import 'package:good_manager/presentation/pages/save_supplier/save_supplier_page.dart';
import 'package:good_manager/presentation/pages/save_wallet/bloc/save_wallet_cubit.dart';
import 'package:good_manager/presentation/pages/save_wallet/save_wallet_page.dart';
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart';
import 'package:good_manager/presentation/pages/select_group/select_group_page.dart';
import 'package:good_manager/presentation/pages/settings/data/bloc/settings_data_cubit.dart';
import 'package:good_manager/presentation/pages/settings/data/settings_data_page.dart';
import 'package:good_manager/presentation/pages/settings/general/bloc/settings_general_cubit.dart';
import 'package:good_manager/presentation/pages/settings/general/settings_general_page.dart';
import 'package:good_manager/presentation/pages/settings/minimum_quantity/bloc/minimum_quantity_cubit.dart';
import 'package:good_manager/presentation/pages/settings/minimum_quantity/minimum_quantity_page.dart';
import 'package:good_manager/presentation/pages/settings/my_company/bloc/my_company_cubit.dart';
import 'package:good_manager/presentation/pages/settings/my_company/my_company_page.dart';
import 'package:good_manager/presentation/pages/settings/settings_page.dart';
import 'package:good_manager/presentation/pages/settings/view/bloc/settings_view_cubit.dart';
import 'package:good_manager/presentation/pages/settings/view/settings_view_page.dart';
import 'package:good_manager/presentation/pages/signup/signup_page.dart';
import 'package:good_manager/presentation/pages/splash_page.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart';
import 'package:good_manager/presentation/pages/stores/stores_page.dart';
import 'package:good_manager/presentation/pages/suppliers/bloc/bloc.dart';
import 'package:good_manager/presentation/pages/suppliers/suppliers_page.dart';

import '../di/di.dart';

class AppRouter {
  final RouteObserver<PageRoute> routeObserver;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouter() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.payment_history:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<PaymentHistoryCubit>(),
            child: PaymentHistoryPage(
              documentId: args['documentId'],
            ),
          ),
        );
      case Pages.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Pages.store_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<StoresCubit>(),
            child: StoresPage(isSelection: args["isSelection"]),
          ),
        );
      case Pages.save_store:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveStoreCubit>(),
            child: SaveStorePage(item: args["item"]),
          ),
        );
      case Pages.loading_data:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: LoadingData(),
          ),
        );
      case Pages.main:
        return MaterialPageRoute(builder: (_) => MainPage());
      case Pages.document_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<DocumentsCubit>(),
            child: DocumentsPage(
              //key: UniqueKey(),
              documentType: args["documentType"],
              isSelection: args["isSelection"],
              setting: args["setting"],
            ),
          ),
        );
      case Pages.documents_history:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<DocumentsHistoryCubit>(),
            child: DocumentsHistoryPage(
              supplierId: args["supplierId"],
              customerId: args["customerId"],
              start: args['start'],
              end: args['end'],
            ),
          ),
        );
      case Pages.save_document:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveDocumentCubit>(),
            child: SaveDocumentPage(args["item"]),
          ),
        );
      case Pages.save_payment:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SavePaymentCubit>(),
            child: SavePaymentPage(args["item"]),
          ),
        );
      case Pages.save_payment_category:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SavePaymentCategoryCubit>(),
            child: SavePaymentCategoryPage(args["item"]),
          ),
        );
      case Pages.good_list:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<GoodsCubit>(),
            child: GoodsPage(
              isSelection: args['isSelection'],
              document: args['document'],
            ),
          ),
        );
      case Pages.save_good:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveGoodCubit>(),
            child: SaveGoodPage(
              item: args['item'],
              document: args['document'],
              transaction: args['transaction'],
            ),
          ),
        );
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
          ),
        );
      case Pages.save_group:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveGroupCubit>(),
            child: SaveGroupPage(item: args['item']),
          ),
        );
      case Pages.supplier_list:
        Map<dynamic, dynamic>? args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SuppliersCubit>(),
            child: SuppliersPage(isSelection: args?['isSelection'] ?? false),
          ),
        );
      case Pages.save_supplier:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveSupplierCubit>(),
            child: SaveSupplierPage(
              item: args['item'],
            ),
          ),
        );
      case Pages.customer_list:
        Map<dynamic, dynamic>? args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CustomersCubit>(),
            child: CustomersPage(isSelection: args?['isSelection'] ?? false),
          ),
        );
      case Pages.save_customer:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveCustomerCubit>(),
            child: SaveCustomerPage(
              item: args['item'],
            ),
          ),
        );
      case Pages.helps:
        return _buildRoute(settings, HelpsPage());
      case Pages.help:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(
          settings,
          HelpPage(title: args['title'], content: args['content']),
        );
      case Pages.report:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReportCubit>(),
            child: ReportPage(),
          ),
        );
      case Pages.report_detail:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ReportDetailCubit>(),
            child: ReportDetailPage(
              args["type"],
              args["start"],
              args["end"],
            ),
          ),
        );

      case Pages.save_wallet:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SaveWalletCubit>(),
            child: SaveWalletPage(
              args["item"],
            ),
          ),
        );
      case Pages.settings:
        return _buildRoute(settings, SettingsPage());
      case Pages.settings_view:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SettingsViewCubit>(),
            child: SettingsViewPage(),
          ),
        );
      case Pages.settings_minimum_quantity:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<MinimumQuantityCubit>(),
            child: MinimumQuantityPage(),
          ),
        );
      case Pages.settings_data:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SettingsDataCubit>(),
            child: SettingsDataPage(),
          ),
        );
      case Pages.settings_general:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SettingsGeneralCubit>(),
            child: SettingsGeneralPage(),
          ),
        );
      case Pages.settings_my_company:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<MyCompanyCubit>(),
            child: MyCompanyPage(),
          ),
        );
      case Pages.select_group:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SelectGroupCubit>(),
            child: SelectGroupPage(
              args["id"],
              args["groupId"],
            ),
          ),
        );
      case Pages.barcode_scanner:
        return MaterialPageRoute(builder: (_) => BarcodeScannerPage());
      case Pages.barcode_scanner_settings:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<BarcodeScannerSettingsCubit>(),
            child: BarcodeScannerSettingsPage(),
          ),
        );
      case Pages.signup:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: SignUpPage(),
          ),
        );
      case Pages.signIn:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: LoginPage(),
          ),
        );
      // case Pages.upgrade_account:
      //   return _buildRoute(
      //     settings,
      //     BlocProvider(
      //       create: (context) => getIt<AuthCubit>(),
      //       child: LoginScreen(),
      //     ),
      //   );
      case Pages.link_with:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: LinkWithPage(),
          ),
        );

      case Pages.forgotPassword:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: ForgotPasswordPage(),
          ),
        );
      case Pages.onboarding:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<OnBoardingCubit>(),
            child: OnBoardingPage(),
          ),
        );
      case Pages.payment_categories:
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<PaymentCategoriesCubit>(),
            child: PaymentCategoriesPage(),
          ),
        );
      case Pages.payments:
        Map<dynamic, dynamic> args = settings.arguments as Map;
        return _buildRoute(
          settings,
          BlocProvider(
            create: (context) => getIt<PaymentsCubit>(),
            child: PaymentsPage(
              setting: args["setting"],
              initialIndex: args["initialIndex"],
            ),
          ),
        );
      default:
        return _buildRoute(settings, Text("Loading data...."));
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
