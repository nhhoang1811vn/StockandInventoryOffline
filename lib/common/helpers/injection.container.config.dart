// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:good_manager/data/repositories/document_transactions_repository_impl.dart'
    as _i6;
import 'package:good_manager/data/repositories/documents_repository_impl.dart'
    as _i4;
import 'package:good_manager/data/repositories/expense_repository_impl.dart'
    as _i10;
import 'package:good_manager/data/repositories/goods_repository_impl.dart'
    as _i14;
import 'package:good_manager/data/repositories/groups_repository_impl.dart'
    as _i18;
import 'package:good_manager/data/repositories/stores_repository_impl.dart'
    as _i28;
import 'package:good_manager/data/repositories/suppliers_repository_impl.dart'
    as _i32;
import 'package:good_manager/data/storage.dart' as _i26;
import 'package:good_manager/domain/repositories/document_repositories.dart'
    as _i3;
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart'
    as _i5;
import 'package:good_manager/domain/repositories/expense_repositories.dart'
    as _i9;
import 'package:good_manager/domain/repositories/goods_repositories.dart'
    as _i13;
import 'package:good_manager/domain/repositories/groups_repositories.dart'
    as _i17;
import 'package:good_manager/domain/repositories/stores_repositories.dart'
    as _i27;
import 'package:good_manager/domain/repositories/suppliers_repositories.dart'
    as _i31;
import 'package:good_manager/domain/usecases/documents/document_usecases.dart'
    as _i7;
import 'package:good_manager/domain/usecases/documents/document_usecases_impl.dart'
    as _i8;
import 'package:good_manager/domain/usecases/expenses/expense_usecases_impl.dart'
    as _i12;
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart'
    as _i11;
import 'package:good_manager/domain/usecases/goods/goods_usecases_impl.dart'
    as _i16;
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart'
    as _i15;
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart'
    as _i19;
import 'package:good_manager/domain/usecases/groups/groups_usecases_impl.dart'
    as _i20;
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart'
    as _i29;
import 'package:good_manager/domain/usecases/stores/stores_usecases_impl.dart'
    as _i30;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart'
    as _i33;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases_impl.dart'
    as _i34;
import 'package:good_manager/presentation/pages/documents/bloc/documents_cubit.dart'
    as _i35;
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart'
    as _i36;
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit2.dart'
    as _i37;
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart'
    as _i38;
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart'
    as _i39;
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart'
    as _i21;
import 'package:good_manager/presentation/pages/save_expense/bloc/save_expense_cubit.dart'
    as _i22;
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart'
    as _i23;
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart'
    as _i24;
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart'
    as _i40;
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart'
    as _i41;
import 'package:good_manager/presentation/pages/select_group/bloc/select_group_cubit.dart'
    as _i25;
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart'
    as _i42;
import 'package:good_manager/presentation/pages/suppliers/bloc/suppliers_cubit.dart'
    as _i43;
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
    gh.factory<_i3.DocumentRepository>(() => _i4.DocumentRepositoryImpl());
    gh.factory<_i5.DocumentTransactionRepository>(
        () => _i6.DocumentTransactionRepositoryImpl());
    gh.factory<_i7.DocumentUseCases>(() => _i8.DocumentUseCasesImpl(
          repository: gh<_i3.DocumentRepository>(),
          transactionRepository: gh<_i5.DocumentTransactionRepository>(),
        ));
    gh.factory<_i9.ExpenseRepository>(() => _i10.ExpenseRepositoryImpl());
    gh.factory<_i11.ExpenseUseCases>(() =>
        _i12.ExpenseUseCasesImpl(repository: gh<_i9.ExpenseRepository>()));
    gh.factory<_i13.GoodsRepository>(() => _i14.GoodsRepositoryImpl());
    gh.factory<_i15.GoodsUseCases>(() => _i16.GoodsUseCaseImpl(
          repository: gh<_i13.GoodsRepository>(),
          documentTransactionRepository:
              gh<_i5.DocumentTransactionRepository>(),
        ));
    gh.factory<_i17.GroupsRepository>(() => _i18.GroupsRepositoryImpl());
    gh.factory<_i19.GroupsUseCases>(
        () => _i20.GroupsUseCaseImpl(repository: gh<_i17.GroupsRepository>()));
    gh.factory<_i21.SaveDocumentCubit>(
        () => _i21.SaveDocumentCubit(useCase: gh<_i7.DocumentUseCases>()));
    gh.factory<_i22.SaveExpenseCubit>(
        () => _i22.SaveExpenseCubit(useCase: gh<_i11.ExpenseUseCases>()));
    gh.factory<_i23.SaveGoodCubit>(
        () => _i23.SaveGoodCubit(useCase: gh<_i15.GoodsUseCases>()));
    gh.factory<_i24.SaveGroupCubit>(
        () => _i24.SaveGroupCubit(useCase: gh<_i19.GroupsUseCases>()));
    gh.factory<_i25.SelectGroupCubit>(
        () => _i25.SelectGroupCubit(groupsUseCase: gh<_i19.GroupsUseCases>()));
    gh.singleton<_i26.Storage>(_i26.Storage());
    gh.factory<_i27.StoresRepository>(() => _i28.StoresRepositoryImpl());
    gh.factory<_i29.StoresUseCase>(
        () => _i30.StoresUseCaseImpl(repository: gh<_i27.StoresRepository>()));
    gh.factory<_i31.SuppliersRepository>(() => _i32.SuppliersRepositoryImpl());
    gh.factory<_i33.SuppliersUseCase>(() =>
        _i34.SuppliersUseCaseImpl(repository: gh<_i31.SuppliersRepository>()));
    gh.factory<_i35.DocumentsCubit>(() => _i35.DocumentsCubit(
          storage: gh<_i26.Storage>(),
          useCase: gh<_i7.DocumentUseCases>(),
        ));
    gh.factory<_i36.ExpensesCubit>(() => _i36.ExpensesCubit(
          storage: gh<_i26.Storage>(),
          useCase: gh<_i11.ExpenseUseCases>(),
        ));
    gh.factory<_i37.GoodsCubit>(() => _i37.GoodsCubit(
          storage: gh<_i26.Storage>(),
          goodsUseCase: gh<_i15.GoodsUseCases>(),
          groupsUseCase: gh<_i19.GroupsUseCases>(),
          documentsUseCases: gh<_i7.DocumentUseCases>(),
        ));
    gh.factory<_i38.HomeCubit>(() => _i38.HomeCubit(
          storage: gh<_i26.Storage>(),
          goodsUseCases: gh<_i15.GoodsUseCases>(),
          documentsUseCases: gh<_i7.DocumentUseCases>(),
          supplierUseCases: gh<_i33.SuppliersUseCase>(),
          expenseUseCases: gh<_i11.ExpenseUseCases>(),
        ));
    gh.factory<_i39.OnBoardingCubit>(() => _i39.OnBoardingCubit(
          useCase: gh<_i29.StoresUseCase>(),
          storage: gh<_i26.Storage>(),
        ));
    gh.factory<_i40.SaveStoreCubit>(
        () => _i40.SaveStoreCubit(useCase: gh<_i29.StoresUseCase>()));
    gh.factory<_i41.SaveSupplierCubit>(
        () => _i41.SaveSupplierCubit(useCase: gh<_i33.SuppliersUseCase>()));
    gh.factory<_i42.StoresCubit>(() => _i42.StoresCubit(
          storage: gh<_i26.Storage>(),
          useCase: gh<_i29.StoresUseCase>(),
        ));
    gh.factory<_i43.SuppliersCubit>(() => _i43.SuppliersCubit(
          storage: gh<_i26.Storage>(),
          useCase: gh<_i33.SuppliersUseCase>(),
        ));
    return this;
  }
}
