part of 'save_good_cubit.dart';

@freezed
class SaveGoodState with _$SaveGoodState {
  const factory SaveGoodState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    @Default('') String barCode,
    double? purchasePrice,
    double? salePrice,
    @Default([]) List<Uint8List> files,
    double? minQuantity,
    @Default(true) bool showMinQuantity,
    @Default(true) bool showImage,
    @Default(true) bool showBarcode,
    @Default(true) bool showDescription,
    @Default(true) bool showPurchasePrice,
    @Default(true) bool showSalePrice,
    Good? item,
    Document? document,
    DocumentTransaction? transaction,
  }) = _Initial;
}
