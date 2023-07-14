// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suppliers_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SuppliersState {
  BaseState get state => throw _privateConstructorUsedError;
  List<Supplier> get allItems => throw _privateConstructorUsedError;
  List<Supplier> get items => throw _privateConstructorUsedError;
  String get textSearch => throw _privateConstructorUsedError;
  SuppliersSetting get settings => throw _privateConstructorUsedError;
  bool get showSearchBar => throw _privateConstructorUsedError;
  bool get isSelection => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            List<Supplier> allItems,
            List<Supplier> items,
            String textSearch,
            SuppliersSetting settings,
            bool showSearchBar,
            bool isSelection)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            List<Supplier> allItems,
            List<Supplier> items,
            String textSearch,
            SuppliersSetting settings,
            bool showSearchBar,
            bool isSelection)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            List<Supplier> allItems,
            List<Supplier> items,
            String textSearch,
            SuppliersSetting settings,
            bool showSearchBar,
            bool isSelection)?
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
  $SuppliersStateCopyWith<SuppliersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuppliersStateCopyWith<$Res> {
  factory $SuppliersStateCopyWith(
          SuppliersState value, $Res Function(SuppliersState) then) =
      _$SuppliersStateCopyWithImpl<$Res, SuppliersState>;
  @useResult
  $Res call(
      {BaseState state,
      List<Supplier> allItems,
      List<Supplier> items,
      String textSearch,
      SuppliersSetting settings,
      bool showSearchBar,
      bool isSelection});

  $SuppliersSettingCopyWith<$Res> get settings;
}

/// @nodoc
class _$SuppliersStateCopyWithImpl<$Res, $Val extends SuppliersState>
    implements $SuppliersStateCopyWith<$Res> {
  _$SuppliersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? allItems = null,
    Object? items = null,
    Object? textSearch = null,
    Object? settings = null,
    Object? showSearchBar = null,
    Object? isSelection = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      allItems: null == allItems
          ? _value.allItems
          : allItems // ignore: cast_nullable_to_non_nullable
              as List<Supplier>,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Supplier>,
      textSearch: null == textSearch
          ? _value.textSearch
          : textSearch // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as SuppliersSetting,
      showSearchBar: null == showSearchBar
          ? _value.showSearchBar
          : showSearchBar // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelection: null == isSelection
          ? _value.isSelection
          : isSelection // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SuppliersSettingCopyWith<$Res> get settings {
    return $SuppliersSettingCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $SuppliersStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      List<Supplier> allItems,
      List<Supplier> items,
      String textSearch,
      SuppliersSetting settings,
      bool showSearchBar,
      bool isSelection});

  @override
  $SuppliersSettingCopyWith<$Res> get settings;
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$SuppliersStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? allItems = null,
    Object? items = null,
    Object? textSearch = null,
    Object? settings = null,
    Object? showSearchBar = null,
    Object? isSelection = null,
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      allItems: null == allItems
          ? _value._allItems
          : allItems // ignore: cast_nullable_to_non_nullable
              as List<Supplier>,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Supplier>,
      textSearch: null == textSearch
          ? _value.textSearch
          : textSearch // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as SuppliersSetting,
      showSearchBar: null == showSearchBar
          ? _value.showSearchBar
          : showSearchBar // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelection: null == isSelection
          ? _value.isSelection
          : isSelection // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {required this.state,
      final List<Supplier> allItems = const [],
      final List<Supplier> items = const [],
      this.textSearch = '',
      required this.settings,
      this.showSearchBar = false,
      this.isSelection = false})
      : _allItems = allItems,
        _items = items;

  @override
  final BaseState state;
  final List<Supplier> _allItems;
  @override
  @JsonKey()
  List<Supplier> get allItems {
    if (_allItems is EqualUnmodifiableListView) return _allItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allItems);
  }

  final List<Supplier> _items;
  @override
  @JsonKey()
  List<Supplier> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String textSearch;
  @override
  final SuppliersSetting settings;
  @override
  @JsonKey()
  final bool showSearchBar;
  @override
  @JsonKey()
  final bool isSelection;

  @override
  String toString() {
    return 'SuppliersState.initial(state: $state, allItems: $allItems, items: $items, textSearch: $textSearch, settings: $settings, showSearchBar: $showSearchBar, isSelection: $isSelection)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._allItems, _allItems) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.textSearch, textSearch) ||
                other.textSearch == textSearch) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.showSearchBar, showSearchBar) ||
                other.showSearchBar == showSearchBar) &&
            (identical(other.isSelection, isSelection) ||
                other.isSelection == isSelection));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(_allItems),
      const DeepCollectionEquality().hash(_items),
      textSearch,
      settings,
      showSearchBar,
      isSelection);

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
            List<Supplier> allItems,
            List<Supplier> items,
            String textSearch,
            SuppliersSetting settings,
            bool showSearchBar,
            bool isSelection)
        initial,
  }) {
    return initial(state, allItems, items, textSearch, settings, showSearchBar,
        isSelection);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            List<Supplier> allItems,
            List<Supplier> items,
            String textSearch,
            SuppliersSetting settings,
            bool showSearchBar,
            bool isSelection)?
        initial,
  }) {
    return initial?.call(state, allItems, items, textSearch, settings,
        showSearchBar, isSelection);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            List<Supplier> allItems,
            List<Supplier> items,
            String textSearch,
            SuppliersSetting settings,
            bool showSearchBar,
            bool isSelection)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(state, allItems, items, textSearch, settings,
          showSearchBar, isSelection);
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

abstract class _Initial implements SuppliersState {
  const factory _Initial(
      {required final BaseState state,
      final List<Supplier> allItems,
      final List<Supplier> items,
      final String textSearch,
      required final SuppliersSetting settings,
      final bool showSearchBar,
      final bool isSelection}) = _$_Initial;

  @override
  BaseState get state;
  @override
  List<Supplier> get allItems;
  @override
  List<Supplier> get items;
  @override
  String get textSearch;
  @override
  SuppliersSetting get settings;
  @override
  bool get showSearchBar;
  @override
  bool get isSelection;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
