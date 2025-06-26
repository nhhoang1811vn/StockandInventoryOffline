import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:injectable/injectable.dart';

part 'settings_view_cubit.freezed.dart';
part 'settings_view_state.dart';

@injectable
class SettingsViewCubit extends Cubit<SettingsViewState> {
  final AppSettings appSettings;

  SettingsViewCubit({required this.appSettings})
      : super(SettingsViewState.initial(
    incomingColor: appSettings.getIncomingDocumentColor(),
    outgoingColor: appSettings.getOutgoingDocumentColor(),
    reorderColor: Color(appSettings.getMinimumQuantitySettings().color)
  ));

  void onIncomingColorChanged(Color color){
    emit(state.copyWith(incomingColor: color));
    appSettings.setIncomingDocumentColor(color);
  }
  void onOutgoingColorChanged(Color color){
    emit(state.copyWith(outgoingColor: color));
    appSettings.setOutgoingDocumentColor(color);
  }
  void onReorderColorChanged(Color color){
    emit(state.copyWith(reorderColor: color));
    final settings = appSettings.getMinimumQuantitySettings();
    final newSettings = settings.copyWith(
      color: color.value
    );
    appSettings.setMinimumQuantitySettings(newSettings);
  }
}
