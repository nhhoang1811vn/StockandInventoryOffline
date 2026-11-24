import '../../../data/app_settings.dart';
import '../../../repo/repo.dart';
import '../../exception/duplicate_exceptions.dart';

/// The Store's "Unique barcode" rule, shared by Goods and Groups.
///
/// When it is on, a barcode (compared trimmed) may be used by only one Good or
/// Group of a Store: a Good cannot take the barcode of another Good or of a
/// Group, and a Group cannot take the barcode of a Good or of another Group.
/// Goods and Groups have separate id spaces, so the item being saved is
/// excluded from the comparison by [selfIsGood] together with [selfId].
///
/// An unchanged barcode is always accepted ([storedBarcode] returns the saved
/// value), so an item that was a duplicate before the rule was turned on can
/// still be edited. Throws [DuplicateBarcodeException].
Future<void> ensureBarcodeUnique({
  required int storeId,
  required String? barcode,
  required int? selfId,
  required bool selfIsGood,
  required Future<String?> Function() storedBarcode,
  required GoodsRepository goods,
  required GroupsRepository groups,
}) async {
  if (!AppSettings.getGoodPropertiesSettings(storeId: storeId).uniqueBarcode) {
    return;
  }
  final code = barcode?.trim() ?? '';
  if (code.isEmpty) return;
  if (selfId != null && (await storedBarcode())?.trim() == code) return;

  final goodTaken = (await goods.getAllByStoreId(storeId)).any(
    (g) => !(selfIsGood && g.id == selfId) && (g.barCode?.trim() ?? '') == code,
  );
  if (goodTaken) throw DuplicateBarcodeException(code);

  final groupTaken = (await groups.getAllByStoreId(storeId)).any(
    (g) =>
        !(!selfIsGood && g.id == selfId) && (g.barCode?.trim() ?? '') == code,
  );
  if (groupTaken) throw DuplicateBarcodeException(code);
}
