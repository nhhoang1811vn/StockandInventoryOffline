// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ReportDetailState {
  BaseState get state => throw _privateConstructorUsedError;
  ReportType? get type => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;
  List<List<dynamic>> get data => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, ReportType? type,
            DateTime? start, DateTime? end, List<List<dynamic>> data)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, ReportType? type, DateTime? start,
            DateTime? end, List<List<dynamic>> data)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, ReportType? type, DateTime? start,
            DateTime? end, List<List<dynamic>> data)?
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
  $ReportDetailStateCopyWith<ReportDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDetailStateCopyWith<$Res> {
  factory $ReportDetailStateCopyWith(
          ReportDetailState value, $Res Function(ReportDetailState) then) =
      _$ReportDetailStateCopyWithImpl<$Res, ReportDetailState>;
  @useResult
  $Res call(
      {BaseState state,
      ReportType? type,
      DateTime? start,
      DateTime? end,
      List<List<dynamic>> data});
}

/// @nodoc
class _$ReportDetailStateCopyWithImpl<$Res, $Val extends ReportDetailState>
    implements $ReportDetailStateCopyWith<$Res> {
  _$ReportDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? type = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReportType?,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<List<dynamic>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $ReportDetailStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      ReportType? type,
      DateTime? start,
      DateTime? end,
      List<List<dynamic>> data});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$ReportDetailStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? type = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? data = null,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReportType?,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<List<dynamic>>,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.type,
      this.start,
      this.end,
      final List<List<dynamic>> data = const []})
      : _data = data;

  @override
  final BaseState state;
  @override
  final ReportType? type;
  @override
  final DateTime? start;
  @override
  final DateTime? end;
  final List<List<dynamic>> _data;
  @override
  @JsonKey()
  List<List<dynamic>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ReportDetailState.initial(state: $state, type: $type, start: $start, end: $end, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state, type, start, end,
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, ReportType? type,
            DateTime? start, DateTime? end, List<List<dynamic>> data)
        initial,
  }) {
    return initial(state, type, start, end, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, ReportType? type, DateTime? start,
            DateTime? end, List<List<dynamic>> data)?
        initial,
  }) {
    return initial?.call(state, type, start, end, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, ReportType? type, DateTime? start,
            DateTime? end, List<List<dynamic>> data)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, type, start, end, data);
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

abstract class _Initial implements ReportDetailState {
  const factory _Initial(
      {required final BaseState state,
      final ReportType? type,
      final DateTime? start,
      final DateTime? end,
      final List<List<dynamic>> data}) = _$_Initial;

  @override
  BaseState get state;
  @override
  ReportType? get type;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  List<List<dynamic>> get data;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
