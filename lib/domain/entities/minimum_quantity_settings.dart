import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimum_quantity_settings.freezed.dart';
part 'minimum_quantity_settings.g.dart';

@freezed
class MinimumQuantitySettings with _$MinimumQuantitySettings {
  factory MinimumQuantitySettings({
    required bool showInItem,
    required bool showInList,
    required int color,
    required bool showAlert
  }) = _MinimumQuantitySettings;

  factory MinimumQuantitySettings.fromJson(Map<String, dynamic> json) =>
      _$MinimumQuantitySettingsFromJson(json);
}