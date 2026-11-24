import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';

void main() {
  final good = Good()
    ..purchasePrice = 10
    ..salePrice = 15;

  group('showPriceFor', () {
    test('incoming follows Purchase price, outgoing follows Sale price', () {
      final p = GoodPropertiesSettings(showPurchasePrice: false);
      expect(p.showPriceFor(DocumentType.incoming), isFalse);
      expect(p.showPriceFor(DocumentType.outgoing), isTrue);

      final s = GoodPropertiesSettings(showSalePrice: false);
      expect(s.showPriceFor(DocumentType.incoming), isTrue);
      expect(s.showPriceFor(DocumentType.outgoing), isFalse);
    });
  });

  group('showPriceForAll', () {
    test('true only when every document type in the set shows its price', () {
      const both = [DocumentType.incoming, DocumentType.outgoing];
      expect(GoodPropertiesSettings().showPriceForAll(both), isTrue);
      expect(
          GoodPropertiesSettings(showPurchasePrice: false)
              .showPriceForAll(both),
          isFalse);
      expect(GoodPropertiesSettings(showSalePrice: false).showPriceForAll(both),
          isFalse);
    });

    test('only looks at the types present', () {
      final p = GoodPropertiesSettings(showPurchasePrice: false);
      expect(p.showPriceForAll([DocumentType.outgoing]), isTrue);
      expect(p.showPriceForAll([DocumentType.incoming]), isFalse);
    });

    test('an empty set is shown', () {
      final p = GoodPropertiesSettings(
          showPurchasePrice: false, showSalePrice: false);
      expect(p.showPriceForAll(const []), isTrue);
    });
  });

  group('defaultPriceFor', () {
    test('returns the matching Good price when the price is shown', () {
      final p = GoodPropertiesSettings();
      expect(p.defaultPriceFor(good, DocumentType.incoming), 10);
      expect(p.defaultPriceFor(good, DocumentType.outgoing), 15);
    });

    test('returns null when that price is hidden, so no hidden price is used',
        () {
      expect(
          GoodPropertiesSettings(showPurchasePrice: false)
              .defaultPriceFor(good, DocumentType.incoming),
          isNull);
      expect(
          GoodPropertiesSettings(showSalePrice: false)
              .defaultPriceFor(good, DocumentType.outgoing),
          isNull);
      // The other direction is unaffected.
      expect(
          GoodPropertiesSettings(showPurchasePrice: false)
              .defaultPriceFor(good, DocumentType.outgoing),
          15);
    });
  });
}
