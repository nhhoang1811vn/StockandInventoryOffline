// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_history_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ItemHistoryState {
  BaseState get state => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  int? get goodId => throw _privateConstructorUsedError;
  List<GoodHistory> get items => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, DateTime? start, DateTime? end,
            int? goodId, List<GoodHistory> items)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, DateTime? start, DateTime? end,
            int? goodId, List<GoodHistory> items)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, DateTime? start, DateTime? end,
            int? goodId, List<GoodHistory> items)?
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
  $ItemHistoryStateCopyWith<ItemHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemHistoryStateCopyWith<$Res> {
  factory $ItemHistoryStateCopyWith(
          ItemHistoryState value, $Res Function(ItemHistoryState) then) =
      _$ItemHistoryStateCopyWithImpl<$Res, ItemHistoryState>;
  @useResult
  $Res call(
      {BaseState state,
      DateTime? start,
      DateTime? end,
      int? goodId,
      List<GoodHistory> items});
}

/// @nodoc
class _$ItemHistoryStateCopyWithImpl<$Res, $Val extends ItemHistoryState>
    implements $ItemHistoryStateCopyWith<$Res> {
  _$ItemHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? goodId = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      goodId: freezed == goodId
          ? _value.goodId
          : goodId // ignore: cast_nullable_to_non_nullable
              as int?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GoodHistory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $ItemHistoryStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      DateTime? start,
      DateTime? end,
      int? goodId,
      List<GoodHistory> items});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$ItemHistoryStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? start = freezed,
    Object? end = freezed,
    Object? goodId = freezed,
    Object? items = null,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      goodId: freezed == goodId
          ? _value.goodId
          : goodId // ignore: cast_nullable_to_non_nullable
              as int?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GoodHistory>,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.start,
      this.end,
      this.goodId,
      final List<GoodHistory> items = const []})
      : _items = items;

  @override
  final BaseState state;
  @override
  final DateTime? start;
  @override
  final DateTime? end;
  @override
  final int? goodId;
  final List<GoodHistory> _items;
  @override
  @JsonKey()
  List<GoodHistory> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ItemHistoryState.initial(state: $state, start: $start, end: $end, goodId: $goodId, items: $items)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.goodId, goodId) || other.goodId == goodId) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state, start, end, goodId,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, DateTime? start, DateTime? end,
            int? goodId, List<GoodHistory> items)
        initial,
  }) {
    return initial(state, start, end, goodId, items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, DateTime? start, DateTime? end,
            int? goodId, List<GoodHistory> items)?
        initial,
  }) {
    return initial?.call(state, start, end, goodId, items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, DateTime? start, DateTime? end,
            int? goodId, List<GoodHistory> items)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, start, end, goodId, items);
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

abstract class _Initial implements ItemHistoryState {
  const factory _Initial(
      {required final BaseState state,
      final DateTime? start,
      final DateTime? end,
      final int? goodId,
      final List<GoodHistory> items}) = _$_Initial;

  @override
  BaseState get state;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  int? get goodId;
  @override
  List<GoodHistory> get items;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
