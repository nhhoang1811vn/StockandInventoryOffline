// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DocumentsSetting _$DocumentsSettingFromJson(Map<String, dynamic> json) {
  return _DocumentsSetting.fromJson(json);
}

/// @nodoc
mixin _$DocumentsSetting {
  SortByNumber get sortByDate => throw _privateConstructorUsedError;
  SearchDocumentsType get searchDocumentsType =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentsSettingCopyWith<DocumentsSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentsSettingCopyWith<$Res> {
  factory $DocumentsSettingCopyWith(
          DocumentsSetting value, $Res Function(DocumentsSetting) then) =
      _$DocumentsSettingCopyWithImpl<$Res, DocumentsSetting>;
  @useResult
  $Res call({SortByNumber sortByDate, SearchDocumentsType searchDocumentsType});
}

/// @nodoc
class _$DocumentsSettingCopyWithImpl<$Res, $Val extends DocumentsSetting>
    implements $DocumentsSettingCopyWith<$Res> {
  _$DocumentsSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByDate = null,
    Object? searchDocumentsType = null,
  }) {
    return _then(_value.copyWith(
      sortByDate: null == sortByDate
          ? _value.sortByDate
          : sortByDate // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
      searchDocumentsType: null == searchDocumentsType
          ? _value.searchDocumentsType
          : searchDocumentsType // ignore: cast_nullable_to_non_nullable
              as SearchDocumentsType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DocumentsSettingCopyWith<$Res>
    implements $DocumentsSettingCopyWith<$Res> {
  factory _$$_DocumentsSettingCopyWith(
          _$_DocumentsSetting value, $Res Function(_$_DocumentsSetting) then) =
      __$$_DocumentsSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortByNumber sortByDate, SearchDocumentsType searchDocumentsType});
}

/// @nodoc
class __$$_DocumentsSettingCopyWithImpl<$Res>
    extends _$DocumentsSettingCopyWithImpl<$Res, _$_DocumentsSetting>
    implements _$$_DocumentsSettingCopyWith<$Res> {
  __$$_DocumentsSettingCopyWithImpl(
      _$_DocumentsSetting _value, $Res Function(_$_DocumentsSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByDate = null,
    Object? searchDocumentsType = null,
  }) {
    return _then(_$_DocumentsSetting(
      sortByDate: null == sortByDate
          ? _value.sortByDate
          : sortByDate // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
      searchDocumentsType: null == searchDocumentsType
          ? _value.searchDocumentsType
          : searchDocumentsType // ignore: cast_nullable_to_non_nullable
              as SearchDocumentsType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DocumentsSetting implements _DocumentsSetting {
  _$_DocumentsSetting(
      {required this.sortByDate, required this.searchDocumentsType});

  factory _$_DocumentsSetting.fromJson(Map<String, dynamic> json) =>
      _$$_DocumentsSettingFromJson(json);

  @override
  final SortByNumber sortByDate;
  @override
  final SearchDocumentsType searchDocumentsType;

  @override
  String toString() {
    return 'DocumentsSetting(sortByDate: $sortByDate, searchDocumentsType: $searchDocumentsType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DocumentsSetting &&
            (identical(other.sortByDate, sortByDate) ||
                other.sortByDate == sortByDate) &&
            (identical(other.searchDocumentsType, searchDocumentsType) ||
                other.searchDocumentsType == searchDocumentsType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sortByDate, searchDocumentsType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DocumentsSettingCopyWith<_$_DocumentsSetting> get copyWith =>
      __$$_DocumentsSettingCopyWithImpl<_$_DocumentsSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DocumentsSettingToJson(
      this,
    );
  }
}

abstract class _DocumentsSetting implements DocumentsSetting {
  factory _DocumentsSetting(
          {required final SortByNumber sortByDate,
          required final SearchDocumentsType searchDocumentsType}) =
      _$_DocumentsSetting;

  factory _DocumentsSetting.fromJson(Map<String, dynamic> json) =
      _$_DocumentsSetting.fromJson;

  @override
  SortByNumber get sortByDate;
  @override
  SearchDocumentsType get searchDocumentsType;
  @override
  @JsonKey(ignore: true)
  _$$_DocumentsSettingCopyWith<_$_DocumentsSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
