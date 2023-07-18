// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DocumentsSetting _$$_DocumentsSettingFromJson(Map<String, dynamic> json) =>
    _$_DocumentsSetting(
      sortByDate: $enumDecode(_$SortByNumberEnumMap, json['sortByDate']),
      searchDocumentsType: $enumDecode(
          _$SearchDocumentsTypeEnumMap, json['searchDocumentsType']),
    );

Map<String, dynamic> _$$_DocumentsSettingToJson(_$_DocumentsSetting instance) =>
    <String, dynamic>{
      'sortByDate': _$SortByNumberEnumMap[instance.sortByDate]!,
      'searchDocumentsType':
          _$SearchDocumentsTypeEnumMap[instance.searchDocumentsType]!,
    };

const _$SortByNumberEnumMap = {
  SortByNumber.no_sort: 'no_sort',
  SortByNumber.ascending: 'ascending',
  SortByNumber.descending: 'descending',
};

const _$SearchDocumentsTypeEnumMap = {
  SearchDocumentsType.byName: 'byName',
  SearchDocumentsType.byDescription: 'byDescription',
  SearchDocumentsType.byCustomerSupplier: 'byCustomerSupplier',
};
