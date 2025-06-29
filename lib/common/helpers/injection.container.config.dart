// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:good_manager/common/shared_pref_storage.dart' as _i239;
import 'package:good_manager/common/storage2.dart' as _i860;
import 'package:good_manager/data/app_settings_impl.dart' as _i366;
import 'package:good_manager/data/repositories/customers_repository_impl.dart'
    as _i52;
import 'package:good_manager/data/repositories/document_transactions_repository_impl.dart'
    as _i987;
import 'package:good_manager/data/repositories/documents_repository_impl.dart'
    as _i166;
import 'package:good_manager/data/repositories/goods_repository_impl.dart'
    as _i521;
import 'package:good_manager/data/repositories/groups_repository_impl.dart'
    as _i795;
import 'package:good_manager/data/repositories/payment_category_repository_impl.dart'
    as _i1011;
import 'package:good_manager/data/repositories/payment_repository_impl.dart'
    as _i545;
import 'package:good_manager/data/repositories/stores_repository_impl.dart'
    as _i903;
import 'package:good_manager/data/repositories/suppliers_repository_impl.dart'
    as _i753;
import 'package:good_manager/data/repositories/wallet_repository_impl.dart'
    as _i669;
import 'package:good_manager/data/storage.dart' as _i72;
import 'package:good_manager/domain/app_settings.dart' as _i39;
import 'package:good_manager/domain/repositories/customer_repositories.dart'
    as _i54;
import 'package:good_manager/domain/repositories/document_repositories.dart'
    as _i811;
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart'
    as _i769;
import 'package:good_manager/domain/repositories/goods_repositories.dart'
    as _i585;
import 'package:good_manager/domain/repositories/groups_repositories.dart'
    as _i990;
import 'package:good_manager/domain/repositories/payment_category_repositories.dart'
    as _i995;
import 'package:good_manager/domain/repositories/payment_repositories.dart'
    as _i309;
import 'package:good_manager/domain/repositories/stores_repositories.dart'
    as _i339;
import 'package:good_manager/domain/repositories/suppliers_repositories.dart'
    as _i435;
import 'package:good_manager/domain/repositories/wallet_repositories.dart'
    as _i318;
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart'
    as _i236;
import 'package:good_manager/domain/usecases/customers/customers_usecases_impl.dart'
    as _i676;
import 'package:good_manager/domain/usecases/documents/document_usecases.dart'
    as _i231;
import 'package:good_manager/domain/usecases/documents/document_usecases_impl.dart'
    as _i1025;
import 'package:good_manager/domain/usecases/goods/goods_history_usecases.dart'
    as _i137;
import 'package:good_manager/domain/usecases/goods/goods_history_usecases_impl.dart'
    as _i454;
import 'package:good_manager/domain/usecases/goods/goods_usecases_impl.dart'
    as _i40;
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart'
    as _i31;
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart'
    as _i984;
import 'package:good_manager/domain/usecases/groups/groups_usecases_impl.dart'
    as _i260;
import 'package:good_manager/domain/usecases/payment/payment_usecases_impl.dart'
    as _i779;
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart'
    as _i886;
import 'package:good_manager/domain/usecases/payment_category/payment_category_usecases_impl.dart'
    as _i153;
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart'
    as _i79;
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart'
    as _i579;
import 'package:good_manager/domain/usecases/stores/stores_usecases_impl.dart'
    as _i411;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart'
    as _i331;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases_impl.dart'
    as _i949;
import 'package:good_manager/domain/usecases/wallets/wallet_usecases.dart'
    as _i322;
import 'package:good_manager/domain/usecases/wallets/wallet_usecases_impl.dart'
    as _i1072;
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart'
    as _i884;
import 'package:good_manager/presentation/pages/customers/bloc/customers_cubit.dart'
    as _i190;
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart'
    as _i881;
import 'package:good_manager/presentation/pages/documents_history/bloc/documents_history_cubit.dart'
    as _i420;
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart'
    as _i436;
import 'package:good_manager/presentation/pages/history/bloc/item_history_cubit.dart'
    as _i425;
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart'
    as _i0;
import 'package:good_manager/presentation/pages/login/auth_cubit.dart' as _i403;
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart'
    as _i234;
import 'package:good_manager/presentation/pages/payment/bloc/payments_cubit.dart'
    as _i152;
import 'package:good_manager/presentation/pages/payment_categories/bloc/payment_categories_cubit.dart'
    as _i850;
import 'package:good_manager/presentation/pages/payment_history/bloc/payment_history_cubit.dart'
    as _i705;
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart'
    as _i638;
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart'
    as _i984;
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart'
    as _i153;
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart'
    as _i467;
import 'package:good_manager/presentation/pages/save_good/bloc/quick_insert_document_cubit.dart'
    as _i595;
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart'
    as _i928;
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart'
    as _i764;
import 'package:good_manager/presentation/pages/save_payment/bloc/save_payment_cubit.dart'
    as _i458;
import 'package:good_manager/presentation/pages/save_payment_category/bloc/save_payment_category_cubit.dart'
    as _i521;
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart'
    as _i733;
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart'
    as _i340;
import 'package:good_manager/presentation/pages/save_wallet/bloc/save_wallet_cubit.dart'
    as _i1001;
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart'
    as _i664;
import 'package:good_manager/presentation/pages/settings/bloc/settings_cubit.dart'
    as _i749;
import 'package:good_manager/presentation/pages/settings/general/bloc/settings_general_cubit.dart'
    as _i961;
import 'package:good_manager/presentation/pages/settings/minimum_quantity/bloc/minimum_quantity_cubit.dart'
    as _i194;
import 'package:good_manager/presentation/pages/settings/my_company/bloc/my_company_cubit.dart'
    as _i920;
import 'package:good_manager/presentation/pages/settings/view/bloc/settings_view_cubit.dart'
    as _i684;
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart'
    as _i989;
import 'package:good_manager/presentation/pages/suppliers/bloc/suppliers_cubit.dart'
    as _i831;
import 'package:good_manager/presentation/widgets/add_quantity_and_price/add_quantity_and_price_cubit.dart'
    as _i205;
import 'package:good_manager/presentation/widgets/sale_report/sale_report_cubit.dart'
    as _i218;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i595.QuickInsertDocumentCubit>(
        () => _i595.QuickInsertDocumentCubit());
    gh.factory<_i205.AddQuantityAndPriceCubit>(
        () => _i205.AddQuantityAndPriceCubit());
    gh.singleton<_i72.Storage>(() => _i72.Storage());
    gh.factory<_i995.PaymentCategoryRepository>(
        () => _i1011.PaymentCategoryRepositoryImpl());
    gh.factory<_i585.GoodsRepository>(
        () => _i521.GoodsRepositoryImpl(gh<_i72.Storage>()));
    gh.factory<_i339.StoresRepository>(() => _i903.StoresRepositoryImpl());
    gh.factory<_i309.PaymentRepository>(
        () => _i545.PaymentRepositoryImpl(gh<_i72.Storage>()));
    gh.factory<_i54.CustomersRepository>(() => _i52.CustomersRepositoryImpl());
    gh.factory<_i435.SuppliersRepository>(
        () => _i753.SuppliersRepositoryImpl());
    gh.factory<_i811.DocumentRepository>(
        () => _i166.DocumentRepositoryImpl(gh<_i72.Storage>()));
    gh.factory<_i79.PaymentCategoryUseCases>(() =>
        _i153.PaymentCategoryUseCasesImp(
            repository: gh<_i995.PaymentCategoryRepository>()));
    gh.factory<_i990.GroupsRepository>(
        () => _i795.GroupsRepositoryImpl(gh<_i72.Storage>()));
    gh.factory<_i318.WalletRepository>(() => _i669.WalletRepositoryImpl());
    gh.lazySingleton<_i860.Storage2>(
        () => _i239.SharedPrefStorage(gh<_i460.SharedPreferences>()));
    gh.factory<_i961.SettingsGeneralCubit>(
        () => _i961.SettingsGeneralCubit(storage: gh<_i72.Storage>()));
    gh.factory<_i749.SettingsCubit>(
        () => _i749.SettingsCubit(storage: gh<_i72.Storage>()));
    gh.factory<_i884.BarcodeScannerCubit>(
        () => _i884.BarcodeScannerCubit(storage: gh<_i72.Storage>()));
    gh.factory<_i638.ReportCubit>(
        () => _i638.ReportCubit(storage: gh<_i72.Storage>()));
    gh.factory<_i769.DocumentTransactionRepository>(
        () => _i987.DocumentTransactionRepositoryImpl());
    gh.factory<_i137.GoodHistoryUseCases>(() => _i454.GoodHistoryUseCasesIpm(
          storage: gh<_i72.Storage>(),
          documentRepository: gh<_i811.DocumentRepository>(),
          documentTransactionRepository:
              gh<_i769.DocumentTransactionRepository>(),
        ));
    gh.factory<_i236.CustomersUseCase>(() =>
        _i676.CustomersUseCaseImpl(repository: gh<_i54.CustomersRepository>()));
    gh.factory<_i231.DocumentUseCases>(() => _i1025.DocumentUseCasesImpl(
          storage: gh<_i72.Storage>(),
          repository: gh<_i811.DocumentRepository>(),
          transactionRepository: gh<_i769.DocumentTransactionRepository>(),
        ));
    gh.factory<_i153.SaveCustomerCubit>(
        () => _i153.SaveCustomerCubit(useCase: gh<_i236.CustomersUseCase>()));
    gh.factory<_i521.SavePaymentCategoryCubit>(() =>
        _i521.SavePaymentCategoryCubit(
            useCase: gh<_i79.PaymentCategoryUseCases>()));
    gh.factory<_i331.SuppliersUseCase>(() => _i949.SuppliersUseCaseImpl(
        repository: gh<_i435.SuppliersRepository>()));
    gh.factory<_i322.WalletUseCases>(() =>
        _i1072.WalletUseCasesImpl(repository: gh<_i318.WalletRepository>()));
    gh.factory<_i850.PaymentCategoriesCubit>(() => _i850.PaymentCategoriesCubit(
        paymentCategoryUseCases: gh<_i79.PaymentCategoryUseCases>()));
    gh.factory<_i340.SaveSupplierCubit>(
        () => _i340.SaveSupplierCubit(useCase: gh<_i331.SuppliersUseCase>()));
    gh.factory<_i579.StoresUseCase>(() => _i411.StoresUseCaseImpl(
          repository: gh<_i339.StoresRepository>(),
          storage: gh<_i72.Storage>(),
        ));
    gh.factory<_i886.PaymentUseCases>(() =>
        _i779.PaymentUseCasesImpl(repository: gh<_i309.PaymentRepository>()));
    gh.factory<_i733.SaveStoreCubit>(() => _i733.SaveStoreCubit(
          useCase: gh<_i579.StoresUseCase>(),
          storage: gh<_i72.Storage>(),
        ));
    gh.factory<_i403.AuthCubit>(() => _i403.AuthCubit(
          useCase: gh<_i579.StoresUseCase>(),
          storage: gh<_i72.Storage>(),
        ));
    gh.factory<_i234.OnBoardingCubit>(() => _i234.OnBoardingCubit(
          useCase: gh<_i579.StoresUseCase>(),
          storage: gh<_i72.Storage>(),
        ));
    gh.factory<_i984.GroupsUseCases>(() =>
        _i260.GroupsUseCaseImpl(repository: gh<_i990.GroupsRepository>()));
    gh.factory<_i1001.SaveWalletCubit>(() => _i1001.SaveWalletCubit(
          useCase: gh<_i322.WalletUseCases>(),
          paymentUseCases: gh<_i886.PaymentUseCases>(),
          storage: gh<_i72.Storage>(),
        ));
    gh.factory<_i218.SaleReportCubit>(
        () => _i218.SaleReportCubit(useCase: gh<_i886.PaymentUseCases>()));
    gh.factory<_i31.GoodsUseCases>(() => _i40.GoodsUseCaseImpl(
          repository: gh<_i585.GoodsRepository>(),
          documentTransactionRepository:
              gh<_i769.DocumentTransactionRepository>(),
        ));
    gh.factory<_i39.AppSettings>(
        () => _i366.AppSettingsImpl(gh<_i860.Storage2>()));
    gh.factory<_i664.SelectGroupCubit>(() => _i664.SelectGroupCubit(
          groupsUseCase: gh<_i984.GroupsUseCases>(),
          storage: gh<_i72.Storage>(),
        ));
    gh.factory<_i764.SaveGroupCubit>(
        () => _i764.SaveGroupCubit(useCase: gh<_i984.GroupsUseCases>()));
    gh.factory<_i0.HomeCubit>(() => _i0.HomeCubit(
          storage: gh<_i72.Storage>(),
          goodsUseCases: gh<_i31.GoodsUseCases>(),
          documentsUseCases: gh<_i231.DocumentUseCases>(),
          supplierUseCases: gh<_i331.SuppliersUseCase>(),
          customerUseCase: gh<_i236.CustomersUseCase>(),
          walletUseCases: gh<_i322.WalletUseCases>(),
          paymentUseCases: gh<_i886.PaymentUseCases>(),
          appSettings: gh<_i39.AppSettings>(),
        ));
    gh.factory<_i705.PaymentHistoryCubit>(() => _i705.PaymentHistoryCubit(
          appSettings: gh<_i39.AppSettings>(),
          useCases: gh<_i886.PaymentUseCases>(),
        ));
    gh.factory<_i928.SaveGoodCubit>(() => _i928.SaveGoodCubit(
          useCase: gh<_i31.GoodsUseCases>(),
          documentsUseCases: gh<_i231.DocumentUseCases>(),
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
        ));
    gh.factory<_i436.GoodsCubit>(() => _i436.GoodsCubit(
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
          goodsUseCase: gh<_i31.GoodsUseCases>(),
          groupsUseCase: gh<_i984.GroupsUseCases>(),
          documentsUseCases: gh<_i231.DocumentUseCases>(),
        ));
    gh.factory<_i684.SettingsViewCubit>(
        () => _i684.SettingsViewCubit(appSettings: gh<_i39.AppSettings>()));
    gh.factory<_i920.MyCompanyCubit>(
        () => _i920.MyCompanyCubit(appSettings: gh<_i39.AppSettings>()));
    gh.factory<_i194.MinimumQuantityCubit>(
        () => _i194.MinimumQuantityCubit(appSettings: gh<_i39.AppSettings>()));
    gh.factory<_i190.CustomersCubit>(() => _i190.CustomersCubit(
          appSettings: gh<_i39.AppSettings>(),
          storage: gh<_i72.Storage>(),
          useCase: gh<_i236.CustomersUseCase>(),
        ));
    gh.factory<_i984.ReportDetailCubit>(() => _i984.ReportDetailCubit(
          storage: gh<_i72.Storage>(),
          goodsUseCase: gh<_i31.GoodsUseCases>(),
          groupsUseCases: gh<_i984.GroupsUseCases>(),
          paymentUseCases: gh<_i886.PaymentUseCases>(),
          documentUseCases: gh<_i231.DocumentUseCases>(),
          documentTransactionRepository:
              gh<_i769.DocumentTransactionRepository>(),
          suppliersUseCase: gh<_i331.SuppliersUseCase>(),
          customersUseCase: gh<_i236.CustomersUseCase>(),
          walletUseCases: gh<_i322.WalletUseCases>(),
        ));
    gh.factory<_i881.DocumentsCubit>(() => _i881.DocumentsCubit(
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
          useCase: gh<_i231.DocumentUseCases>(),
          customersUseCase: gh<_i236.CustomersUseCase>(),
          suppliersUseCase: gh<_i331.SuppliersUseCase>(),
        ));
    gh.factory<_i467.SaveDocumentCubit>(() => _i467.SaveDocumentCubit(
          useCase: gh<_i231.DocumentUseCases>(),
          paymentUseCase: gh<_i886.PaymentUseCases>(),
          goodUseCases: gh<_i31.GoodsUseCases>(),
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
        ));
    gh.factory<_i458.SavePaymentCubit>(() => _i458.SavePaymentCubit(
          useCase: gh<_i886.PaymentUseCases>(),
          paymentCategoryUseCases: gh<_i79.PaymentCategoryUseCases>(),
          walletUseCases: gh<_i322.WalletUseCases>(),
          customersUseCase: gh<_i236.CustomersUseCase>(),
          suppliersUseCase: gh<_i331.SuppliersUseCase>(),
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
        ));
    gh.factory<_i425.ItemHistoryCubit>(() => _i425.ItemHistoryCubit(
          appSettings: gh<_i39.AppSettings>(),
          useCases: gh<_i137.GoodHistoryUseCases>(),
          documentUseCases: gh<_i231.DocumentUseCases>(),
          documentTransactionRepository:
              gh<_i769.DocumentTransactionRepository>(),
        ));
    gh.factory<_i152.PaymentsCubit>(() => _i152.PaymentsCubit(
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
          useCase: gh<_i886.PaymentUseCases>(),
          documentUseCases: gh<_i231.DocumentUseCases>(),
          paymentCategoryUseCases: gh<_i79.PaymentCategoryUseCases>(),
        ));
    gh.factory<_i831.SuppliersCubit>(() => _i831.SuppliersCubit(
          appSettings: gh<_i39.AppSettings>(),
          storage: gh<_i72.Storage>(),
          useCase: gh<_i331.SuppliersUseCase>(),
        ));
    gh.factory<_i420.DocumentsHistoryCubit>(() => _i420.DocumentsHistoryCubit(
          documentUseCases: gh<_i231.DocumentUseCases>(),
          paymentUseCases: gh<_i886.PaymentUseCases>(),
          appSettings: gh<_i39.AppSettings>(),
        ));
    gh.factory<_i989.StoresCubit>(() => _i989.StoresCubit(
          storage: gh<_i72.Storage>(),
          appSettings: gh<_i39.AppSettings>(),
          useCase: gh<_i579.StoresUseCase>(),
        ));
    return this;
  }
}
