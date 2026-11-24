import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/save_good/bloc/save_good_cubit.dart';

MinimumQuantitySettings _min({required bool showInItem}) =>
    MinimumQuantitySettings(
      showInList: true,
      showInItem: showInItem,
      color: 0,
      showAlert: true,
    );

void main() {
  group('SaveGoodCubit.effectiveShowMinQuantity', () {
    test('true only when both the property and the item flag are on', () {
      expect(
          SaveGoodCubit.effectiveShowMinQuantity(
              GoodPropertiesSettings(), _min(showInItem: true)),
          isTrue);
    });
    test('false when the property is off even if the item flag is on', () {
      expect(
          SaveGoodCubit.effectiveShowMinQuantity(
              GoodPropertiesSettings(showMinQuantity: false),
              _min(showInItem: true)),
          isFalse);
    });
    test('false when the item flag is off even if the property is on', () {
      expect(
          SaveGoodCubit.effectiveShowMinQuantity(
              GoodPropertiesSettings(), _min(showInItem: false)),
          isFalse);
    });
  });
}
