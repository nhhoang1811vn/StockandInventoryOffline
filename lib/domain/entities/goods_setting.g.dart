// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GoodsSetting _$$_GoodsSettingFromJson(Map<String, dynamic> json) =>
    _$_GoodsSetting(
      sortByName: $enumDecode(_$SortByTextEnumMap, json['sortByName']),
      sortByBarcode: $enumDecode(_$SortByNumberEnumMap, json['sortByBarcode']),
      sortByQuantity:
          $enumDecode(_$SortByNumberEnumMap, json['sortByQuantity']),
      searchGoodsType:
          $enumDecode(_$SearchGoodsTypeEnumMap, json['searchGoodsType']),
    );

Map<String, dynamic> _$$_GoodsSettingToJson(_$_GoodsSetting instance) =>
    <String, dynamic>{
      'sortByName': _$SortByTextEnumMap[instance.sortByName]!,
      'sortByBarcode': _$SortByNumberEnumMap[instance.sortByBarcode]!,
      'sortByQuantity': _$SortByNumberEnumMap[instance.sortByQuantity]!,
      'searchGoodsType': _$SearchGoodsTypeEnumMap[instance.searchGoodsType]!,
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

const _$SearchGoodsTypeEnumMap = {
  SearchGoodsType.byName: 'byName',
  SearchGoodsType.byDescription: 'byDescription',
  SearchGoodsType.byBarcode: 'byBarcode',
  SearchGoodsType.everywhere: 'everywhere',
};
