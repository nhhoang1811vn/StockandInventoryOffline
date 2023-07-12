// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CustomersDataCWProxy {
  CustomersData state(BaseState? state);

  CustomersData items(List<Customer> items);

  CustomersData textSearch(String textSearch);

  CustomersData settings(CustomersSettings settings);

  CustomersData showSearchBar(bool showSearchBar);

  CustomersData isSelection(bool isSelection);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CustomersData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CustomersData(...).copyWith(id: 12, name: "My name")
  /// ````
  CustomersData call({
    BaseState? state,
    List<Customer>? items,
    String? textSearch,
    CustomersSettings? settings,
    bool? showSearchBar,
    bool? isSelection,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCustomersData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCustomersData.copyWith.fieldName(...)`
class _$CustomersDataCWProxyImpl implements _$CustomersDataCWProxy {
  const _$CustomersDataCWProxyImpl(this._value);

  final CustomersData _value;

  @override
  CustomersData state(BaseState? state) => this(state: state);

  @override
  CustomersData items(List<Customer> items) => this(items: items);

  @override
  CustomersData textSearch(String textSearch) => this(textSearch: textSearch);

  @override
  CustomersData settings(CustomersSettings settings) =>
      this(settings: settings);

  @override
  CustomersData showSearchBar(bool showSearchBar) =>
      this(showSearchBar: showSearchBar);

  @override
  CustomersData isSelection(bool isSelection) => this(isSelection: isSelection);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CustomersData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CustomersData(...).copyWith(id: 12, name: "My name")
  /// ````
  CustomersData call({
    Object? state = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? textSearch = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? showSearchBar = const $CopyWithPlaceholder(),
    Object? isSelection = const $CopyWithPlaceholder(),
  }) {
    return CustomersData(
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as BaseState?,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Customer>,
      textSearch:
          textSearch == const $CopyWithPlaceholder() || textSearch == null
              ? _value.textSearch
              // ignore: cast_nullable_to_non_nullable
              : textSearch as String,
      settings: settings == const $CopyWithPlaceholder() || settings == null
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as CustomersSettings,
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

extension $CustomersDataCopyWith on CustomersData {
  /// Returns a callable class that can be used as follows: `instanceOfCustomersData.copyWith(...)` or like so:`instanceOfCustomersData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CustomersDataCWProxy get copyWith => _$CustomersDataCWProxyImpl(this);
}
