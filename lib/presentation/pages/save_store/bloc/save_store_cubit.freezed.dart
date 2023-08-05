// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_store_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SaveStoreState {
  BaseState get state => throw _privateConstructorUsedError;
  NameInput get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get exceptionError => throw _privateConstructorUsedError;
  Store? get item => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, NameInput name,
            String description, String exceptionError, Store? item)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, NameInput name, String description,
            String exceptionError, Store? item)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, NameInput name, String description,
            String exceptionError, Store? item)?
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
  $SaveStoreStateCopyWith<SaveStoreState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveStoreStateCopyWith<$Res> {
  factory $SaveStoreStateCopyWith(
          SaveStoreState value, $Res Function(SaveStoreState) then) =
      _$SaveStoreStateCopyWithImpl<$Res, SaveStoreState>;
  @useResult
  $Res call(
      {BaseState state,
      NameInput name,
      String description,
      String exceptionError,
      Store? item});
}

/// @nodoc
class _$SaveStoreStateCopyWithImpl<$Res, $Val extends SaveStoreState>
    implements $SaveStoreStateCopyWith<$Res> {
  _$SaveStoreStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? name = null,
    Object? description = null,
    Object? exceptionError = null,
    Object? item = freezed,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as NameInput,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      exceptionError: null == exceptionError
          ? _value.exceptionError
          : exceptionError // ignore: cast_nullable_to_non_nullable
              as String,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Store?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $SaveStoreStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      NameInput name,
      String description,
      String exceptionError,
      Store? item});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$SaveStoreStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? name = null,
    Object? description = null,
    Object? exceptionError = null,
    Object? item = freezed,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as NameInput,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      exceptionError: null == exceptionError
          ? _value.exceptionError
          : exceptionError // ignore: cast_nullable_to_non_nullable
              as String,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Store?,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.name = const NameInput.pure(),
      this.description = '',
      this.exceptionError = '',
      this.item});

  @override
  final BaseState state;
  @override
  @JsonKey()
  final NameInput name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String exceptionError;
  @override
  final Store? item;

  @override
  String toString() {
    return 'SaveStoreState.initial(state: $state, name: $name, description: $description, exceptionError: $exceptionError, item: $item)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.exceptionError, exceptionError) ||
                other.exceptionError == exceptionError) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, state, name, description, exceptionError, item);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BaseState state, NameInput name,
            String description, String exceptionError, Store? item)
        initial,
  }) {
    return initial(state, name, description, exceptionError, item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, NameInput name, String description,
            String exceptionError, Store? item)?
        initial,
  }) {
    return initial?.call(state, name, description, exceptionError, item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, NameInput name, String description,
            String exceptionError, Store? item)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, name, description, exceptionError, item);
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

abstract class _Initial implements SaveStoreState {
  const factory _Initial(
      {required final BaseState state,
      final NameInput name,
      final String description,
      final String exceptionError,
      final Store? item}) = _$_Initial;

  @override
  BaseState get state;
  @override
  NameInput get name;
  @override
  String get description;
  @override
  String get exceptionError;
  @override
  Store? get item;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
