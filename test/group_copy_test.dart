import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/goods/group_copy.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/repo/repo.dart';

class _FakeGroupsRepository extends Fake implements GroupsRepository {}

class _FakeGoodsRepository extends Fake implements GoodsRepository {}

Group _source() {
  return Group()
    ..id = 5
    ..name = 'Drinks'
    ..description = 'Cold'
    ..barCode = 'G1'
    ..file = 'f.png'
    ..files = ['a', 'b']
    ..storeId = 1
    ..groupId = 2;
}

void main() {
  group('buildCopyOfGroup', () {
    test('copies kept fields and adds the suffix', () {
      final copy = buildCopyOfGroup(_source(), storeId: 1, groupId: 2);
      expect(copy.name, 'Drinks (copy)');
      expect(copy.description, 'Cold');
      expect(copy.barCode, 'G1');
      expect(copy.file, 'f.png');
      expect(copy.files, ['a', 'b']);
    });

    test('is a new unsaved group in the chosen store and parent', () {
      final copy = buildCopyOfGroup(_source(), storeId: 9, groupId: null);
      expect(copy.id, isNull);
      expect(copy.storeId, 9);
      expect(copy.groupId, isNull);
    });

    test('keeps nulls as null and files list independent', () {
      final bare = Group()
        ..name = 'A'
        ..storeId = 1;
      final copyOfBare = buildCopyOfGroup(bare, storeId: 1);
      expect(copyOfBare.barCode, isNull);
      expect(copyOfBare.file, isNull);

      final source = _source();
      final copy = buildCopyOfGroup(source, storeId: 1);
      copy.files.add('c');
      expect(source.files.length, 2);
    });
  });

  group('SaveGroupCubit.init', () {
    SaveGroupCubit cubit() => SaveGroupCubit(
        useCase: GroupsUseCases(
            repository: _FakeGroupsRepository(),
            goodsRepository: _FakeGoodsRepository()));

    test('prefills the form from an unsaved copy', () {
      final c = cubit();
      c.init(buildCopyOfGroup(_source(), storeId: 1, groupId: 2));
      expect(c.state.name.value, 'Drinks (copy)');
      expect(c.state.description, 'Cold');
      expect(c.state.barCode, 'G1');
      expect(c.state.file, 'f.png');
      expect(c.state.files, ['a', 'b']);
    });

    test('a brand new empty group still starts with a pristine form', () {
      final c = cubit();
      c.init(Group()..storeId = 1);
      expect(c.state.name.isPure, isTrue);
      expect(c.state.description, '');
      expect(c.state.files, isEmpty);
    });
  });
}
