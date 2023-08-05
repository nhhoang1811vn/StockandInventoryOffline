// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_document_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SaveDocumentState {
  BaseState get state => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  NameInput get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String get exceptionError => throw _privateConstructorUsedError;
  Document? get item => throw _privateConstructorUsedError;
  int? get personId => throw _privateConstructorUsedError;
  String? get personName => throw _privateConstructorUsedError;
  List<DocumentTransaction> get transactions =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            int id,
            NameInput name,
            String description,
            DateTime? date,
            String exceptionError,
            Document? item,
            int? personId,
            String? personName,
            List<DocumentTransaction> transactions)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            int id,
            NameInput name,
            String description,
            DateTime? date,
            String exceptionError,
            Document? item,
            int? personId,
            String? personName,
            List<DocumentTransaction> transactions)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            int id,
            NameInput name,
            String description,
            DateTime? date,
            String exceptionError,
            Document? item,
            int? personId,
            String? personName,
            List<DocumentTransaction> transactions)?
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
  $SaveDocumentStateCopyWith<SaveDocumentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveDocumentStateCopyWith<$Res> {
  factory $SaveDocumentStateCopyWith(
          SaveDocumentState value, $Res Function(SaveDocumentState) then) =
      _$SaveDocumentStateCopyWithImpl<$Res, SaveDocumentState>;
  @useResult
  $Res call(
      {BaseState state,
      int id,
      NameInput name,
      String description,
      DateTime? date,
      String exceptionError,
      Document? item,
      int? personId,
      String? personName,
      List<DocumentTransaction> transactions});
}

/// @nodoc
class _$SaveDocumentStateCopyWithImpl<$Res, $Val extends SaveDocumentState>
    implements $SaveDocumentStateCopyWith<$Res> {
  _$SaveDocumentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? date = freezed,
    Object? exceptionError = null,
    Object? item = freezed,
    Object? personId = freezed,
    Object? personName = freezed,
    Object? transactions = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as NameInput,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exceptionError: null == exceptionError
          ? _value.exceptionError
          : exceptionError // ignore: cast_nullable_to_non_nullable
              as String,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Document?,
      personId: freezed == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as int?,
      personName: freezed == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String?,
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<DocumentTransaction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $SaveDocumentStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      int id,
      NameInput name,
      String description,
      DateTime? date,
      String exceptionError,
      Document? item,
      int? personId,
      String? personName,
      List<DocumentTransaction> transactions});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$SaveDocumentStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? date = freezed,
    Object? exceptionError = null,
    Object? item = freezed,
    Object? personId = freezed,
    Object? personName = freezed,
    Object? transactions = null,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as NameInput,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exceptionError: null == exceptionError
          ? _value.exceptionError
          : exceptionError // ignore: cast_nullable_to_non_nullable
              as String,
      item: freezed == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Document?,
      personId: freezed == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as int?,
      personName: freezed == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String?,
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<DocumentTransaction>,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      this.id = -1,
      this.name = const NameInput.pure(),
      this.description = '',
      this.date,
      this.exceptionError = '',
      this.item,
      this.personId,
      this.personName,
      final List<DocumentTransaction> transactions = const []})
      : _transactions = transactions;

  @override
  final BaseState state;
  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final NameInput name;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime? date;
  @override
  @JsonKey()
  final String exceptionError;
  @override
  final Document? item;
  @override
  final int? personId;
  @override
  final String? personName;
  final List<DocumentTransaction> _transactions;
  @override
  @JsonKey()
  List<DocumentTransaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'SaveDocumentState.initial(state: $state, id: $id, name: $name, description: $description, date: $date, exceptionError: $exceptionError, item: $item, personId: $personId, personName: $personName, transactions: $transactions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.exceptionError, exceptionError) ||
                other.exceptionError == exceptionError) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.personId, personId) ||
                other.personId == personId) &&
            (identical(other.personName, personName) ||
                other.personName == personName) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      id,
      name,
      description,
      date,
      exceptionError,
      item,
      personId,
      personName,
      const DeepCollectionEquality().hash(_transactions));

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
            int id,
            NameInput name,
            String description,
            DateTime? date,
            String exceptionError,
            Document? item,
            int? personId,
            String? personName,
            List<DocumentTransaction> transactions)
        initial,
  }) {
    return initial(state, id, name, description, date, exceptionError, item,
        personId, personName, transactions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            int id,
            NameInput name,
            String description,
            DateTime? date,
            String exceptionError,
            Document? item,
            int? personId,
            String? personName,
            List<DocumentTransaction> transactions)?
        initial,
  }) {
    return initial?.call(state, id, name, description, date, exceptionError,
        item, personId, personName, transactions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            int id,
            NameInput name,
            String description,
            DateTime? date,
            String exceptionError,
            Document? item,
            int? personId,
            String? personName,
            List<DocumentTransaction> transactions)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, id, name, description, date, exceptionError, item,
          personId, personName, transactions);
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

abstract class _Initial implements SaveDocumentState {
  const factory _Initial(
      {required final BaseState state,
      final int id,
      final NameInput name,
      final String description,
      final DateTime? date,
      final String exceptionError,
      final Document? item,
      final int? personId,
      final String? personName,
      final List<DocumentTransaction> transactions}) = _$_Initial;

  @override
  BaseState get state;
  @override
  int get id;
  @override
  NameInput get name;
  @override
  String get description;
  @override
  DateTime? get date;
  @override
  String get exceptionError;
  @override
  Document? get item;
  @override
  int? get personId;
  @override
  String? get personName;
  @override
  List<DocumentTransaction> get transactions;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
