// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/services/low_stock_service.dart' as _i697;
import '../data/data.dart' as _i433;
import '../data/db/db_helper.dart' as _i542;
import '../domain/usecase/customers/customers_usecases.dart' as _i75;
import '../domain/usecase/documents/document_usecases.dart' as _i345;
import '../domain/usecase/goods/goods_history_usecases.dart' as _i599;
import '../domain/usecase/goods/goods_usercases.dart' as _i162;
import '../domain/usecase/groups/groups_usecases.dart' as _i506;
import '../domain/usecase/payment/payment_usercases.dart' as _i785;
import '../domain/usecase/payment_category/payment_category_usecases.dart'
    as _i517;
import '../domain/usecase/stores/stores_usecases.dart' as _i261;
import '../domain/usecase/suppliers/suppliers_usecases.dart' as _i273;
import '../domain/usecase/usecase.dart' as _i704;
import '../domain/usecase/wallets/wallet_usecases.dart' as _i604;
import '../presentation/blocs/add_quantity_and_price/add_quantity_and_price_cubit.dart'
    as _i901;
import '../presentation/pages/barcode_scanner_settings/bloc/barcode_scanner_settings_cubit.dart'
    as _i589;
import '../presentation/pages/customers/bloc/customers_cubit.dart' as _i978;
import '../presentation/pages/documents/bloc/documents_cubit.dart' as _i197;
import '../presentation/pages/documents_history/bloc/documents_history_cubit.dart'
    as _i71;
import '../presentation/pages/goods/bloc/goods_cubit.dart' as _i346;
import '../presentation/pages/history/bloc/item_history_cubit.dart' as _i653;
import '../presentation/pages/home/bloc/home_cubit.dart' as _i12;
import '../presentation/pages/login/auth_cubit.dart' as _i995;
import '../presentation/pages/onboarding/bloc/on_boarding_cubit.dart' as _i573;
import '../presentation/pages/payment/bloc/payments_cubit.dart' as _i179;
import '../presentation/pages/payment_categories/bloc/payment_categories_cubit.dart'
    as _i489;
import '../presentation/pages/payment_history/bloc/payment_history_cubit.dart'
    as _i1027;
import '../presentation/pages/report/bloc/report_cubit.dart' as _i974;
import '../presentation/pages/report_detail/bloc/report_detail_cubit.dart'
    as _i588;
import '../presentation/pages/save_customer/bloc/save_customer_cubit.dart'
    as _i124;
import '../presentation/pages/save_document/bloc/save_document_cubit.dart'
    as _i673;
import '../presentation/pages/save_good/bloc/quick_insert_document_cubit.dart'
    as _i434;
import '../presentation/pages/save_good/bloc/save_good_cubit.dart' as _i94;
import '../presentation/pages/save_group/bloc/save_group_cubit.dart' as _i738;
import '../presentation/pages/save_payment/bloc/save_payment_cubit.dart'
    as _i105;
import '../presentation/pages/save_payment_category/bloc/save_payment_category_cubit.dart'
    as _i844;
import '../presentation/pages/save_store/bloc/save_store_cubit.dart' as _i923;
import '../presentation/pages/save_supplier/bloc/save_supplier_cubit.dart'
    as _i377;
import '../presentation/pages/save_wallet/bloc/save_wallet_cubit.dart' as _i193;
import '../presentation/pages/select_group/bloc/select_group_cubit.dart'
    as _i921;
import '../presentation/pages/settings/bloc/settings_cubit.dart' as _i951;
import '../presentation/pages/settings/general/bloc/settings_general_cubit.dart'
    as _i439;
import '../presentation/pages/settings/minimum_quantity/bloc/minimum_quantity_cubit.dart'
    as _i178;
import '../presentation/pages/settings/my_company/bloc/my_company_cubit.dart'
    as _i25;
import '../presentation/pages/settings/view/bloc/settings_view_cubit.dart'
    as _i279;
import '../presentation/pages/stores/bloc/stores_cubit.dart' as _i895;
import '../presentation/pages/suppliers/bloc/suppliers_cubit.dart' as _i346;
import '../presentation/widget/sale_report/sale_report_cubit.dart' as _i434;
import '../repo/customers_repository.dart' as _i542;
import '../repo/document_transactions_repository.dart' as _i394;
import '../repo/documents_repository.dart' as _i317;
import '../repo/goods_repository.dart' as _i596;
import '../repo/groups_repository.dart' as _i875;
import '../repo/payment_category_repository.dart' as _i660;
import '../repo/payment_repository.dart' as _i457;
import '../repo/repo.dart' as _i1038;
import '../repo/stores_repository.dart' as _i97;
import '../repo/suppliers_repository.dart' as _i772;
import '../repo/wallet_repository.dart' as _i699;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i589.BarcodeScannerSettingsCubit>(
        () => _i589.BarcodeScannerSettingsCubit());
    gh.factory<_i974.ReportCubit>(() => _i974.ReportCubit());
    gh.factory<_i434.QuickInsertDocumentCubit>(
        () => _i434.QuickInsertDocumentCubit());
    gh.factory<_i951.SettingsCubit>(() => _i951.SettingsCubit());
    gh.factory<_i439.SettingsGeneralCubit>(() => _i439.SettingsGeneralCubit());
    gh.factory<_i178.MinimumQuantityCubit>(() => _i178.MinimumQuantityCubit());
    gh.factory<_i25.MyCompanyCubit>(() => _i25.MyCompanyCubit());
    gh.factory<_i279.SettingsViewCubit>(() => _i279.SettingsViewCubit());
    gh.factory<_i901.AddQuantityAndPriceCubit>(
        () => _i901.AddQuantityAndPriceCubit());
    gh.lazySingleton<_i542.DBHelper>(() => _i542.DBHelper());
    gh.lazySingleton<_i542.CustomersRepository>(
        () => _i542.CustomersRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i317.DocumentRepository>(
        () => _i317.DocumentRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i394.DocumentTransactionRepository>(
        () => _i394.DocumentTransactionRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i596.GoodsRepository>(
        () => _i596.GoodsRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i875.GroupsRepository>(
        () => _i875.GroupsRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i660.PaymentCategoryRepository>(
        () => _i660.PaymentCategoryRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i457.PaymentRepository>(
        () => _i457.PaymentRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i97.StoresRepository>(
        () => _i97.StoresRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i772.SuppliersRepository>(
        () => _i772.SuppliersRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i699.WalletRepository>(
        () => _i699.WalletRepository(db: gh<_i433.DBHelper>()));
    gh.lazySingleton<_i162.GoodsUseCases>(() => _i162.GoodsUseCases(
          repository: gh<_i1038.GoodsRepository>(),
          documentTransactionRepository:
              gh<_i1038.DocumentTransactionRepository>(),
        ));
    gh.lazySingleton<_i345.DocumentUseCases>(() => _i345.DocumentUseCases(
          repository: gh<_i1038.DocumentRepository>(),
          transactionRepository: gh<_i1038.DocumentTransactionRepository>(),
        ));
    gh.lazySingleton<_i599.GoodHistoryUseCases>(() => _i599.GoodHistoryUseCases(
          documentRepository: gh<_i1038.DocumentRepository>(),
          documentTransactionRepository:
              gh<_i1038.DocumentTransactionRepository>(),
        ));
    gh.lazySingleton<_i261.StoresUseCase>(
        () => _i261.StoresUseCase(repository: gh<_i1038.StoresRepository>()));
    gh.lazySingleton<_i697.LowStockService>(
        () => _i697.LowStockService(gh<_i1038.GoodsRepository>()));
    gh.lazySingleton<_i273.SuppliersUseCase>(() =>
        _i273.SuppliersUseCase(repository: gh<_i1038.SuppliersRepository>()));
    gh.lazySingleton<_i785.PaymentUseCases>(() =>
        _i785.PaymentUseCases(repository: gh<_i1038.PaymentRepository>()));
    gh.lazySingleton<_i75.CustomersUseCase>(() =>
        _i75.CustomersUseCase(repository: gh<_i1038.CustomersRepository>()));
    gh.factory<_i653.ItemHistoryCubit>(() => _i653.ItemHistoryCubit(
          useCases: gh<_i704.GoodHistoryUseCases>(),
          documentUseCases: gh<_i704.DocumentUseCases>(),
          documentTransactionRepository:
              gh<_i1038.DocumentTransactionRepository>(),
        ));
    gh.factory<_i377.SaveSupplierCubit>(
        () => _i377.SaveSupplierCubit(useCase: gh<_i704.SuppliersUseCase>()));
    gh.factory<_i346.SuppliersCubit>(
        () => _i346.SuppliersCubit(useCase: gh<_i704.SuppliersUseCase>()));
    gh.factory<_i94.SaveGoodCubit>(() => _i94.SaveGoodCubit(
          useCase: gh<_i704.GoodsUseCases>(),
          documentsUseCases: gh<_i704.DocumentUseCases>(),
        ));
    gh.lazySingleton<_i506.GroupsUseCases>(
        () => _i506.GroupsUseCases(repository: gh<_i1038.GroupsRepository>()));
    gh.lazySingleton<_i517.PaymentCategoryUseCases>(() =>
        _i517.PaymentCategoryUseCases(
            repository: gh<_i1038.PaymentCategoryRepository>()));
    gh.lazySingleton<_i604.WalletUseCases>(
        () => _i604.WalletUseCases(repository: gh<_i1038.WalletRepository>()));
    gh.factory<_i844.SavePaymentCategoryCubit>(() =>
        _i844.SavePaymentCategoryCubit(
            useCase: gh<_i704.PaymentCategoryUseCases>()));
    gh.factory<_i921.SelectGroupCubit>(() =>
        _i921.SelectGroupCubit(groupsUseCase: gh<_i704.GroupsUseCases>()));
    gh.factory<_i12.HomeCubit>(() => _i12.HomeCubit(
          goodsUseCases: gh<_i704.GoodsUseCases>(),
          documentsUseCases: gh<_i704.DocumentUseCases>(),
          supplierUseCases: gh<_i704.SuppliersUseCase>(),
          customerUseCase: gh<_i704.CustomersUseCase>(),
          walletUseCases: gh<_i704.WalletUseCases>(),
          paymentUseCases: gh<_i704.PaymentUseCases>(),
        ));
    gh.factory<_i995.AuthCubit>(
        () => _i995.AuthCubit(useCase: gh<_i704.StoresUseCase>()));
    gh.factory<_i573.OnBoardingCubit>(
        () => _i573.OnBoardingCubit(useCase: gh<_i704.StoresUseCase>()));
    gh.factory<_i923.SaveStoreCubit>(
        () => _i923.SaveStoreCubit(useCase: gh<_i704.StoresUseCase>()));
    gh.factory<_i895.StoresCubit>(
        () => _i895.StoresCubit(useCase: gh<_i704.StoresUseCase>()));
    gh.factory<_i673.SaveDocumentCubit>(() => _i673.SaveDocumentCubit(
          useCase: gh<_i704.DocumentUseCases>(),
          paymentUseCase: gh<_i704.PaymentUseCases>(),
          goodUseCases: gh<_i704.GoodsUseCases>(),
        ));
    gh.factory<_i978.CustomersCubit>(
        () => _i978.CustomersCubit(useCase: gh<_i704.CustomersUseCase>()));
    gh.factory<_i124.SaveCustomerCubit>(
        () => _i124.SaveCustomerCubit(useCase: gh<_i704.CustomersUseCase>()));
    gh.factory<_i588.ReportDetailCubit>(() => _i588.ReportDetailCubit(
          goodsUseCase: gh<_i704.GoodsUseCases>(),
          groupsUseCases: gh<_i704.GroupsUseCases>(),
          paymentUseCases: gh<_i704.PaymentUseCases>(),
          documentUseCases: gh<_i704.DocumentUseCases>(),
          documentTransactionRepository:
              gh<_i1038.DocumentTransactionRepository>(),
          suppliersUseCase: gh<_i704.SuppliersUseCase>(),
          customersUseCase: gh<_i704.CustomersUseCase>(),
          walletUseCases: gh<_i704.WalletUseCases>(),
        ));
    gh.factory<_i179.PaymentsCubit>(() => _i179.PaymentsCubit(
          useCase: gh<_i704.PaymentUseCases>(),
          documentUseCases: gh<_i704.DocumentUseCases>(),
          paymentCategoryUseCases: gh<_i704.PaymentCategoryUseCases>(),
        ));
    gh.factory<_i197.DocumentsCubit>(() => _i197.DocumentsCubit(
          useCase: gh<_i704.DocumentUseCases>(),
          customersUseCase: gh<_i704.CustomersUseCase>(),
          suppliersUseCase: gh<_i704.SuppliersUseCase>(),
        ));
    gh.factory<_i1027.PaymentHistoryCubit>(() =>
        _i1027.PaymentHistoryCubit(useCases: gh<_i704.PaymentUseCases>()));
    gh.factory<_i346.GoodsCubit>(() => _i346.GoodsCubit(
          goodsUseCase: gh<_i704.GoodsUseCases>(),
          groupsUseCase: gh<_i704.GroupsUseCases>(),
          documentsUseCases: gh<_i704.DocumentUseCases>(),
        ));
    gh.factory<_i71.DocumentsHistoryCubit>(() => _i71.DocumentsHistoryCubit(
          documentUseCases: gh<_i704.DocumentUseCases>(),
          paymentUseCases: gh<_i704.PaymentUseCases>(),
        ));
    gh.factory<_i193.SaveWalletCubit>(() => _i193.SaveWalletCubit(
          useCase: gh<_i704.WalletUseCases>(),
          paymentUseCases: gh<_i704.PaymentUseCases>(),
        ));
    gh.factory<_i489.PaymentCategoriesCubit>(() => _i489.PaymentCategoriesCubit(
        paymentCategoryUseCases: gh<_i704.PaymentCategoryUseCases>()));
    gh.factory<_i105.SavePaymentCubit>(() => _i105.SavePaymentCubit(
          useCase: gh<_i704.PaymentUseCases>(),
          paymentCategoryUseCases: gh<_i704.PaymentCategoryUseCases>(),
          walletUseCases: gh<_i704.WalletUseCases>(),
          customersUseCase: gh<_i704.CustomersUseCase>(),
          suppliersUseCase: gh<_i704.SuppliersUseCase>(),
        ));
    gh.factory<_i434.SaleReportCubit>(
        () => _i434.SaleReportCubit(useCase: gh<_i704.PaymentUseCases>()));
    gh.factory<_i738.SaveGroupCubit>(
        () => _i738.SaveGroupCubit(useCase: gh<_i704.GroupsUseCases>()));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
