// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_scanner_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BarcodeScannerState {
  BatchModeScan get batchModeScan => throw _privateConstructorUsedError;
  bool get enableBeep => throw _privateConstructorUsedError;
  bool get enableVibrate => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate)?
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
  $BarcodeScannerStateCopyWith<BarcodeScannerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeScannerStateCopyWith<$Res> {
  factory $BarcodeScannerStateCopyWith(
          BarcodeScannerState value, $Res Function(BarcodeScannerState) then) =
      _$BarcodeScannerStateCopyWithImpl<$Res, BarcodeScannerState>;
  @useResult
  $Res call({BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate});
}

/// @nodoc
class _$BarcodeScannerStateCopyWithImpl<$Res, $Val extends BarcodeScannerState>
    implements $BarcodeScannerStateCopyWith<$Res> {
  _$BarcodeScannerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchModeScan = null,
    Object? enableBeep = null,
    Object? enableVibrate = null,
  }) {
    return _then(_value.copyWith(
      batchModeScan: null == batchModeScan
          ? _value.batchModeScan
          : batchModeScan // ignore: cast_nullable_to_non_nullable
              as BatchModeScan,
      enableBeep: null == enableBeep
          ? _value.enableBeep
          : enableBeep // ignore: cast_nullable_to_non_nullable
              as bool,
      enableVibrate: null == enableVibrate
          ? _value.enableVibrate
          : enableVibrate // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $BarcodeScannerStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$BarcodeScannerStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? batchModeScan = null,
    Object? enableBeep = null,
    Object? enableVibrate = null,
  }) {
    return _then(_$_Initial(
      batchModeScan: null == batchModeScan
          ? _value.batchModeScan
          : batchModeScan // ignore: cast_nullable_to_non_nullable
              as BatchModeScan,
      enableBeep: null == enableBeep
          ? _value.enableBeep
          : enableBeep // ignore: cast_nullable_to_non_nullable
              as bool,
      enableVibrate: null == enableVibrate
          ? _value.enableVibrate
          : enableVibrate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.batchModeScan,
      required this.enableBeep,
      required this.enableVibrate});

  @override
  final BatchModeScan batchModeScan;
  @override
  final bool enableBeep;
  @override
  final bool enableVibrate;

  @override
  String toString() {
    return 'BarcodeScannerState.initial(batchModeScan: $batchModeScan, enableBeep: $enableBeep, enableVibrate: $enableVibrate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.batchModeScan, batchModeScan) ||
                other.batchModeScan == batchModeScan) &&
            (identical(other.enableBeep, enableBeep) ||
                other.enableBeep == enableBeep) &&
            (identical(other.enableVibrate, enableVibrate) ||
                other.enableVibrate == enableVibrate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, batchModeScan, enableBeep, enableVibrate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate)
        initial,
  }) {
    return initial(batchModeScan, enableBeep, enableVibrate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate)?
        initial,
  }) {
    return initial?.call(batchModeScan, enableBeep, enableVibrate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BatchModeScan batchModeScan, bool enableBeep, bool enableVibrate)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(batchModeScan, enableBeep, enableVibrate);
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

abstract class _Initial implements BarcodeScannerState {
  const factory _Initial(
      {required final BatchModeScan batchModeScan,
      required final bool enableBeep,
      required final bool enableVibrate}) = _$_Initial;

  @override
  BatchModeScan get batchModeScan;
  @override
  bool get enableBeep;
  @override
  bool get enableVibrate;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
