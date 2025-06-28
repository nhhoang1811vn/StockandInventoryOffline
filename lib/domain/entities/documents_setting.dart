import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_paid_status.dart';

part 'documents_setting.freezed.dart';
part 'documents_setting.g.dart';

@freezed
class DocumentsSetting with _$DocumentsSetting {
  factory DocumentsSetting({
    required bool sortByDateNewestFirst,
    required Set<DocumentPaidStatus> selectedStatus
  }) = _DocumentsSetting;

  factory DocumentsSetting.fromJson(Map<String, Object?> json) => _$DocumentsSettingFromJson(json);
  factory DocumentsSetting.getDefault() => DocumentsSetting(
      sortByDateNewestFirst : true,
      selectedStatus: {});

}
