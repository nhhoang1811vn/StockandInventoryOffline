part of 'good_properties_cubit.dart';

@freezed
class GoodPropertiesState with _$GoodPropertiesState {
  const factory GoodPropertiesState.initial({
    @Default(true) bool showImage,
    @Default(true) bool showBarcode,
    @Default(true) bool showDescription,
    @Default(true) bool showMinQuantity,
    @Default(true) bool showPurchasePrice,
    @Default(true) bool showSalePrice,
    @Default(false) bool uniqueBarcode,
    @Default(false) bool uniqueGroupName,
    @Default(2) int quantityDecimals,
  }) = _Initial;
}
