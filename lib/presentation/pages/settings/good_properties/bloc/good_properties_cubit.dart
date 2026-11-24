import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';
import '../../../../../domain/entity/entity.dart';

part 'good_properties_cubit.freezed.dart';
part 'good_properties_state.dart';

@injectable
class GoodPropertiesCubit extends Cubit<GoodPropertiesState> {
  GoodPropertiesCubit() : super(const GoodPropertiesState.initial());

  void init() {
    final settings = AppSettings.getGoodPropertiesSettings();
    emit(
      state.copyWith(
        showImage: settings.showImage,
        showBarcode: settings.showBarcode,
        showDescription: settings.showDescription,
        showMinQuantity: settings.showMinQuantity,
        showPurchasePrice: settings.showPurchasePrice,
        showSalePrice: settings.showSalePrice,
        uniqueBarcode: settings.uniqueBarcode,
        uniqueGroupName: settings.uniqueGroupName,
      ),
    );
  }

  void onShowPurchasePriceChanged(bool value) {
    emit(state.copyWith(showPurchasePrice: value));
    _save();
  }

  void onShowSalePriceChanged(bool value) {
    emit(state.copyWith(showSalePrice: value));
    _save();
  }

  void onShowImageChanged(bool value) {
    emit(state.copyWith(showImage: value));
    _save();
  }

  void onShowBarcodeChanged(bool value) {
    emit(state.copyWith(showBarcode: value));
    _save();
  }

  void onShowDescriptionChanged(bool value) {
    emit(state.copyWith(showDescription: value));
    _save();
  }

  void onShowMinQuantityChanged(bool value) {
    emit(state.copyWith(showMinQuantity: value));
    _save();
  }

  void onUniqueBarcodeChanged(bool value) {
    emit(state.copyWith(uniqueBarcode: value));
    _save();
  }

  void onUniqueGroupNameChanged(bool value) {
    emit(state.copyWith(uniqueGroupName: value));
    _save();
  }

  void _save() {
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(
        showImage: state.showImage,
        showBarcode: state.showBarcode,
        showDescription: state.showDescription,
        showMinQuantity: state.showMinQuantity,
        showPurchasePrice: state.showPurchasePrice,
        showSalePrice: state.showSalePrice,
        uniqueBarcode: state.uniqueBarcode,
        uniqueGroupName: state.uniqueGroupName,
      ),
    );
  }
}
