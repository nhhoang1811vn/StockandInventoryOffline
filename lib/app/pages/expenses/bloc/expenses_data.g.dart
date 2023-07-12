// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ExpensesDataCWProxy {
  ExpensesData state(BaseState? state);

  ExpensesData items(List<Expense> items);

  ExpensesData textSearch(String textSearch);

  ExpensesData settings(ExpensesSettings settings);

  ExpensesData showSearchBar(bool showSearchBar);

  ExpensesData isSelection(bool isSelection);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ExpensesData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ExpensesData(...).copyWith(id: 12, name: "My name")
  /// ````
  ExpensesData call({
    BaseState? state,
    List<Expense>? items,
    String? textSearch,
    ExpensesSettings? settings,
    bool? showSearchBar,
    bool? isSelection,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfExpensesData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfExpensesData.copyWith.fieldName(...)`
class _$ExpensesDataCWProxyImpl implements _$ExpensesDataCWProxy {
  const _$ExpensesDataCWProxyImpl(this._value);

  final ExpensesData _value;

  @override
  ExpensesData state(BaseState? state) => this(state: state);

  @override
  ExpensesData items(List<Expense> items) => this(items: items);

  @override
  ExpensesData textSearch(String textSearch) => this(textSearch: textSearch);

  @override
  ExpensesData settings(ExpensesSettings settings) => this(settings: settings);

  @override
  ExpensesData showSearchBar(bool showSearchBar) =>
      this(showSearchBar: showSearchBar);

  @override
  ExpensesData isSelection(bool isSelection) => this(isSelection: isSelection);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ExpensesData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ExpensesData(...).copyWith(id: 12, name: "My name")
  /// ````
  ExpensesData call({
    Object? state = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? textSearch = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? showSearchBar = const $CopyWithPlaceholder(),
    Object? isSelection = const $CopyWithPlaceholder(),
  }) {
    return ExpensesData(
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as BaseState?,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Expense>,
      textSearch:
          textSearch == const $CopyWithPlaceholder() || textSearch == null
              ? _value.textSearch
              // ignore: cast_nullable_to_non_nullable
              : textSearch as String,
      settings: settings == const $CopyWithPlaceholder() || settings == null
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as ExpensesSettings,
      showSearchBar:
          showSearchBar == const $CopyWithPlaceholder() || showSearchBar == null
              ? _value.showSearchBar
              // ignore: cast_nullable_to_non_nullable
              : showSearchBar as bool,
      isSelection:
          isSelection == const $CopyWithPlaceholder() || isSelection == null
              ? _value.isSelection
              // ignore: cast_nullable_to_non_nullable
              : isSelection as bool,
    );
  }
}

extension $ExpensesDataCopyWith on ExpensesData {
  /// Returns a callable class that can be used as follows: `instanceOfExpensesData.copyWith(...)` or like so:`instanceOfExpensesData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ExpensesDataCWProxy get copyWith => _$ExpensesDataCWProxyImpl(this);
}
