// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DocumentsState {
  BaseState get state => throw _privateConstructorUsedError;
  List<Document> get items => throw _privateConstructorUsedError;
  List<Document> get incomingItems => throw _privateConstructorUsedError;
  List<Document> get outgoingItems => throw _privateConstructorUsedError;
  String get textSearch => throw _privateConstructorUsedError;
  DocumentsSetting get settings => throw _privateConstructorUsedError;
  bool get showSearchBar => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            List<Document> items,
            List<Document> incomingItems,
            List<Document> outgoingItems,
            String textSearch,
            DocumentsSetting settings,
            bool showSearchBar)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            List<Document> items,
            List<Document> incomingItems,
            List<Document> outgoingItems,
            String textSearch,
            DocumentsSetting settings,
            bool showSearchBar)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            List<Document> items,
            List<Document> incomingItems,
            List<Document> outgoingItems,
            String textSearch,
            DocumentsSetting settings,
            bool showSearchBar)?
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
  $DocumentsStateCopyWith<DocumentsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentsStateCopyWith<$Res> {
  factory $DocumentsStateCopyWith(
          DocumentsState value, $Res Function(DocumentsState) then) =
      _$DocumentsStateCopyWithImpl<$Res, DocumentsState>;
  @useResult
  $Res call(
      {BaseState state,
      List<Document> items,
      List<Document> incomingItems,
      List<Document> outgoingItems,
      String textSearch,
      DocumentsSetting settings,
      bool showSearchBar});

  $DocumentsSettingCopyWith<$Res> get settings;
}

/// @nodoc
class _$DocumentsStateCopyWithImpl<$Res, $Val extends DocumentsState>
    implements $DocumentsStateCopyWith<$Res> {
  _$DocumentsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? items = null,
    Object? incomingItems = null,
    Object? outgoingItems = null,
    Object? textSearch = null,
    Object? settings = null,
    Object? showSearchBar = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Document>,
      incomingItems: null == incomingItems
          ? _value.incomingItems
          : incomingItems // ignore: cast_nullable_to_non_nullable
              as List<Document>,
      outgoingItems: null == outgoingItems
          ? _value.outgoingItems
          : outgoingItems // ignore: cast_nullable_to_non_nullable
              as List<Document>,
      textSearch: null == textSearch
          ? _value.textSearch
          : textSearch // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as DocumentsSetting,
      showSearchBar: null == showSearchBar
          ? _value.showSearchBar
          : showSearchBar // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DocumentsSettingCopyWith<$Res> get settings {
    return $DocumentsSettingCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $DocumentsStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      List<Document> items,
      List<Document> incomingItems,
      List<Document> outgoingItems,
      String textSearch,
      DocumentsSetting settings,
      bool showSearchBar});

  @override
  $DocumentsSettingCopyWith<$Res> get settings;
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$DocumentsStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? items = null,
    Object? incomingItems = null,
    Object? outgoingItems = null,
    Object? textSearch = null,
    Object? settings = null,
    Object? showSearchBar = null,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Document>,
      incomingItems: null == incomingItems
          ? _value._incomingItems
          : incomingItems // ignore: cast_nullable_to_non_nullable
              as List<Document>,
      outgoingItems: null == outgoingItems
          ? _value._outgoingItems
          : outgoingItems // ignore: cast_nullable_to_non_nullable
              as List<Document>,
      textSearch: null == textSearch
          ? _value.textSearch
          : textSearch // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as DocumentsSetting,
      showSearchBar: null == showSearchBar
          ? _value.showSearchBar
          : showSearchBar // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      final List<Document> items = const [],
      final List<Document> incomingItems = const [],
      final List<Document> outgoingItems = const [],
      this.textSearch = '',
      required this.settings,
      this.showSearchBar = false})
      : _items = items,
        _incomingItems = incomingItems,
        _outgoingItems = outgoingItems;

  @override
  final BaseState state;
  final List<Document> _items;
  @override
  @JsonKey()
  List<Document> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<Document> _incomingItems;
  @override
  @JsonKey()
  List<Document> get incomingItems {
    if (_incomingItems is EqualUnmodifiableListView) return _incomingItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomingItems);
  }

  final List<Document> _outgoingItems;
  @override
  @JsonKey()
  List<Document> get outgoingItems {
    if (_outgoingItems is EqualUnmodifiableListView) return _outgoingItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outgoingItems);
  }

  @override
  @JsonKey()
  final String textSearch;
  @override
  final DocumentsSetting settings;
  @override
  @JsonKey()
  final bool showSearchBar;

  @override
  String toString() {
    return 'DocumentsState.initial(state: $state, items: $items, incomingItems: $incomingItems, outgoingItems: $outgoingItems, textSearch: $textSearch, settings: $settings, showSearchBar: $showSearchBar)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._incomingItems, _incomingItems) &&
            const DeepCollectionEquality()
                .equals(other._outgoingItems, _outgoingItems) &&
            (identical(other.textSearch, textSearch) ||
                other.textSearch == textSearch) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.showSearchBar, showSearchBar) ||
                other.showSearchBar == showSearchBar));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_incomingItems),
      const DeepCollectionEquality().hash(_outgoingItems),
      textSearch,
      settings,
      showSearchBar);

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
            List<Document> items,
            List<Document> incomingItems,
            List<Document> outgoingItems,
            String textSearch,
            DocumentsSetting settings,
            bool showSearchBar)
        initial,
  }) {
    return initial(state, items, incomingItems, outgoingItems, textSearch,
        settings, showSearchBar);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            List<Document> items,
            List<Document> incomingItems,
            List<Document> outgoingItems,
            String textSearch,
            DocumentsSetting settings,
            bool showSearchBar)?
        initial,
  }) {
    return initial?.call(state, items, incomingItems, outgoingItems, textSearch,
        settings, showSearchBar);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            List<Document> items,
            List<Document> incomingItems,
            List<Document> outgoingItems,
            String textSearch,
            DocumentsSetting settings,
            bool showSearchBar)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, items, incomingItems, outgoingItems, textSearch,
          settings, showSearchBar);
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

abstract class _Initial implements DocumentsState {
  const factory _Initial(
      {required final BaseState state,
      final List<Document> items,
      final List<Document> incomingItems,
      final List<Document> outgoingItems,
      final String textSearch,
      required final DocumentsSetting settings,
      final bool showSearchBar}) = _$_Initial;

  @override
  BaseState get state;
  @override
  List<Document> get items;
  @override
  List<Document> get incomingItems;
  @override
  List<Document> get outgoingItems;
  @override
  String get textSearch;
  @override
  DocumentsSetting get settings;
  @override
  bool get showSearchBar;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
