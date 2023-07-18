// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GoodsSetting _$GoodsSettingFromJson(Map<String, dynamic> json) {
  return _GoodsSetting.fromJson(json);
}

/// @nodoc
mixin _$GoodsSetting {
  SortByText get sortByName => throw _privateConstructorUsedError;
  SortByNumber get sortByBarcode => throw _privateConstructorUsedError;
  SortByNumber get sortByQuantity => throw _privateConstructorUsedError;
  SearchGoodsType get searchGoodsType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsSettingCopyWith<GoodsSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsSettingCopyWith<$Res> {
  factory $GoodsSettingCopyWith(
          GoodsSetting value, $Res Function(GoodsSetting) then) =
      _$GoodsSettingCopyWithImpl<$Res, GoodsSetting>;
  @useResult
  $Res call(
      {SortByText sortByName,
      SortByNumber sortByBarcode,
      SortByNumber sortByQuantity,
      SearchGoodsType searchGoodsType});
}

/// @nodoc
class _$GoodsSettingCopyWithImpl<$Res, $Val extends GoodsSetting>
    implements $GoodsSettingCopyWith<$Res> {
  _$GoodsSettingCopyWithImpl(this._value, this._then);

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
    Object? searchGoodsType = null,
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
      searchGoodsType: null == searchGoodsType
          ? _value.searchGoodsType
          : searchGoodsType // ignore: cast_nullable_to_non_nullable
              as SearchGoodsType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GoodsSettingCopyWith<$Res>
    implements $GoodsSettingCopyWith<$Res> {
  factory _$$_GoodsSettingCopyWith(
          _$_GoodsSetting value, $Res Function(_$_GoodsSetting) then) =
      __$$_GoodsSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SortByText sortByName,
      SortByNumber sortByBarcode,
      SortByNumber sortByQuantity,
      SearchGoodsType searchGoodsType});
}

/// @nodoc
class __$$_GoodsSettingCopyWithImpl<$Res>
    extends _$GoodsSettingCopyWithImpl<$Res, _$_GoodsSetting>
    implements _$$_GoodsSettingCopyWith<$Res> {
  __$$_GoodsSettingCopyWithImpl(
      _$_GoodsSetting _value, $Res Function(_$_GoodsSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByName = null,
    Object? sortByBarcode = null,
    Object? sortByQuantity = null,
    Object? searchGoodsType = null,
  }) {
    return _then(_$_GoodsSetting(
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
      searchGoodsType: null == searchGoodsType
          ? _value.searchGoodsType
          : searchGoodsType // ignore: cast_nullable_to_non_nullable
              as SearchGoodsType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GoodsSetting implements _GoodsSetting {
  _$_GoodsSetting(
      {required this.sortByName,
      required this.sortByBarcode,
      required this.sortByQuantity,
      required this.searchGoodsType});

  factory _$_GoodsSetting.fromJson(Map<String, dynamic> json) =>
      _$$_GoodsSettingFromJson(json);

  @override
  final SortByText sortByName;
  @override
  final SortByNumber sortByBarcode;
  @override
  final SortByNumber sortByQuantity;
  @override
  final SearchGoodsType searchGoodsType;

  @override
  String toString() {
    return 'GoodsSetting(sortByName: $sortByName, sortByBarcode: $sortByBarcode, sortByQuantity: $sortByQuantity, searchGoodsType: $searchGoodsType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GoodsSetting &&
            (identical(other.sortByName, sortByName) ||
                other.sortByName == sortByName) &&
            (identical(other.sortByBarcode, sortByBarcode) ||
                other.sortByBarcode == sortByBarcode) &&
            (identical(other.sortByQuantity, sortByQuantity) ||
                other.sortByQuantity == sortByQuantity) &&
            (identical(other.searchGoodsType, searchGoodsType) ||
                other.searchGoodsType == searchGoodsType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, sortByName, sortByBarcode, sortByQuantity, searchGoodsType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GoodsSettingCopyWith<_$_GoodsSetting> get copyWith =>
      __$$_GoodsSettingCopyWithImpl<_$_GoodsSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GoodsSettingToJson(
      this,
    );
  }
}

abstract class _GoodsSetting implements GoodsSetting {
  factory _GoodsSetting(
      {required final SortByText sortByName,
      required final SortByNumber sortByBarcode,
      required final SortByNumber sortByQuantity,
      required final SearchGoodsType searchGoodsType}) = _$_GoodsSetting;

  factory _GoodsSetting.fromJson(Map<String, dynamic> json) =
      _$_GoodsSetting.fromJson;

  @override
  SortByText get sortByName;
  @override
  SortByNumber get sortByBarcode;
  @override
  SortByNumber get sortByQuantity;
  @override
  SearchGoodsType get searchGoodsType;
  @override
  @JsonKey(ignore: true)
  _$$_GoodsSettingCopyWith<_$_GoodsSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
