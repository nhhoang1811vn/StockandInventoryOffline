// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stores_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StoresSetting _$StoresSettingFromJson(Map<String, dynamic> json) {
  return _StoresSetting.fromJson(json);
}

/// @nodoc
mixin _$StoresSetting {
  SortByText get sortByName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoresSettingCopyWith<StoresSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoresSettingCopyWith<$Res> {
  factory $StoresSettingCopyWith(
          StoresSetting value, $Res Function(StoresSetting) then) =
      _$StoresSettingCopyWithImpl<$Res, StoresSetting>;
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class _$StoresSettingCopyWithImpl<$Res, $Val extends StoresSetting>
    implements $StoresSettingCopyWith<$Res> {
  _$StoresSettingCopyWithImpl(this._value, this._then);

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
abstract class _$$_StoresSettingCopyWith<$Res>
    implements $StoresSettingCopyWith<$Res> {
  factory _$$_StoresSettingCopyWith(
          _$_StoresSetting value, $Res Function(_$_StoresSetting) then) =
      __$$_StoresSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class __$$_StoresSettingCopyWithImpl<$Res>
    extends _$StoresSettingCopyWithImpl<$Res, _$_StoresSetting>
    implements _$$_StoresSettingCopyWith<$Res> {
  __$$_StoresSettingCopyWithImpl(
      _$_StoresSetting _value, $Res Function(_$_StoresSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
  }) {
    return _then(_$_StoresSetting(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StoresSetting implements _StoresSetting {
  const _$_StoresSetting({required this.sortByName});

  factory _$_StoresSetting.fromJson(Map<String, dynamic> json) =>
      _$$_StoresSettingFromJson(json);

  @override
  final SortByText sortByName;

  @override
  String toString() {
    return 'StoresSetting(sortByName: $sortByName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoresSetting &&
            (identical(other.sortByName, sortByName) ||
                other.sortByName == sortByName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sortByName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoresSettingCopyWith<_$_StoresSetting> get copyWith =>
      __$$_StoresSettingCopyWithImpl<_$_StoresSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StoresSettingToJson(
      this,
    );
  }
}

abstract class _StoresSetting implements StoresSetting {
  const factory _StoresSetting({required final SortByText sortByName}) =
      _$_StoresSetting;

  factory _StoresSetting.fromJson(Map<String, dynamic> json) =
      _$_StoresSetting.fromJson;

  @override
  SortByText get sortByName;
  @override
  @JsonKey(ignore: true)
  _$$_StoresSettingCopyWith<_$_StoresSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
