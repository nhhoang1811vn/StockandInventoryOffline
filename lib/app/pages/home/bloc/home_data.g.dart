// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomeDataCWProxy {
  HomeData state(BaseState? state);

  HomeData info(GeneralInformation info);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeData(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeData call({
    BaseState? state,
    GeneralInformation? info,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomeData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomeData.copyWith.fieldName(...)`
class _$HomeDataCWProxyImpl implements _$HomeDataCWProxy {
  const _$HomeDataCWProxyImpl(this._value);

  final HomeData _value;

  @override
  HomeData state(BaseState? state) => this(state: state);

  @override
  HomeData info(GeneralInformation info) => this(info: info);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeData(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeData call({
    Object? state = const $CopyWithPlaceholder(),
    Object? info = const $CopyWithPlaceholder(),
  }) {
    return HomeData(
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as BaseState?,
      info: info == const $CopyWithPlaceholder() || info == null
          ? _value.info
          // ignore: cast_nullable_to_non_nullable
          : info as GeneralInformation,
    );
  }
}

extension $HomeDataCopyWith on HomeData {
  /// Returns a callable class that can be used as follows: `instanceOfHomeData.copyWith(...)` or like so:`instanceOfHomeData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomeDataCWProxy get copyWith => _$HomeDataCWProxyImpl(this);
}
