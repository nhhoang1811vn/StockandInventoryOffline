// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customers_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CustomersSetting _$CustomersSettingFromJson(Map<String, dynamic> json) {
  return _CustomersSetting.fromJson(json);
}

/// @nodoc
mixin _$CustomersSetting {
  SortByText get sortByName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomersSettingCopyWith<CustomersSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomersSettingCopyWith<$Res> {
  factory $CustomersSettingCopyWith(
          CustomersSetting value, $Res Function(CustomersSetting) then) =
      _$CustomersSettingCopyWithImpl<$Res, CustomersSetting>;
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class _$CustomersSettingCopyWithImpl<$Res, $Val extends CustomersSetting>
    implements $CustomersSettingCopyWith<$Res> {
  _$CustomersSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
  }) {
    return _then(_value.copyWith(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CustomersSettingCopyWith<$Res>
    implements $CustomersSettingCopyWith<$Res> {
  factory _$$_CustomersSettingCopyWith(
          _$_CustomersSetting value, $Res Function(_$_CustomersSetting) then) =
      __$$_CustomersSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class __$$_CustomersSettingCopyWithImpl<$Res>
    extends _$CustomersSettingCopyWithImpl<$Res, _$_CustomersSetting>
    implements _$$_CustomersSettingCopyWith<$Res> {
  __$$_CustomersSettingCopyWithImpl(
      _$_CustomersSetting _value, $Res Function(_$_CustomersSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
  }) {
    return _then(_$_CustomersSetting(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CustomersSetting implements _CustomersSetting {
  const _$_CustomersSetting({required this.sortByName});

  factory _$_CustomersSetting.fromJson(Map<String, dynamic> json) =>
      _$$_CustomersSettingFromJson(json);

  @override
  final SortByText sortByName;

  @override
  String toString() {
    return 'CustomersSetting(sortByName: $sortByName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CustomersSetting &&
            (identical(other.sortByName, sortByName) ||
                other.sortByName == sortByName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sortByName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CustomersSettingCopyWith<_$_CustomersSetting> get copyWith =>
      __$$_CustomersSettingCopyWithImpl<_$_CustomersSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CustomersSettingToJson(
      this,
    );
  }
}

abstract class _CustomersSetting implements CustomersSetting {
  const factory _CustomersSetting({required final SortByText sortByName}) =
      _$_CustomersSetting;

  factory _CustomersSetting.fromJson(Map<String, dynamic> json) =
      _$_CustomersSetting.fromJson;

  @override
  SortByText get sortByName;
  @override
  @JsonKey(ignore: true)
  _$$_CustomersSettingCopyWith<_$_CustomersSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
