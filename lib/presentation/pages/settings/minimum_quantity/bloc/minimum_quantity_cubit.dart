import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';
import '../../../../../domain/entity/entity.dart';

part 'minimum_quantity_cubit.freezed.dart';
part 'minimum_quantity_state.dart';

@injectable
class MinimumQuantityCubit extends Cubit<MinimumQuantityState> {
  MinimumQuantityCubit() : super(MinimumQuantityState.initial());

  void init() async {
    MinimumQuantitySettings settings =
        await AppSettings.getMinimumQuantitySettings();
    emit(
      state.copyWith(
        settings: settings,
        showInItem: settings.showInItem,
        showInList: settings.showInList,
        color: Color(settings.color),
        showAlert: settings.showAlert,
      ),
    );
  }

  void onShowInItemChanged() {
    final newShowInItem = !state.showInItem;
    emit(state.copyWith(showInItem: newShowInItem));
    save();
  }

  void onShowInListChanged() {
    final newShowInList = !state.showInList;
    emit(state.copyWith(showInList: newShowInList));
    save();
  }

  void onColorChanged(Color color) {
    emit(state.copyWith(color: color));
    save();
  }

  void onShowAlertChanged(bool value) {
    emit(state.copyWith(showAlert: value));
    save();
  }

  void save() {
    final newSettings = state.settings!.copyWith(
      showInItem: state.showInItem,
      showInList: state.showInList,
      color: state.color!.toARGB32(),
      showAlert: state.showAlert,
    );
    AppSettings.setMinimumQuantitySettings(newSettings);
  }
}
