import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';

part 'documents_setting.freezed.dart';
part 'documents_setting.g.dart';

@freezed
class DocumentsSetting with _$DocumentsSetting {
  factory DocumentsSetting({
    required bool? isPaid
  }) = _DocumentsSetting;

  factory DocumentsSetting.fromJson(Map<String, Object?> json) => _$DocumentsSettingFromJson(json);
  factory DocumentsSetting.getDefault() => DocumentsSetting(
      isPaid: null);

}
