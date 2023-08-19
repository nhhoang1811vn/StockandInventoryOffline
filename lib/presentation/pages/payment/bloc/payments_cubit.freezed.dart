// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PaymentsState {
  BaseState get state => throw _privateConstructorUsedError;
  int? get documentId => throw _privateConstructorUsedError;
  double get invoiced => throw _privateConstructorUsedError;
  double get paid => throw _privateConstructorUsedError;
  List<Payment> get items => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, int? documentId, double invoiced,
            double paid, List<Payment> items)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, int? documentId, double invoiced,
            double paid, List<Payment> items)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, int? documentId, double invoiced,
            double paid, List<Payment> items)?
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
  $PaymentsStateCopyWith<PaymentsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentsStateCopyWith<$Res> {
  factory $PaymentsStateCopyWith(
          PaymentsState value, $Res Function(PaymentsState) then) =
      _$PaymentsStateCopyWithImpl<$Res, PaymentsState>;
  @useResult
  $Res call(
      {BaseState state,
      int? documentId,
      double invoiced,
      double paid,
      List<Payment> items});
}

/// @nodoc
class _$PaymentsStateCopyWithImpl<$Res, $Val extends PaymentsState>
    implements $PaymentsStateCopyWith<$Res> {
  _$PaymentsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? documentId = freezed,
    Object? invoiced = null,
    Object? paid = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      documentId: freezed == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiced: null == invoiced
          ? _value.invoiced
          : invoiced // ignore: cast_nullable_to_non_nullable
              as double,
      paid: null == paid
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as double,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Payment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $PaymentsStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      int? documentId,
      double invoiced,
      double paid,
      List<Payment> items});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$PaymentsStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? documentId = freezed,
    Object? invoiced = null,
    Object? paid = null,
    Object? items = null,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      documentId: freezed == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiced: null == invoiced
          ? _value.invoiced
          : invoiced // ignore: cast_nullable_to_non_nullable
              as double,
      paid: null == paid
          ? _value.paid
          : paid // ignore: cast_nullable_to_non_nullable
              as double,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Payment>,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.documentId,
      this.invoiced = 0.0,
      this.paid = 0.0,
      final List<Payment> items = const []})
      : _items = items;

  @override
  final BaseState state;
  @override
  final int? documentId;
  @override
  @JsonKey()
  final double invoiced;
  @override
  @JsonKey()
  final double paid;
  final List<Payment> _items;
  @override
  @JsonKey()
  List<Payment> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaymentsState.initial(state: $state, documentId: $documentId, invoiced: $invoiced, paid: $paid, items: $items)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.invoiced, invoiced) ||
                other.invoiced == invoiced) &&
            (identical(other.paid, paid) || other.paid == paid) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state, documentId, invoiced,
      paid, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, int? documentId, double invoiced,
            double paid, List<Payment> items)
        initial,
  }) {
    return initial(state, documentId, invoiced, paid, items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, int? documentId, double invoiced,
            double paid, List<Payment> items)?
        initial,
  }) {
    return initial?.call(state, documentId, invoiced, paid, items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, int? documentId, double invoiced,
            double paid, List<Payment> items)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, documentId, invoiced, paid, items);
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

abstract class _Initial implements PaymentsState {
  const factory _Initial(
      {required final BaseState state,
      final int? documentId,
      final double invoiced,
      final double paid,
      final List<Payment> items}) = _$_Initial;

  @override
  BaseState get state;
  @override
  int? get documentId;
  @override
  double get invoiced;
  @override
  double get paid;
  @override
  List<Payment> get items;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
