// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stores_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StoresSetting _$$_StoresSettingFromJson(Map<String, dynamic> json) =>
    _$_StoresSetting(
      sortByName: $enumDecode(_$SortByTextEnumMap, json['sortByName']),
    );

Map<String, dynamic> _$$_StoresSettingToJson(_$_StoresSetting instance) =>
    <String, dynamic>{
      'sortByName': _$SortByTextEnumMap[instance.sortByName]!,
    };

const _$SortByTextEnumMap = {
  SortByText.no_sort: 'no_sort',
  SortByText.a_to_z: 'a_to_z',
  SortByText.z_to_a: 'z_to_a',
};
