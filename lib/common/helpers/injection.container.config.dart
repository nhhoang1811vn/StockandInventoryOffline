// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:good_manager/data/repositories/customers_repository_impl.dart'
    as _i5;
import 'package:good_manager/data/repositories/document_transactions_repository_impl.dart'
    as _i11;
import 'package:good_manager/data/repositories/documents_repository_impl.dart'
    as _i9;
import 'package:good_manager/data/repositories/expense_repository_impl.dart'
    as _i13;
import 'package:good_manager/data/repositories/goods_repository_impl.dart'
    as _i17;
import 'package:good_manager/data/repositories/groups_repository_impl.dart'
    as _i21;
import 'package:good_manager/data/repositories/payment_repository_impl.dart'
    as _i25;
import 'package:good_manager/data/repositories/stores_repository_impl.dart'
    as _i35;
import 'package:good_manager/data/repositories/suppliers_repository_impl.dart'
    as _i39;
import 'package:good_manager/data/storage.dart' as _i33;
import 'package:good_manager/domain/repositories/customer_repositories.dart'
    as _i4;
import 'package:good_manager/domain/repositories/document_repositories.dart'
    as _i8;
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart'
    as _i10;
import 'package:good_manager/domain/repositories/expense_repositories.dart'
    as _i12;
import 'package:good_manager/domain/repositories/goods_repositories.dart'
    as _i16;
import 'package:good_manager/domain/repositories/groups_repositories.dart'
    as _i20;
import 'package:good_manager/domain/repositories/payment_repositories.dart'
    as _i24;
import 'package:good_manager/domain/repositories/stores_repositories.dart'
    as _i34;
import 'package:good_manager/domain/repositories/suppliers_repositories.dart'
    as _i38;
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart'
    as _i6;
import 'package:good_manager/domain/usecases/customers/customers_usecases_impl.dart'
    as _i7;
import 'package:good_manager/domain/usecases/documents/document_usecases.dart'
    as _i44;
import 'package:good_manager/domain/usecases/documents/document_usecases_impl.dart'
    as _i45;
import 'package:good_manager/domain/usecases/expenses/expense_usecases_impl.dart'
    as _i15;
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart'
    as _i14;
import 'package:good_manager/domain/usecases/goods/goods_usecases_impl.dart'
    as _i19;
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart'
    as _i18;
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart'
    as _i22;
import 'package:good_manager/domain/usecases/groups/groups_usecases_impl.dart'
    as _i23;
import 'package:good_manager/domain/usecases/payment/payment_usecases_impl.dart'
    as _i27;
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart'
    as _i26;
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart'
    as _i36;
import 'package:good_manager/domain/usecases/stores/stores_usecases_impl.dart'
    as _i37;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart'
    as _i40;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases_impl.dart'
    as _i41;
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart'
    as _i42;
import 'package:good_manager/presentation/pages/customers/bloc/customers_cubit.dart'
    as _i43;
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart'
    as _i46;
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart'
    as _i47;
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart'
    as _i48;
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart'
    as _i49;
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart'
    as _i50;
import 'package:good_manager/presentation/pages/payment/bloc/payments_cubit.dart'
    as _i51;
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart'
    as _i52;
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart'
    as _i53;
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart'
    as _i28;
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart'
    as _i54;
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart'
    as _i29;
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart'
    as _i55;
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart'
    as _i30;
import 'package:good_manager/presentation/pages/save_payment/bloc/save_payment_cubit.dart'
    as _i31;
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart'
    as _i56;
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart'
    as _i57;
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart'
    as _i32;
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart'
    as _i58;
import 'package:good_manager/presentation/pages/suppliers/bloc/suppliers_cubit.dart'
    as _i59;
import 'package:good_manager/presentation/widgets/add_quantity_and_price/add_quantity_and_price_cubit.dart'
    as _i3;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.AddQuantityAndPriceCubit>(
        () => _i3.AddQuantityAndPriceCubit());
    gh.factory<_i4.CustomersRepository>(() => _i5.CustomersRepositoryImpl());
    gh.factory<_i6.CustomersUseCase>(() =>
        _i7.CustomersUseCaseImpl(repository: gh<_i4.CustomersRepository>()));
    gh.factory<_i8.DocumentRepository>(() => _i9.DocumentRepositoryImpl());
    gh.factory<_i10.DocumentTransactionRepository>(
        () => _i11.DocumentTransactionRepositoryImpl());
    gh.factory<_i12.ExpenseRepository>(() => _i13.ExpenseRepositoryImpl());
    gh.factory<_i14.ExpenseUseCases>(() =>
        _i15.ExpenseUseCasesImpl(repository: gh<_i12.ExpenseRepository>()));
    gh.factory<_i16.GoodsRepository>(() => _i17.GoodsRepositoryImpl());
    gh.factory<_i18.GoodsUseCases>(() => _i19.GoodsUseCaseImpl(
          repository: gh<_i16.GoodsRepository>(),
          documentTransactionRepository:
              gh<_i10.DocumentTransactionRepository>(),
        ));
    gh.factory<_i20.GroupsRepository>(() => _i21.GroupsRepositoryImpl());
    gh.factory<_i22.GroupsUseCases>(
        () => _i23.GroupsUseCaseImpl(repository: gh<_i20.GroupsRepository>()));
    gh.factory<_i24.PaymentRepository>(() => _i25.PaymentRepositoryImpl());
    gh.factory<_i26.PaymentUseCases>(() =>
        _i27.PaymentUseCasesImpl(repository: gh<_i24.PaymentRepository>()));
    gh.factory<_i28.SaveCustomerCubit>(
        () => _i28.SaveCustomerCubit(useCase: gh<_i6.CustomersUseCase>()));
    gh.factory<_i29.SaveExpenseCubit>(
        () => _i29.SaveExpenseCubit(useCase: gh<_i14.ExpenseUseCases>()));
    gh.factory<_i30.SaveGroupCubit>(
        () => _i30.SaveGroupCubit(useCase: gh<_i22.GroupsUseCases>()));
    gh.factory<_i31.SavePaymentCubit>(
        () => _i31.SavePaymentCubit(useCase: gh<_i26.PaymentUseCases>()));
    gh.factory<_i32.SelectGroupCubit>(
        () => _i32.SelectGroupCubit(groupsUseCase: gh<_i22.GroupsUseCases>()));
    gh.singleton<_i33.Storage>(_i33.Storage());
    gh.factory<_i34.StoresRepository>(() => _i35.StoresRepositoryImpl());
    gh.factory<_i36.StoresUseCase>(() => _i37.StoresUseCaseImpl(
          repository: gh<_i34.StoresRepository>(),
          storage: gh<_i33.Storage>(),
        ));
    gh.factory<_i38.SuppliersRepository>(() => _i39.SuppliersRepositoryImpl());
    gh.factory<_i40.SuppliersUseCase>(() =>
        _i41.SuppliersUseCaseImpl(repository: gh<_i38.SuppliersRepository>()));
    gh.factory<_i42.BarcodeScannerCubit>(
        () => _i42.BarcodeScannerCubit(storage: gh<_i33.Storage>()));
    gh.factory<_i43.CustomersCubit>(() => _i43.CustomersCubit(
          storage: gh<_i33.Storage>(),
          useCase: gh<_i6.CustomersUseCase>(),
        ));
    gh.factory<_i44.DocumentUseCases>(() => _i45.DocumentUseCasesImpl(
          storage: gh<_i33.Storage>(),
          repository: gh<_i8.DocumentRepository>(),
          transactionRepository: gh<_i10.DocumentTransactionRepository>(),
        ));
    gh.factory<_i46.DocumentsCubit>(() => _i46.DocumentsCubit(
          storage: gh<_i33.Storage>(),
          useCase: gh<_i44.DocumentUseCases>(),
        ));
    gh.factory<_i47.ExpensesCubit>(() => _i47.ExpensesCubit(
          storage: gh<_i33.Storage>(),
          useCase: gh<_i14.ExpenseUseCases>(),
        ));
    gh.factory<_i48.GoodsCubit>(() => _i48.GoodsCubit(
          storage: gh<_i33.Storage>(),
          goodsUseCase: gh<_i18.GoodsUseCases>(),
          groupsUseCase: gh<_i22.GroupsUseCases>(),
          documentsUseCases: gh<_i44.DocumentUseCases>(),
        ));
    gh.factory<_i49.HomeCubit>(() => _i49.HomeCubit(
          storage: gh<_i33.Storage>(),
          goodsUseCases: gh<_i18.GoodsUseCases>(),
          documentsUseCases: gh<_i44.DocumentUseCases>(),
          supplierUseCases: gh<_i40.SuppliersUseCase>(),
          customerUseCase: gh<_i6.CustomersUseCase>(),
          expenseUseCases: gh<_i14.ExpenseUseCases>(),
        ));
    gh.factory<_i50.OnBoardingCubit>(() => _i50.OnBoardingCubit(
          useCase: gh<_i36.StoresUseCase>(),
          storage: gh<_i33.Storage>(),
        ));
    gh.factory<_i51.PaymentsCubit>(() => _i51.PaymentsCubit(
          storage: gh<_i33.Storage>(),
          useCase: gh<_i26.PaymentUseCases>(),
          documentUseCases: gh<_i44.DocumentUseCases>(),
        ));
    gh.factory<_i52.ReportCubit>(() => _i52.ReportCubit(
          storage: gh<_i33.Storage>(),
          expenseUseCase: gh<_i14.ExpenseUseCases>(),
        ));
    gh.factory<_i53.ReportDetailCubit>(() => _i53.ReportDetailCubit(
          storage: gh<_i33.Storage>(),
          expenseUseCase: gh<_i14.ExpenseUseCases>(),
          documentUseCases: gh<_i44.DocumentUseCases>(),
        ));
    gh.factory<_i54.SaveDocumentCubit>(() => _i54.SaveDocumentCubit(
          useCase: gh<_i44.DocumentUseCases>(),
          paymentUseCase: gh<_i26.PaymentUseCases>(),
          goodUseCases: gh<_i18.GoodsUseCases>(),
          storage: gh<_i33.Storage>(),
        ));
    gh.factory<_i55.SaveGoodCubit>(() => _i55.SaveGoodCubit(
          useCase: gh<_i18.GoodsUseCases>(),
          documentsUseCases: gh<_i44.DocumentUseCases>(),
          storage: gh<_i33.Storage>(),
        ));
    gh.factory<_i56.SaveStoreCubit>(() => _i56.SaveStoreCubit(
          useCase: gh<_i36.StoresUseCase>(),
          storage: gh<_i33.Storage>(),
        ));
    gh.factory<_i57.SaveSupplierCubit>(
        () => _i57.SaveSupplierCubit(useCase: gh<_i40.SuppliersUseCase>()));
    gh.factory<_i58.StoresCubit>(() => _i58.StoresCubit(
          storage: gh<_i33.Storage>(),
          useCase: gh<_i36.StoresUseCase>(),
        ));
    gh.factory<_i59.SuppliersCubit>(() => _i59.SuppliersCubit(
          storage: gh<_i33.Storage>(),
          useCase: gh<_i40.SuppliersUseCase>(),
        ));
    return this;
  }
}
