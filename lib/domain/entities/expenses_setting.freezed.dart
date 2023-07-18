// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ExpensesSetting _$ExpensesSettingFromJson(Map<String, dynamic> json) {
  return _ExpensesSetting.fromJson(json);
}

/// @nodoc
mixin _$ExpensesSetting {
  SortByNumber get sortByDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpensesSettingCopyWith<ExpensesSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpensesSettingCopyWith<$Res> {
  factory $ExpensesSettingCopyWith(
          ExpensesSetting value, $Res Function(ExpensesSetting) then) =
      _$ExpensesSettingCopyWithImpl<$Res, ExpensesSetting>;
  @useResult
  $Res call({SortByNumber sortByDate});
}

/// @nodoc
class _$ExpensesSettingCopyWithImpl<$Res, $Val extends ExpensesSetting>
    implements $ExpensesSettingCopyWith<$Res> {
  _$ExpensesSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByDate = null,
  }) {
    return _then(_value.copyWith(
      sortByDate: null == sortByDate
          ? _value.sortByDate
          : sortByDate // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ExpensesSettingCopyWith<$Res>
    implements $ExpensesSettingCopyWith<$Res> {
  factory _$$_ExpensesSettingCopyWith(
          _$_ExpensesSetting value, $Res Function(_$_ExpensesSetting) then) =
      __$$_ExpensesSettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortByNumber sortByDate});
}

/// @nodoc
class __$$_ExpensesSettingCopyWithImpl<$Res>
    extends _$ExpensesSettingCopyWithImpl<$Res, _$_ExpensesSetting>
    implements _$$_ExpensesSettingCopyWith<$Res> {
  __$$_ExpensesSettingCopyWithImpl(
      _$_ExpensesSetting _value, $Res Function(_$_ExpensesSetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortByDate = null,
  }) {
    return _then(_$_ExpensesSetting(
      sortByDate: null == sortByDate
          ? _value.sortByDate
          : sortByDate // ignore: cast_nullable_to_non_nullable
              as SortByNumber,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ExpensesSetting implements _ExpensesSetting {
  _$_ExpensesSetting({required this.sortByDate});

  factory _$_ExpensesSetting.fromJson(Map<String, dynamic> json) =>
      _$$_ExpensesSettingFromJson(json);

  @override
  final SortByNumber sortByDate;

  @override
  String toString() {
    return 'ExpensesSetting(sortByDate: $sortByDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExpensesSetting &&
            (identical(other.sortByDate, sortByDate) ||
                other.sortByDate == sortByDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sortByDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExpensesSettingCopyWith<_$_ExpensesSetting> get copyWith =>
      __$$_ExpensesSettingCopyWithImpl<_$_ExpensesSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ExpensesSettingToJson(
      this,
    );
  }
}

abstract class _ExpensesSetting implements ExpensesSetting {
  factory _ExpensesSetting({required final SortByNumber sortByDate}) =
      _$_ExpensesSetting;

  factory _ExpensesSetting.fromJson(Map<String, dynamic> json) =
      _$_ExpensesSetting.fromJson;

  @override
  SortByNumber get sortByDate;
  @override
  @JsonKey(ignore: true)
  _$$_ExpensesSettingCopyWith<_$_ExpensesSetting> get copyWith =>
      throw _privateConstructorUsedError;
}
