import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/usecase/stores/stores_usecases.dart';
import 'package:good_manager/presentation/pages/startup/bloc/startup_cubit.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeStoresUseCase implements StoresUseCase {
  List<Store> stores = [];
  bool shouldThrow = false;

  @override
  Future<List<Store>> getAll() async {
    if (shouldThrow) throw Exception('db unavailable');
    return stores;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Store _store(int id, String name) => Store()
  ..id = id
  ..name = name;

void main() {
  late _FakeStoresUseCase useCase;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('startup_cubit_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    useCase = _FakeStoresUseCase();
  });

  test('empty store list emits StartupNoStore', () async {
    final cubit = StartupCubit(useCase);
    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([isA<StartupLoading>(), isA<StartupNoStore>()]),
    );
    cubit.load();
    await emitted;
  });

  test('non-empty list emits StartupHasStore', () async {
    useCase.stores = [_store(1, 'A')];
    final cubit = StartupCubit(useCase);
    final emitted = expectLater(
      cubit.stream,
      emitsInOrder([isA<StartupLoading>(), isA<StartupHasStore>()]),
    );
    cubit.load();
    await emitted;
  });

  test('selected id still valid is kept', () async {
    useCase.stores = [_store(1, 'A'), _store(2, 'B')];
    AppSettings.setSelectedStoreId(2);
    AppSettings.setSelectedStoreName('B');
    final cubit = StartupCubit(useCase);
    final emitted = expectLater(cubit.stream,
        emitsThrough(isA<StartupHasStore>()));
    cubit.load();
    await emitted;
    expect(AppSettings.getSelectedStoreId(), 2);
    expect(AppSettings.getSelectedStoreName(), 'B');
  });

  test('selected id missing selects first store id and name', () async {
    useCase.stores = [_store(5, 'First'), _store(6, 'Second')];
    AppSettings.setSelectedStoreId(99);
    final cubit = StartupCubit(useCase);
    final emitted = expectLater(cubit.stream,
        emitsThrough(isA<StartupHasStore>()));
    cubit.load();
    await emitted;
    expect(AppSettings.getSelectedStoreId(), 5);
    expect(AppSettings.getSelectedStoreName(), 'First');
  });

  test('getAll throwing emits StartupFailure and retry recovers', () async {
    useCase.shouldThrow = true;
    final cubit = StartupCubit(useCase);
    final failed =
        expectLater(cubit.stream, emitsThrough(isA<StartupFailure>()));
    cubit.load();
    await failed;

    useCase.shouldThrow = false;
    useCase.stores = [_store(1, 'A')];
    final recovered =
        expectLater(cubit.stream, emitsThrough(isA<StartupHasStore>()));
    cubit.load();
    await recovered;
  });
}
