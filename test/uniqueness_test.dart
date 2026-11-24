import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/exception/duplicate_exceptions.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/settings/good_properties/bloc/good_properties_cubit.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Like the real DB, the fakes keep their own copy of every saved row, so
/// mutating the object being edited does not change what is "stored".
class _FakeGoodsRepo extends Fake implements GoodsRepository {
  final Map<int, Good> rows = {};
  int _next = 1;

  Good _copy(Good g) => Good()
    ..id = g.id
    ..name = g.name
    ..barCode = g.barCode
    ..storeId = g.storeId;

  int get count => rows.length;

  @override
  Future<int> insert(Good item) async {
    item.id = _next++;
    rows[item.id!] = _copy(item);
    return item.id!;
  }

  @override
  Future<bool> update(Good item) async {
    rows[item.id!] = _copy(item);
    return true;
  }

  @override
  Future<Good> get(int id) async => _copy(rows[id]!);

  @override
  Future<List<Good>> getAllByStoreId(int storeId) async =>
      rows.values.where((g) => g.storeId == storeId).map(_copy).toList();
}

class _FakeGroupsRepo extends Fake implements GroupsRepository {
  final Map<int, Group> rows = {};
  int _next = 1;

  Group _copy(Group g) => Group()
    ..id = g.id
    ..name = g.name
    ..barCode = g.barCode
    ..groupId = g.groupId
    ..storeId = g.storeId;

  int get count => rows.length;

  @override
  Future<int> insert(Group item) async {
    item.id = _next++;
    rows[item.id!] = _copy(item);
    return item.id!;
  }

  @override
  Future<bool> update(Group item) async {
    rows[item.id!] = _copy(item);
    return true;
  }

  @override
  Future<Group> get(int id) async => _copy(rows[id]!);

  @override
  Future<List<Group>> getAllByStoreId(int storeId) async =>
      rows.values.where((g) => g.storeId == storeId).map(_copy).toList();
}

class _FakeTxRepo extends Fake implements DocumentTransactionRepository {}

Good _good(String? barcode, {int storeId = 1}) => Good()
  ..name = 'g'
  ..barCode = barcode
  ..storeId = storeId;

Group _group(String name, {int storeId = 1, String? barcode}) => Group()
  ..name = name
  ..barCode = barcode
  ..storeId = storeId;

void main() {
  late SharedPreferences prefs;

  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('uq_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  void enable({bool barcode = false, bool group = false, int storeId = 1}) {
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(uniqueBarcode: barcode, uniqueGroupName: group),
      storeId: storeId,
    );
  }

  group('settings', () {
    test('both flags default to off', () {
      final s = AppSettings.getGoodPropertiesSettings(storeId: 1);
      expect(s.uniqueBarcode, isFalse);
      expect(s.uniqueGroupName, isFalse);
    });

    test('are saved per store and old json keeps them off', () async {
      enable(barcode: true, storeId: 1);
      expect(AppSettings.getGoodPropertiesSettings(storeId: 1).uniqueBarcode,
          isTrue);
      expect(AppSettings.getGoodPropertiesSettings(storeId: 2).uniqueBarcode,
          isFalse);
      await prefs.setString('GoodPropertiesSettings_4', '{"showImage":false}');
      expect(AppSettings.getGoodPropertiesSettings(storeId: 4).uniqueBarcode,
          isFalse);
    });

    test('the settings cubit saves the two toggles', () {
      AppSettings.setSelectedStoreId(31);
      final cubit = GoodPropertiesCubit()..init();
      expect(cubit.state.uniqueBarcode, isFalse);
      cubit.onUniqueBarcodeChanged(true);
      cubit.onUniqueGroupNameChanged(true);
      final saved = AppSettings.getGoodPropertiesSettings(storeId: 31);
      expect(saved.uniqueBarcode, isTrue);
      expect(saved.uniqueGroupName, isTrue);
      expect(saved.showImage, isTrue);
      final fresh = GoodPropertiesCubit()..init();
      expect(fresh.state.uniqueBarcode, isTrue);
      expect(fresh.state.uniqueGroupName, isTrue);
    });
  });

  group('unique barcode', () {
    late _FakeGoodsRepo repo;
    late GoodsUseCases useCase;

    setUp(() {
      repo = _FakeGoodsRepo();
      useCase = GoodsUseCases(
          repository: repo,
          documentTransactionRepository: _FakeTxRepo(),
          groupsRepository: _FakeGroupsRepo());
    });

    test('off: identical barcodes are still allowed', () async {
      await useCase.insert(_good('123'));
      await useCase.insert(_good('123'));
      expect(repo.count, 2);
    });

    test('on: a second Good with the same barcode is rejected', () async {
      enable(barcode: true);
      await useCase.insert(_good('123'));
      await expectLater(useCase.insert(_good('123')),
          throwsA(isA<DuplicateBarcodeException>()));
      expect(repo.count, 1);
    });

    test('on: the barcode is compared trimmed', () async {
      enable(barcode: true);
      await useCase.insert(_good('123'));
      await expectLater(useCase.insert(_good(' 123 ')),
          throwsA(isA<DuplicateBarcodeException>()));
    });

    test('on: empty or missing barcodes never conflict', () async {
      enable(barcode: true);
      await useCase.insert(_good(null));
      await useCase.insert(_good(''));
      await useCase.insert(_good('  '));
      expect(repo.count, 3);
    });

    test('on: the same barcode in another store is allowed', () async {
      enable(barcode: true, storeId: 1);
      enable(barcode: true, storeId: 2);
      await useCase.insert(_good('123', storeId: 1));
      await useCase.insert(_good('123', storeId: 2));
      expect(repo.count, 2);
    });

    test('on: only the Good\'s own store setting counts', () async {
      enable(barcode: true, storeId: 1);
      await useCase.insert(_good('123', storeId: 2));
      await useCase.insert(_good('123', storeId: 2));
      expect(repo.count, 2);
    });

    test('on: changing a barcode to another Good\'s barcode is rejected',
        () async {
      enable(barcode: true);
      await useCase.insert(_good('111'));
      final other = _good('222');
      await useCase.insert(other);
      other.barCode = '111';
      await expectLater(
          useCase.update(other), throwsA(isA<DuplicateBarcodeException>()));
    });

    test('on: saving a Good with its own unchanged barcode is allowed',
        () async {
      enable(barcode: true);
      final g = _good('111');
      await useCase.insert(g);
      g.name = 'renamed';
      expect(await useCase.update(g), isTrue);
    });

    test('on: a pre-existing duplicate can still be edited unchanged',
        () async {
      await useCase.insert(_good('111'));
      final dup = _good('111');
      await useCase.insert(dup); // created while the rule was off
      enable(barcode: true);
      dup.name = 'edited';
      expect(await useCase.update(dup), isTrue);
    });
  });

  group('unique group name', () {
    late _FakeGroupsRepo repo;
    late GroupsUseCases useCase;

    setUp(() {
      repo = _FakeGroupsRepo();
      useCase =
          GroupsUseCases(repository: repo, goodsRepository: _FakeGoodsRepo());
    });

    test('off: identical names are still allowed', () async {
      await useCase.insert(_group('Drinks'));
      await useCase.insert(_group('Drinks'));
      expect(repo.count, 2);
    });

    test('on: a second Group with the same name is rejected', () async {
      enable(group: true);
      await useCase.insert(_group('Drinks'));
      await expectLater(useCase.insert(_group('Drinks')),
          throwsA(isA<DuplicateGroupNameException>()));
      expect(repo.count, 1);
    });

    test('on: names compare trimmed and ignoring case', () async {
      enable(group: true);
      await useCase.insert(_group('Drinks'));
      await expectLater(useCase.insert(_group('  dRINKS ')),
          throwsA(isA<DuplicateGroupNameException>()));
    });

    test('on: the check covers every Group of the store, not only siblings',
        () async {
      enable(group: true);
      final parent = _group('Parent');
      await useCase.insert(parent);
      await useCase.insert(_group('Child')..groupId = parent.id);
      await expectLater(useCase.insert(_group('Child')),
          throwsA(isA<DuplicateGroupNameException>()));
    });

    test('on: the same name in another store is allowed', () async {
      enable(group: true, storeId: 1);
      enable(group: true, storeId: 2);
      await useCase.insert(_group('Drinks', storeId: 1));
      await useCase.insert(_group('Drinks', storeId: 2));
      expect(repo.count, 2);
    });

    test('on: renaming to another Group\'s name is rejected', () async {
      enable(group: true);
      await useCase.insert(_group('A'));
      final b = _group('B');
      await useCase.insert(b);
      b.name = 'a';
      await expectLater(
          useCase.update(b), throwsA(isA<DuplicateGroupNameException>()));
    });

    test('on: saving a Group with its own unchanged name is allowed', () async {
      enable(group: true);
      final g = _group('A');
      await useCase.insert(g);
      g.description = 'new description';
      expect(await useCase.update(g), isTrue);
    });

    test('on: a pre-existing duplicate can still be edited unchanged',
        () async {
      await useCase.insert(_group('A'));
      final dup = _group('A');
      await useCase.insert(dup);
      enable(group: true);
      dup.description = 'edited';
      expect(await useCase.update(dup), isTrue);
    });
  });

  group('unique barcode across Goods and Groups', () {
    late _FakeGoodsRepo goodsRepo;
    late _FakeGroupsRepo groupsRepo;
    late GoodsUseCases goods;
    late GroupsUseCases groups;

    setUp(() {
      goodsRepo = _FakeGoodsRepo();
      groupsRepo = _FakeGroupsRepo();
      goods = GoodsUseCases(
          repository: goodsRepo,
          documentTransactionRepository: _FakeTxRepo(),
          groupsRepository: groupsRepo);
      groups =
          GroupsUseCases(repository: groupsRepo, goodsRepository: goodsRepo);
    });

    test('on: a Good cannot take the barcode of a Group', () async {
      enable(barcode: true);
      await groups.insert(_group('Folder', barcode: '777'));
      await expectLater(goods.insert(_good('777')),
          throwsA(isA<DuplicateBarcodeException>()));
      expect(goodsRepo.count, 0);
    });

    test('on: a Group cannot take the barcode of a Good', () async {
      enable(barcode: true);
      await goods.insert(_good('555'));
      await expectLater(groups.insert(_group('Folder', barcode: '555')),
          throwsA(isA<DuplicateBarcodeException>()));
      expect(groupsRepo.count, 0);
    });

    test('on: two Groups cannot share a barcode', () async {
      enable(barcode: true);
      await groups.insert(_group('A', barcode: '9'));
      await expectLater(groups.insert(_group('B', barcode: ' 9 ')),
          throwsA(isA<DuplicateBarcodeException>()));
    });

    test(
        'on: a Good and a Group with different ids but the same number are '
        'compared by barcode only', () async {
      enable(barcode: true);
      final good = _good('1'); // id 1 in the Goods table
      await goods.insert(good);
      final group = _group('F', barcode: '2'); // id 1 in the Groups table
      await groups.insert(group);
      // Saving each with its own unchanged barcode is fine even though the
      // two ids are equal.
      good.name = 'x';
      group.description = 'x';
      expect(await goods.update(good), isTrue);
      expect(await groups.update(group), isTrue);
    });

    test('on: editing a Group to another Group\'s or Good\'s barcode fails',
        () async {
      enable(barcode: true);
      await goods.insert(_good('G'));
      await groups.insert(_group('A', barcode: 'A'));
      final b = _group('B', barcode: 'B');
      await groups.insert(b);
      b.barCode = 'A';
      await expectLater(
          groups.update(b), throwsA(isA<DuplicateBarcodeException>()));
      b.barCode = 'G';
      await expectLater(
          groups.update(b), throwsA(isA<DuplicateBarcodeException>()));
    });

    test('on: empty Group barcodes never conflict', () async {
      enable(barcode: true);
      await groups.insert(_group('A', barcode: ''));
      await groups.insert(_group('B', barcode: null));
      await goods.insert(_good(''));
      expect(groupsRepo.count, 2);
    });

    test(
        'on: a pre-existing Good/Group duplicate can still be edited '
        'unchanged', () async {
      await goods.insert(_good('D'));
      final g = _group('F', barcode: 'D');
      await groups.insert(g); // created while the rule was off
      enable(barcode: true);
      g.description = 'edited';
      expect(await groups.update(g), isTrue);
    });

    test('the same barcode in another store is allowed, and off allows all',
        () async {
      enable(barcode: true, storeId: 1);
      await goods.insert(_good('S', storeId: 1));
      await groups.insert(_group('F', storeId: 2, barcode: 'S'));
      expect(groupsRepo.count, 1);

      enable(barcode: false, storeId: 1);
      await groups.insert(_group('G', storeId: 1, barcode: 'S'));
      expect(groupsRepo.count, 2);
    });
  });
}
