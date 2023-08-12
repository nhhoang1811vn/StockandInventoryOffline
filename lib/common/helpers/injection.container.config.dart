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
    as _i4;
import 'package:good_manager/data/repositories/document_transactions_repository_impl.dart'
    as _i10;
import 'package:good_manager/data/repositories/documents_repository_impl.dart'
    as _i8;
import 'package:good_manager/data/repositories/expense_repository_impl.dart'
    as _i12;
import 'package:good_manager/data/repositories/goods_repository_impl.dart'
    as _i16;
import 'package:good_manager/data/repositories/groups_repository_impl.dart'
    as _i20;
import 'package:good_manager/data/repositories/stores_repository_impl.dart'
    as _i29;
import 'package:good_manager/data/repositories/suppliers_repository_impl.dart'
    as _i33;
import 'package:good_manager/data/storage.dart' as _i27;
import 'package:good_manager/domain/repositories/customer_repositories.dart'
    as _i3;
import 'package:good_manager/domain/repositories/document_repositories.dart'
    as _i7;
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart'
    as _i9;
import 'package:good_manager/domain/repositories/expense_repositories.dart'
    as _i11;
import 'package:good_manager/domain/repositories/goods_repositories.dart'
    as _i15;
import 'package:good_manager/domain/repositories/groups_repositories.dart'
    as _i19;
import 'package:good_manager/domain/repositories/stores_repositories.dart'
    as _i28;
import 'package:good_manager/domain/repositories/suppliers_repositories.dart'
    as _i32;
import 'package:good_manager/domain/usecases/customers/customers_usecases.dart'
    as _i5;
import 'package:good_manager/domain/usecases/customers/customers_usecases_impl.dart'
    as _i6;
import 'package:good_manager/domain/usecases/documents/document_usecases.dart'
    as _i38;
import 'package:good_manager/domain/usecases/documents/document_usecases_impl.dart'
    as _i39;
import 'package:good_manager/domain/usecases/expenses/expense_usecases_impl.dart'
    as _i14;
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart'
    as _i13;
import 'package:good_manager/domain/usecases/goods/goods_usecases_impl.dart'
    as _i18;
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart'
    as _i17;
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart'
    as _i21;
import 'package:good_manager/domain/usecases/groups/groups_usecases_impl.dart'
    as _i22;
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart'
    as _i30;
import 'package:good_manager/domain/usecases/stores/stores_usecases_impl.dart'
    as _i31;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart'
    as _i34;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases_impl.dart'
    as _i35;
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart'
    as _i36;
import 'package:good_manager/presentation/pages/customers/bloc/customers_cubit.dart'
    as _i37;
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart'
    as _i40;
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart'
    as _i41;
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit.dart'
    as _i42;
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart'
    as _i43;
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart'
    as _i44;
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart'
    as _i45;
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart'
    as _i46;
import 'package:good_manager/presentation/pages/save_customer/bloc/save_customer_cubit.dart'
    as _i23;
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart'
    as _i47;
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart'
    as _i24;
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart'
    as _i48;
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart'
    as _i25;
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart'
    as _i49;
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart'
    as _i50;
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart'
    as _i26;
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart'
    as _i51;
import 'package:good_manager/presentation/pages/suppliers/bloc/suppliers_cubit.dart'
    as _i52;
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
    gh.factory<_i3.CustomersRepository>(() => _i4.CustomersRepositoryImpl());
    gh.factory<_i5.CustomersUseCase>(() =>
        _i6.CustomersUseCaseImpl(repository: gh<_i3.CustomersRepository>()));
    gh.factory<_i7.DocumentRepository>(() => _i8.DocumentRepositoryImpl());
    gh.factory<_i9.DocumentTransactionRepository>(
        () => _i10.DocumentTransactionRepositoryImpl());
    gh.factory<_i11.ExpenseRepository>(() => _i12.ExpenseRepositoryImpl());
    gh.factory<_i13.ExpenseUseCases>(() =>
        _i14.ExpenseUseCasesImpl(repository: gh<_i11.ExpenseRepository>()));
    gh.factory<_i15.GoodsRepository>(() => _i16.GoodsRepositoryImpl());
    gh.factory<_i17.GoodsUseCases>(() => _i18.GoodsUseCaseImpl(
          repository: gh<_i15.GoodsRepository>(),
          documentTransactionRepository:
              gh<_i9.DocumentTransactionRepository>(),
        ));
    gh.factory<_i19.GroupsRepository>(() => _i20.GroupsRepositoryImpl());
    gh.factory<_i21.GroupsUseCases>(
        () => _i22.GroupsUseCaseImpl(repository: gh<_i19.GroupsRepository>()));
    gh.factory<_i23.SaveCustomerCubit>(
        () => _i23.SaveCustomerCubit(useCase: gh<_i5.CustomersUseCase>()));
    gh.factory<_i24.SaveExpenseCubit>(
        () => _i24.SaveExpenseCubit(useCase: gh<_i13.ExpenseUseCases>()));
    gh.factory<_i25.SaveGroupCubit>(
        () => _i25.SaveGroupCubit(useCase: gh<_i21.GroupsUseCases>()));
    gh.factory<_i26.SelectGroupCubit>(
        () => _i26.SelectGroupCubit(groupsUseCase: gh<_i21.GroupsUseCases>()));
    gh.singleton<_i27.Storage>(_i27.Storage());
    gh.factory<_i28.StoresRepository>(() => _i29.StoresRepositoryImpl());
    gh.factory<_i30.StoresUseCase>(
        () => _i31.StoresUseCaseImpl(repository: gh<_i28.StoresRepository>()));
    gh.factory<_i32.SuppliersRepository>(() => _i33.SuppliersRepositoryImpl());
    gh.factory<_i34.SuppliersUseCase>(() =>
        _i35.SuppliersUseCaseImpl(repository: gh<_i32.SuppliersRepository>()));
    gh.factory<_i36.BarcodeScannerCubit>(
        () => _i36.BarcodeScannerCubit(storage: gh<_i27.Storage>()));
    gh.factory<_i37.CustomersCubit>(() => _i37.CustomersCubit(
          storage: gh<_i27.Storage>(),
          useCase: gh<_i5.CustomersUseCase>(),
        ));
    gh.factory<_i38.DocumentUseCases>(() => _i39.DocumentUseCasesImpl(
          storage: gh<_i27.Storage>(),
          repository: gh<_i7.DocumentRepository>(),
          transactionRepository: gh<_i9.DocumentTransactionRepository>(),
        ));
    gh.factory<_i40.DocumentsCubit>(() => _i40.DocumentsCubit(
          storage: gh<_i27.Storage>(),
          useCase: gh<_i38.DocumentUseCases>(),
        ));
    gh.factory<_i41.ExpensesCubit>(() => _i41.ExpensesCubit(
          storage: gh<_i27.Storage>(),
          useCase: gh<_i13.ExpenseUseCases>(),
        ));
    gh.factory<_i42.GoodsCubit>(() => _i42.GoodsCubit(
          storage: gh<_i27.Storage>(),
          goodsUseCase: gh<_i17.GoodsUseCases>(),
          groupsUseCase: gh<_i21.GroupsUseCases>(),
          documentsUseCases: gh<_i38.DocumentUseCases>(),
        ));
    gh.factory<_i43.HomeCubit>(() => _i43.HomeCubit(
          storage: gh<_i27.Storage>(),
          goodsUseCases: gh<_i17.GoodsUseCases>(),
          documentsUseCases: gh<_i38.DocumentUseCases>(),
          supplierUseCases: gh<_i34.SuppliersUseCase>(),
          customerUseCase: gh<_i5.CustomersUseCase>(),
          expenseUseCases: gh<_i13.ExpenseUseCases>(),
        ));
    gh.factory<_i44.OnBoardingCubit>(() => _i44.OnBoardingCubit(
          useCase: gh<_i30.StoresUseCase>(),
          storage: gh<_i27.Storage>(),
        ));
    gh.factory<_i45.ReportCubit>(() => _i45.ReportCubit(
          storage: gh<_i27.Storage>(),
          expenseUseCase: gh<_i13.ExpenseUseCases>(),
        ));
    gh.factory<_i46.ReportDetailCubit>(() => _i46.ReportDetailCubit(
          storage: gh<_i27.Storage>(),
          expenseUseCase: gh<_i13.ExpenseUseCases>(),
          documentUseCases: gh<_i38.DocumentUseCases>(),
        ));
    gh.factory<_i47.SaveDocumentCubit>(() => _i47.SaveDocumentCubit(
          useCase: gh<_i38.DocumentUseCases>(),
          goodUseCases: gh<_i17.GoodsUseCases>(),
          storage: gh<_i27.Storage>(),
        ));
    gh.factory<_i48.SaveGoodCubit>(() => _i48.SaveGoodCubit(
          useCase: gh<_i17.GoodsUseCases>(),
          documentsUseCases: gh<_i38.DocumentUseCases>(),
          storage: gh<_i27.Storage>(),
        ));
    gh.factory<_i49.SaveStoreCubit>(
        () => _i49.SaveStoreCubit(useCase: gh<_i30.StoresUseCase>()));
    gh.factory<_i50.SaveSupplierCubit>(
        () => _i50.SaveSupplierCubit(useCase: gh<_i34.SuppliersUseCase>()));
    gh.factory<_i51.StoresCubit>(() => _i51.StoresCubit(
          storage: gh<_i27.Storage>(),
          useCase: gh<_i30.StoresUseCase>(),
        ));
    gh.factory<_i52.SuppliersCubit>(() => _i52.SuppliersCubit(
          storage: gh<_i27.Storage>(),
          useCase: gh<_i34.SuppliersUseCase>(),
        ));
    return this;
  }
}
