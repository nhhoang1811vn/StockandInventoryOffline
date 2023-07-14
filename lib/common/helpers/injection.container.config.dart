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
    as _i4;
import 'package:good_manager/data/repositories/goods_repository_impl.dart'
    as _i6;
import 'package:good_manager/data/repositories/groups_repository_impl.dart'
    as _i10;
import 'package:good_manager/data/repositories/stores_repository_impl.dart'
    as _i18;
import 'package:good_manager/data/repositories/suppliers_repository_impl.dart'
    as _i22;
import 'package:good_manager/data/storage.dart' as _i16;
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart'
    as _i3;
import 'package:good_manager/domain/repositories/goods_repositories.dart'
    as _i5;
import 'package:good_manager/domain/repositories/groups_repositories.dart'
    as _i9;
import 'package:good_manager/domain/repositories/stores_repositories.dart'
    as _i17;
import 'package:good_manager/domain/repositories/suppliers_repositories.dart'
    as _i21;
import 'package:good_manager/domain/usecases/goods/goods_usecases_impl.dart'
    as _i8;
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart' as _i7;
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart'
    as _i11;
import 'package:good_manager/domain/usecases/groups/groups_usecases_impl.dart'
    as _i12;
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart'
    as _i19;
import 'package:good_manager/domain/usecases/stores/stores_usecases_impl.dart'
    as _i20;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases.dart'
    as _i23;
import 'package:good_manager/domain/usecases/suppliers/suppliers_usecases_impl.dart'
    as _i24;
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_cubit.dart'
    as _i25;
import 'package:good_manager/presentation/pages/goods/bloc/goods_cubit2.dart'
    as _i26;
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart'
    as _i13;
import 'package:good_manager/presentation/pages/onboarding/bloc/on_boarding_cubit.dart'
    as _i27;
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart'
    as _i14;
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart'
    as _i15;
import 'package:good_manager/presentation/pages/save_supplier/bloc/save_supplier_cubit.dart'
    as _i28;
import 'package:good_manager/presentation/pages/suppliers/bloc/suppliers_cubit.dart'
    as _i29;
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
    gh.factory<_i3.DocumentTransactionRepository>(
        () => _i4.DocumentTransactionRepositoryImpl());
    gh.factory<_i5.GoodsRepository>(() => _i6.GoodsRepositoryImpl());
    gh.factory<_i7.GoodsUseCases>(() => _i8.GoodsUseCaseImpl(
          repository: gh<_i5.GoodsRepository>(),
          documentTransactionRepository:
              gh<_i3.DocumentTransactionRepository>(),
        ));
    gh.factory<_i9.GroupsRepository>(() => _i10.GroupsRepositoryImpl());
    gh.factory<_i11.GroupsUseCases>(
        () => _i12.GroupsUseCaseImpl(repository: gh<_i9.GroupsRepository>()));
    gh.factory<_i13.HomeCubit>(() => _i13.HomeCubit());
    gh.factory<_i14.SaveGoodCubit>(
        () => _i14.SaveGoodCubit(useCase: gh<_i7.GoodsUseCases>()));
    gh.factory<_i15.SaveGroupCubit>(
        () => _i15.SaveGroupCubit(useCase: gh<_i11.GroupsUseCases>()));
    gh.singleton<_i16.Storage>(_i16.Storage());
    gh.factory<_i17.StoresRepository>(() => _i18.StoresRepositoryImpl());
    gh.factory<_i19.StoresUseCase>(
        () => _i20.StoresUseCaseImpl(repository: gh<_i17.StoresRepository>()));
    gh.factory<_i21.SuppliersRepository>(() => _i22.SuppliersRepositoryImpl());
    gh.factory<_i23.SuppliersUseCase>(() =>
        _i24.SuppliersUseCaseImpl(repository: gh<_i21.SuppliersRepository>()));
    gh.factory<_i25.ExpensesCubit>(
        () => _i25.ExpensesCubit(storage: gh<_i16.Storage>()));
    gh.factory<_i26.GoodsCubit>(() => _i26.GoodsCubit(
          storage: gh<_i16.Storage>(),
          goodsUseCase: gh<_i7.GoodsUseCases>(),
          groupsUseCase: gh<_i11.GroupsUseCases>(),
        ));
    gh.factory<_i27.OnBoardingCubit>(() => _i27.OnBoardingCubit(
          useCase: gh<_i19.StoresUseCase>(),
          storage: gh<_i16.Storage>(),
        ));
    gh.factory<_i28.SaveSupplierCubit>(
        () => _i28.SaveSupplierCubit(useCase: gh<_i23.SuppliersUseCase>()));
    gh.factory<_i29.SuppliersCubit>(() => _i29.SuppliersCubit(
          storage: gh<_i16.Storage>(),
          useCase: gh<_i23.SuppliersUseCase>(),
        ));
    return this;
  }
}
