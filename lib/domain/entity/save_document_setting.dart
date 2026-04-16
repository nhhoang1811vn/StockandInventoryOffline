import 'package:freezed_annotation/freezed_annotation.dart';

import 'sort_by_number.dart';
import 'sort_by_text.dart';

part 'save_document_setting.freezed.dart';
part 'save_document_setting.g.dart';

@freezed
class SaveDocumentSetting with _$SaveDocumentSetting {
  factory SaveDocumentSetting({
    required SortByText sortByName,
    required SortByNumber sortByBarcode,
    required SortByNumber sortByQuantity,
  }) = _SaveDocumentSetting;

  factory SaveDocumentSetting.fromJson(Map<String, Object?> json) =>
      _$SaveDocumentSettingFromJson(json);

  factory SaveDocumentSetting.getDefault() => SaveDocumentSetting(
        sortByName: SortByText.no_sort,
        sortByBarcode: SortByNumber.no_sort,
        sortByQuantity: SortByNumber.no_sort,
      );
}
