// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_payment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SavePaymentState {
  BaseState get state => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String get exceptionError => throw _privateConstructorUsedError;
  Payment? get item => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            String description,
            DateTime? date,
            double? amount,
            String exceptionError,
            Payment? item)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, String description, DateTime? date,
            double? amount, String exceptionError, Payment? item)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, String description, DateTime? date,
            double? amount, String exceptionError, Payment? item)?
        initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SavePaymentStateCopyWith<SavePaymentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavePaymentStateCopyWith<$Res> {
  factory $SavePaymentStateCopyWith(
          SavePaymentState value, $Res Function(SavePaymentState) then) =
      _$SavePaymentStateCopyWithImpl<$Res, SavePaymentState>;
  @useResult
  $Res call(
      {BaseState state,
      String description,
      DateTime? date,
      double? amount,
      String exceptionError,
      Payment? item});
}

/// @nodoc
class _$SavePaymentStateCopyWithImpl<$Res, $Val extends SavePaymentState>
    implements $SavePaymentStateCopyWith<$Res> {
  _$SavePaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? description = null,
    Object? date = freezed,
    Object? amount = freezed,
    Object? exceptionError = null,
    Object? item = freezed,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      exceptionError: null == exceptionError
          ? _value.exceptionError
          : exceptionError // ignore: cast_nullable_to_non_nullable
              as String,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Payment?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $SavePaymentStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      String description,
      DateTime? date,
      double? amount,
      String exceptionError,
      Payment? item});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$SavePaymentStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? description = null,
    Object? date = freezed,
    Object? amount = freezed,
    Object? exceptionError = null,
    Object? item = freezed,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      exceptionError: null == exceptionError
          ? _value.exceptionError
          : exceptionError // ignore: cast_nullable_to_non_nullable
              as String,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Payment?,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.description = '',
      this.date,
      this.amount,
      this.exceptionError = '',
      this.item});

  @override
  final BaseState state;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? date;
  @override
  final double? amount;
  @override
  @JsonKey()
  final String exceptionError;
  @override
  final Payment? item;

  @override
  String toString() {
    return 'SavePaymentState.initial(state: $state, description: $description, date: $date, amount: $amount, exceptionError: $exceptionError, item: $item)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.exceptionError, exceptionError) ||
                other.exceptionError == exceptionError) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, state, description, date, amount, exceptionError, item);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            String description,
            DateTime? date,
            double? amount,
            String exceptionError,
            Payment? item)
        initial,
  }) {
    return initial(state, description, date, amount, exceptionError, item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, String description, DateTime? date,
            double? amount, String exceptionError, Payment? item)?
        initial,
  }) {
    return initial?.call(
        state, description, date, amount, exceptionError, item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, String description, DateTime? date,
            double? amount, String exceptionError, Payment? item)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, description, date, amount, exceptionError, item);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements SavePaymentState {
  const factory _Initial(
      {required final BaseState state,
      final String description,
      final DateTime? date,
      final double? amount,
      final String exceptionError,
      final Payment? item}) = _$_Initial;

  @override
  BaseState get state;
  @override
  String get description;
  @override
  DateTime? get date;
  @override
  double? get amount;
  @override
  String get exceptionError;
  @override
  Payment? get item;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
