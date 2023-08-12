// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CustomersSetting _$$_CustomersSettingFromJson(Map<String, dynamic> json) =>
    _$_CustomersSetting(
      sortByName: $enumDecode(_$SortByTextEnumMap, json['sortByName']),
    );

Map<String, dynamic> _$$_CustomersSettingToJson(_$_CustomersSetting instance) =>
    <String, dynamic>{
      'sortByName': _$SortByTextEnumMap[instance.sortByName]!,
    };

const _$SortByTextEnumMap = {
  SortByText.no_sort: 'no_sort',
  SortByText.a_to_z: 'a_to_z',
  SortByText.z_to_a: 'z_to_a',
};
