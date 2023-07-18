// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExpensesSetting _$$_ExpensesSettingFromJson(Map<String, dynamic> json) =>
    _$_ExpensesSetting(
      sortByDate: $enumDecode(_$SortByNumberEnumMap, json['sortByDate']),
    );

Map<String, dynamic> _$$_ExpensesSettingToJson(_$_ExpensesSetting instance) =>
    <String, dynamic>{
      'sortByDate': _$SortByNumberEnumMap[instance.sortByDate]!,
    };

const _$SortByNumberEnumMap = {
  SortByNumber.no_sort: 'no_sort',
  SortByNumber.ascending: 'ascending',
  SortByNumber.descending: 'descending',
};
