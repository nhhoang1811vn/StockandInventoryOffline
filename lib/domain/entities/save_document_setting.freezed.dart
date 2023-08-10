// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_document_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SaveDocumentSetting _$SaveDocumentSettingFromJson(Map<String, dynamic> json) {
  return _SaveDocumentSetting.fromJson(json);
}

/// @nodoc
mixin _$SaveDocumentSetting {
  SortByText get sortByName => throw _privateConstructorUsedError;
  SortByNumber get sortByBarcode => throw _privateConstructorUsedError;
  SortByNumber get sortByQuantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SaveDocumentSettingCopyWith<SaveDocumentSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveDocumentSettingCopyWith<$Res> {
  factory $SaveDocumentSettingCopyWith(
          SaveDocumentSetting value, $Res Function(SaveDocumentSetting) then) =
      _$SaveDocumentSettingCopyWithImpl<$Res, SaveDocumentSetting>;
  @useResult
  $Res call(
      {SortByText sortByName,
      SortByNumber sortByBarcode,
      SortByNumber sortByQuantity});
}

/// @nodoc
class _$SaveDocumentSettingCopyWithImpl<$Res, $Val extends SaveDocumentSetting>
    implements $SaveDocumentSettingCopyWith<$Res> {
  _$SaveDocumentSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
    Object? sortByBarcode = null,
    Object? sortByQuantity = null,
  }) {
    return _then(_value.copyWith(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
      sortByBarcode: null == sortByBarcode
          ? _value.sortByBarcode
          : sortByBarcode // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
      sortByQuantity: null == sortByQuantity
          ? _value.sortByQuantity
          : sortByQuantity // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SaveDocumentSettingCopyWith<$Res>
    implements $SaveDocumentSettingCopyWith<$Res> {
  factory _$$_SaveDocumentSettingCopyWith(_$_SaveDocumentSetting value,
          $Res Function(_$_SaveDocumentSetting) then) =
      __$$_SaveDocumentSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SortByText sortByName,
      SortByNumber sortByBarcode,
      SortByNumber sortByQuantity});
}

/// @nodoc
class __$$_SaveDocumentSettingCopyWithImpl<$Res>
    extends _$SaveDocumentSettingCopyWithImpl<$Res, _$_SaveDocumentSetting>
    implements _$$_SaveDocumentSettingCopyWith<$Res> {
  __$$_SaveDocumentSettingCopyWithImpl(_$_SaveDocumentSetting _value,
      $Res Function(_$_SaveDocumentSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
    Object? sortByBarcode = null,
    Object? sortByQuantity = null,
  }) {
    return _then(_$_SaveDocumentSetting(
      sortByName: null == sortByName
          ? _value.sortByName
          : sortByName // ignore: cast_nullable_to_non_nullable
              as SortByText,
      sortByBarcode: null == sortByBarcode
          ? _value.sortByBarcode
          : sortByBarcode // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
      sortByQuantity: null == sortByQuantity
          ? _value.sortByQuantity
          : sortByQuantity // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SaveDocumentSetting implements _SaveDocumentSetting {
  _$_SaveDocumentSetting(
      {required this.sortByName,
      required this.sortByBarcode,
      required this.sortByQuantity});

  factory _$_SaveDocumentSetting.fromJson(Map<String, dynamic> json) =>
      _$$_SaveDocumentSettingFromJson(json);

  @override
  final SortByText sortByName;
  @override
  final SortByNumber sortByBarcode;
  @override
  final SortByNumber sortByQuantity;

  @override
  String toString() {
    return 'SaveDocumentSetting(sortByName: $sortByName, sortByBarcode: $sortByBarcode, sortByQuantity: $sortByQuantity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SaveDocumentSetting &&
            (identical(other.sortByName, sortByName) ||
                other.sortByName == sortByName) &&
            (identical(other.sortByBarcode, sortByBarcode) ||
                other.sortByBarcode == sortByBarcode) &&
            (identical(other.sortByQuantity, sortByQuantity) ||
                other.sortByQuantity == sortByQuantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sortByName, sortByBarcode, sortByQuantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SaveDocumentSettingCopyWith<_$_SaveDocumentSetting> get copyWith =>
      __$$_SaveDocumentSettingCopyWithImpl<_$_SaveDocumentSetting>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SaveDocumentSettingToJson(
      this,
    );
  }
}

abstract class _SaveDocumentSetting implements SaveDocumentSetting {
  factory _SaveDocumentSetting(
      {required final SortByText sortByName,
      required final SortByNumber sortByBarcode,
      required final SortByNumber sortByQuantity}) = _$_SaveDocumentSetting;

  factory _SaveDocumentSetting.fromJson(Map<String, dynamic> json) =
      _$_SaveDocumentSetting.fromJson;

  @override
  SortByText get sortByName;
  @override
  SortByNumber get sortByBarcode;
  @override
  SortByNumber get sortByQuantity;
  @override
  @JsonKey(ignore: true)
  _$$_SaveDocumentSettingCopyWith<_$_SaveDocumentSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
