import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/goods/component/excel_column_mapping.dart';

void main() {
  test('defaults leave a hidden property unmapped and keep the others', () {
    final mapping = ExcelColumnMapping.defaults(
      properties: GoodPropertiesSettings(showBarcode: false),
    );
    expect(mapping[ExcelImportField.barcode], isNull);
    expect(mapping[ExcelImportField.description], 1);
    expect(mapping[ExcelImportField.name], 0);
  });

  test('import defaults keep standard column positions when a field is hidden',
      () {
    final mapping = ExcelColumnMapping.defaults(
      properties: GoodPropertiesSettings(showBarcode: false),
    );
    expect(mapping[ExcelImportField.barcode], isNull);
    expect(mapping[ExcelImportField.purchasePrice], 3);
    expect(mapping[ExcelImportField.salePrice], 4);
    expect(mapping[ExcelImportField.minQuantity], 5);
  });

  test('compact (export) defaults pack visible fields with no gap', () {
    final mapping = ExcelColumnMapping.defaults(
      properties: GoodPropertiesSettings(showBarcode: false),
      compact: true,
    );
    expect(mapping[ExcelImportField.barcode], isNull);
    expect(mapping[ExcelImportField.purchasePrice], 2);
    expect(mapping[ExcelImportField.salePrice], 3);
    expect(mapping[ExcelImportField.minQuantity], 4);
  });

  test('defaults without properties are unchanged', () {
    final mapping = ExcelColumnMapping.defaults();
    expect(mapping[ExcelImportField.barcode], 2);
    expect(mapping[ExcelImportField.minQuantity], 5);
  });

  test('visibleFields with everything hidden keeps name and prices', () {
    final fields = ExcelColumnMapping.visibleFields(GoodPropertiesSettings(
      showBarcode: false,
      showDescription: false,
      showMinQuantity: false,
    ));
    expect(fields, [
      ExcelImportField.name,
      ExcelImportField.purchasePrice,
      ExcelImportField.salePrice,
    ]);
  });

  test('hidden prices drop their Excel fields and keep standard positions', () {
    final props = GoodPropertiesSettings(showPurchasePrice: false);
    expect(ExcelColumnMapping.visibleFields(props), [
      ExcelImportField.name,
      ExcelImportField.description,
      ExcelImportField.barcode,
      ExcelImportField.salePrice,
      ExcelImportField.minQuantity,
    ]);
    final mapping = ExcelColumnMapping.defaults(properties: props);
    expect(mapping[ExcelImportField.purchasePrice], isNull);
    expect(mapping[ExcelImportField.salePrice], 4);
  });

  test('with every optional property hidden only name remains', () {
    expect(
        ExcelColumnMapping.visibleFields(GoodPropertiesSettings(
          showBarcode: false,
          showDescription: false,
          showMinQuantity: false,
          showPurchasePrice: false,
          showSalePrice: false,
        )),
        [ExcelImportField.name]);
  });

  test('visibleFields with defaults lists all six in enum order', () {
    expect(ExcelColumnMapping.visibleFields(GoodPropertiesSettings()),
        ExcelImportField.values);
  });
}
