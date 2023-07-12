// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SupplierSettings _$SupplierSettingsFromJson(Map<String, dynamic> json) {
  return _SupplierSettings.fromJson(json);
}

/// @nodoc
mixin _$SupplierSettings {
  SortByText get sortByName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupplierSettingsCopyWith<SupplierSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierSettingsCopyWith<$Res> {
  factory $SupplierSettingsCopyWith(
          SupplierSettings value, $Res Function(SupplierSettings) then) =
      _$SupplierSettingsCopyWithImpl<$Res, SupplierSettings>;
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class _$SupplierSettingsCopyWithImpl<$Res, $Val extends SupplierSettings>
    implements $SupplierSettingsCopyWith<$Res> {
  _$SupplierSettingsCopyWithImpl(this._value, this._then);

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
abstract class _$$_SupplierSettingsCopyWith<$Res>
    implements $SupplierSettingsCopyWith<$Res> {
  factory _$$_SupplierSettingsCopyWith(
          _$_SupplierSettings value, $Res Function(_$_SupplierSettings) then) =
      __$$_SupplierSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortByText sortByName});
}

/// @nodoc
class __$$_SupplierSettingsCopyWithImpl<$Res>
    extends _$SupplierSettingsCopyWithImpl<$Res, _$_SupplierSettings>
    implements _$$_SupplierSettingsCopyWith<$Res> {
  __$$_SupplierSettingsCopyWithImpl(
      _$_SupplierSettings _value, $Res Function(_$_SupplierSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
  }) {
    return _then(_$_SupplierSettings(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SupplierSettings implements _SupplierSettings {
  const _$_SupplierSettings({required this.sortByName});

  factory _$_SupplierSettings.fromJson(Map<String, dynamic> json) =>
      _$$_SupplierSettingsFromJson(json);

  @override
  final SortByText sortByName;

  @override
  String toString() {
    return 'SupplierSettings(sortByName: $sortByName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SupplierSettings &&
            (identical(other.sortByName, sortByName) ||
                other.sortByName == sortByName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sortByName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SupplierSettingsCopyWith<_$_SupplierSettings> get copyWith =>
      __$$_SupplierSettingsCopyWithImpl<_$_SupplierSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SupplierSettingsToJson(
      this,
    );
  }
}

abstract class _SupplierSettings implements SupplierSettings {
  const factory _SupplierSettings({required final SortByText sortByName}) =
      _$_SupplierSettings;

  factory _SupplierSettings.fromJson(Map<String, dynamic> json) =
      _$_SupplierSettings.fromJson;

  @override
  SortByText get sortByName;
  @override
  @JsonKey(ignore: true)
  _$$_SupplierSettingsCopyWith<_$_SupplierSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
