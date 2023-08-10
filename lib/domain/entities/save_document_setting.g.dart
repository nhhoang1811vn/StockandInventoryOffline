// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_document_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SaveDocumentSetting _$$_SaveDocumentSettingFromJson(
        Map<String, dynamic> json) =>
    _$_SaveDocumentSetting(
      sortByName: $enumDecode(_$SortByTextEnumMap, json['sortByName']),
      sortByBarcode: $enumDecode(_$SortByNumberEnumMap, json['sortByBarcode']),
      sortByQuantity:
          $enumDecode(_$SortByNumberEnumMap, json['sortByQuantity']),
    );

Map<String, dynamic> _$$_SaveDocumentSettingToJson(
        _$_SaveDocumentSetting instance) =>
    <String, dynamic>{
      'sortByName': _$SortByTextEnumMap[instance.sortByName]!,
      'sortByBarcode': _$SortByNumberEnumMap[instance.sortByBarcode]!,
      'sortByQuantity': _$SortByNumberEnumMap[instance.sortByQuantity]!,
    };

const _$SortByTextEnumMap = {
  SortByText.no_sort: 'no_sort',
  SortByText.a_to_z: 'a_to_z',
  SortByText.z_to_a: 'z_to_a',
};

const _$SortByNumberEnumMap = {
  SortByNumber.no_sort: 'no_sort',
  SortByNumber.ascending: 'ascending',
  SortByNumber.descending: 'descending',
};
