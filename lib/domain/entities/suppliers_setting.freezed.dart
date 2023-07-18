// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suppliers_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SuppliersSetting _$SuppliersSettingFromJson(Map<String, dynamic> json) {
  return _SuppliersSetting.fromJson(json);
}

/// @nodoc
mixin _$SuppliersSetting {
  SortByText get sortByName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuppliersSettingCopyWith<SuppliersSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuppliersSettingCopyWith<$Res> {
  factory $SuppliersSettingCopyWith(
          SuppliersSetting value, $Res Function(SuppliersSetting) then) =
      _$SuppliersSettingCopyWithImpl<$Res, SuppliersSetting>;
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class _$SuppliersSettingCopyWithImpl<$Res, $Val extends SuppliersSetting>
    implements $SuppliersSettingCopyWith<$Res> {
  _$SuppliersSettingCopyWithImpl(this._value, this._then);

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
abstract class _$$_SuppliersSettingCopyWith<$Res>
    implements $SuppliersSettingCopyWith<$Res> {
  factory _$$_SuppliersSettingCopyWith(
          _$_SuppliersSetting value, $Res Function(_$_SuppliersSetting) then) =
      __$$_SuppliersSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class __$$_SuppliersSettingCopyWithImpl<$Res>
    extends _$SuppliersSettingCopyWithImpl<$Res, _$_SuppliersSetting>
    implements _$$_SuppliersSettingCopyWith<$Res> {
  __$$_SuppliersSettingCopyWithImpl(
      _$_SuppliersSetting _value, $Res Function(_$_SuppliersSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
  }) {
    return _then(_$_SuppliersSetting(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SuppliersSetting implements _SuppliersSetting {
  const _$_SuppliersSetting({required this.sortByName});

  factory _$_SuppliersSetting.fromJson(Map<String, dynamic> json) =>
      _$$_SuppliersSettingFromJson(json);

  @override
  final SortByText sortByName;

  @override
  String toString() {
    return 'SuppliersSetting(sortByName: $sortByName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SuppliersSetting &&
            (identical(other.sortByName, sortByName) ||
                other.sortByName == sortByName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sortByName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SuppliersSettingCopyWith<_$_SuppliersSetting> get copyWith =>
      __$$_SuppliersSettingCopyWithImpl<_$_SuppliersSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SuppliersSettingToJson(
      this,
    );
  }
}

abstract class _SuppliersSetting implements SuppliersSetting {
  const factory _SuppliersSetting({required final SortByText sortByName}) =
      _$_SuppliersSetting;

  factory _SuppliersSetting.fromJson(Map<String, dynamic> json) =
      _$_SuppliersSetting.fromJson;

  @override
  SortByText get sortByName;
  @override
  @JsonKey(ignore: true)
  _$$_SuppliersSettingCopyWith<_$_SuppliersSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
