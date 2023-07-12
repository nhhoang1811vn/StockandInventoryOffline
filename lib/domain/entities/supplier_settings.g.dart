// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SupplierSettings _$$_SupplierSettingsFromJson(Map<String, dynamic> json) =>
    _$_SupplierSettings(
      sortByName: $enumDecode(_$SortByTextEnumMap, json['sortByName']),
    );

Map<String, dynamic> _$$_SupplierSettingsToJson(_$_SupplierSettings instance) =>
    <String, dynamic>{
      'sortByName': _$SortByTextEnumMap[instance.sortByName]!,
    };

const _$SortByTextEnumMap = {
  SortByText.no_sort: 'no_sort',
  SortByText.a_to_z: 'a_to_z',
  SortByText.z_to_a: 'z_to_a',
};
