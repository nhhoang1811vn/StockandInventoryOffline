// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stores_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoresDataCWProxy {
  StoresData state(BaseState? state);

  StoresData items(List<Store> items);

  StoresData textSearch(String textSearch);

  StoresData settings(StoresSettings settings);

  StoresData showSearchBar(bool showSearchBar);

  StoresData isSelection(bool isSelection);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoresData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoresData(...).copyWith(id: 12, name: "My name")
  /// ````
  StoresData call({
    BaseState? state,
    List<Store>? items,
    String? textSearch,
    StoresSettings? settings,
    bool? showSearchBar,
    bool? isSelection,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoresData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoresData.copyWith.fieldName(...)`
class _$StoresDataCWProxyImpl implements _$StoresDataCWProxy {
  const _$StoresDataCWProxyImpl(this._value);

  final StoresData _value;

  @override
  StoresData state(BaseState? state) => this(state: state);

  @override
  StoresData items(List<Store> items) => this(items: items);

  @override
  StoresData textSearch(String textSearch) => this(textSearch: textSearch);

  @override
  StoresData settings(StoresSettings settings) => this(settings: settings);

  @override
  StoresData showSearchBar(bool showSearchBar) =>
      this(showSearchBar: showSearchBar);

  @override
  StoresData isSelection(bool isSelection) => this(isSelection: isSelection);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoresData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoresData(...).copyWith(id: 12, name: "My name")
  /// ````
  StoresData call({
    Object? state = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? textSearch = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? showSearchBar = const $CopyWithPlaceholder(),
    Object? isSelection = const $CopyWithPlaceholder(),
  }) {
    return StoresData(
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as BaseState?,
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<Store>,
      textSearch:
          textSearch == const $CopyWithPlaceholder() || textSearch == null
              ? _value.textSearch
              // ignore: cast_nullable_to_non_nullable
              : textSearch as String,
      settings: settings == const $CopyWithPlaceholder() || settings == null
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as StoresSettings,
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

extension $StoresDataCopyWith on StoresData {
  /// Returns a callable class that can be used as follows: `instanceOfStoresData.copyWith(...)` or like so:`instanceOfStoresData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoresDataCWProxy get copyWith => _$StoresDataCWProxyImpl(this);
}
