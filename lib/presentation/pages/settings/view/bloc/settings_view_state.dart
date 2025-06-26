part of 'settings_view_cubit.dart';

@freezed
class SettingsViewState with _$SettingsViewState {
  const factory SettingsViewState.initial({
    Color? incomingColor,
    Color? outgoingColor,
    Color? reorderColor
  }) = _Initial;
}