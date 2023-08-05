// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_good_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SaveGoodState {
  BaseState get state => throw _privateConstructorUsedError;
  NameInput get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get barCode => throw _privateConstructorUsedError;
  List<String> get files => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  Good? get item => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            NameInput name,
            String description,
            String barCode,
            List<String> files,
            int quantity,
            Good? item)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, NameInput name, String description,
            String barCode, List<String> files, int quantity, Good? item)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, NameInput name, String description,
            String barCode, List<String> files, int quantity, Good? item)?
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
  $SaveGoodStateCopyWith<SaveGoodState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveGoodStateCopyWith<$Res> {
  factory $SaveGoodStateCopyWith(
          SaveGoodState value, $Res Function(SaveGoodState) then) =
      _$SaveGoodStateCopyWithImpl<$Res, SaveGoodState>;
  @useResult
  $Res call(
      {BaseState state,
      NameInput name,
      String description,
      String barCode,
      List<String> files,
      int quantity,
      Good? item});
}

/// @nodoc
class _$SaveGoodStateCopyWithImpl<$Res, $Val extends SaveGoodState>
    implements $SaveGoodStateCopyWith<$Res> {
  _$SaveGoodStateCopyWithImpl(this._value, this._then);

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
    Object? barCode = null,
    Object? files = null,
    Object? quantity = null,
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
      barCode: null == barCode
          ? _value.barCode
          : barCode // ignore: cast_nullable_to_non_nullable
              as String,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<String>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Good?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $SaveGoodStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      NameInput name,
      String description,
      String barCode,
      List<String> files,
      int quantity,
      Good? item});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$SaveGoodStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? name = null,
    Object? description = null,
    Object? barCode = null,
    Object? files = null,
    Object? quantity = null,
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
      barCode: null == barCode
          ? _value.barCode
          : barCode // ignore: cast_nullable_to_non_nullable
              as String,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<String>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Good?,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.name = const NameInput.pure(),
      this.description = '',
      this.barCode = '',
      final List<String> files = const [],
      this.quantity = 0,
      this.item})
      : _files = files;

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
  final String barCode;
  final List<String> _files;
  @override
  @JsonKey()
  List<String> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  @JsonKey()
  final int quantity;
  @override
  final Good? item;

  @override
  String toString() {
    return 'SaveGoodState.initial(state: $state, name: $name, description: $description, barCode: $barCode, files: $files, quantity: $quantity, item: $item)';
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
            (identical(other.barCode, barCode) || other.barCode == barCode) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.item, item) || other.item == item));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state, name, description,
      barCode, const DeepCollectionEquality().hash(_files), quantity, item);

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
            NameInput name,
            String description,
            String barCode,
            List<String> files,
            int quantity,
            Good? item)
        initial,
  }) {
    return initial(state, name, description, barCode, files, quantity, item);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BaseState state, NameInput name, String description,
            String barCode, List<String> files, int quantity, Good? item)?
        initial,
  }) {
    return initial?.call(
        state, name, description, barCode, files, quantity, item);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BaseState state, NameInput name, String description,
            String barCode, List<String> files, int quantity, Good? item)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, name, description, barCode, files, quantity, item);
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

abstract class _Initial implements SaveGoodState {
  const factory _Initial(
      {required final BaseState state,
      final NameInput name,
      final String description,
      final String barCode,
      final List<String> files,
      final int quantity,
      final Good? item}) = _$_Initial;

  @override
  BaseState get state;
  @override
  NameInput get name;
  @override
  String get description;
  @override
  String get barCode;
  @override
  List<String> get files;
  @override
  int get quantity;
  @override
  Good? get item;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
