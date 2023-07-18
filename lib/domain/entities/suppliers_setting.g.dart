// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suppliers_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SuppliersSetting _$$_SuppliersSettingFromJson(Map<String, dynamic> json) =>
    _$_SuppliersSetting(
      sortByName: $enumDecode(_$SortByTextEnumMap, json['sortByName']),
    );

Map<String, dynamic> _$$_SuppliersSettingToJson(_$_SuppliersSetting instance) =>
    <String, dynamic>{
      'sortByName': _$SortByTextEnumMap[instance.sortByName]!,
    };

const _$SortByTextEnumMap = {
  SortByText.no_sort: 'no_sort',
  SortByText.a_to_z: 'a_to_z',
  SortByText.z_to_a: 'z_to_a',
};
