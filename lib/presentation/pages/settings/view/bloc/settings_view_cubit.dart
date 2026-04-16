import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';

part 'settings_view_cubit.freezed.dart';
part 'settings_view_state.dart';

@injectable
class SettingsViewCubit extends Cubit<SettingsViewState> {
  SettingsViewCubit()
      : super(
          SettingsViewState.initial(
            incomingColor: AppSettings.getIncomingDocumentColor(),
            outgoingColor: AppSettings.getOutgoingDocumentColor(),
            reorderColor: Color(AppSettings.getMinimumQuantitySettings().color),
          ),
        );

  void onIncomingColorChanged(Color color) {
    emit(state.copyWith(incomingColor: color));
    AppSettings.setIncomingDocumentColor(color);
  }

  void onOutgoingColorChanged(Color color) {
    emit(state.copyWith(outgoingColor: color));
    AppSettings.setOutgoingDocumentColor(color);
  }

  void onReorderColorChanged(Color color) {
    emit(state.copyWith(reorderColor: color));
    final settings = AppSettings.getMinimumQuantitySettings();
    final newSettings = settings.copyWith(color: color.value);
    AppSettings.setMinimumQuantitySettings(newSettings);
  }
}
