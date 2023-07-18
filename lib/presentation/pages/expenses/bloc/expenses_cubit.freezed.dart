// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExpensesState {
  BaseState get state => throw _privateConstructorUsedError;
  List<Expense> get allItems => throw _privateConstructorUsedError;
  List<Expense> get items => throw _privateConstructorUsedError;
  String get textSearch => throw _privateConstructorUsedError;
  ExpensesSetting get settings => throw _privateConstructorUsedError;
  bool get showSearchBar => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BaseState state,
            List<Expense> allItems,
            List<Expense> items,
            String textSearch,
            ExpensesSetting settings,
            bool showSearchBar)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            List<Expense> allItems,
            List<Expense> items,
            String textSearch,
            ExpensesSetting settings,
            bool showSearchBar)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            List<Expense> allItems,
            List<Expense> items,
            String textSearch,
            ExpensesSetting settings,
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
  $ExpensesStateCopyWith<ExpensesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpensesStateCopyWith<$Res> {
  factory $ExpensesStateCopyWith(
          ExpensesState value, $Res Function(ExpensesState) then) =
      _$ExpensesStateCopyWithImpl<$Res, ExpensesState>;
  @useResult
  $Res call(
      {BaseState state,
      List<Expense> allItems,
      List<Expense> items,
      String textSearch,
      ExpensesSetting settings,
      bool showSearchBar});

  $ExpensesSettingCopyWith<$Res> get settings;
}

/// @nodoc
class _$ExpensesStateCopyWithImpl<$Res, $Val extends ExpensesState>
    implements $ExpensesStateCopyWith<$Res> {
  _$ExpensesStateCopyWithImpl(this._value, this._then);

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
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      allItems: null == allItems
          ? _value.allItems
          : allItems // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      textSearch: null == textSearch
          ? _value.textSearch
          : textSearch // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ExpensesSetting,
      showSearchBar: null == showSearchBar
          ? _value.showSearchBar
          : showSearchBar // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExpensesSettingCopyWith<$Res> get settings {
    return $ExpensesSettingCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $ExpensesStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseState state,
      List<Expense> allItems,
      List<Expense> items,
      String textSearch,
      ExpensesSetting settings,
      bool showSearchBar});

  @override
  $ExpensesSettingCopyWith<$Res> get settings;
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$ExpensesStateCopyWithImpl<$Res, _$_Initial>
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
  }) {
    return _then(_$_Initial(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as BaseState,
      allItems: null == allItems
          ? _value._allItems
          : allItems // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
      textSearch: null == textSearch
          ? _value.textSearch
          : textSearch // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ExpensesSetting,
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
      final List<Expense> allItems = const [],
      final List<Expense> items = const [],
      this.textSearch = '',
      required this.settings,
      this.showSearchBar = false})
      : _allItems = allItems,
        _items = items;

  @override
  final BaseState state;
  final List<Expense> _allItems;
  @override
  @JsonKey()
  List<Expense> get allItems {
    if (_allItems is EqualUnmodifiableListView) return _allItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allItems);
  }

  final List<Expense> _items;
  @override
  @JsonKey()
  List<Expense> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String textSearch;
  @override
  final ExpensesSetting settings;
  @override
  @JsonKey()
  final bool showSearchBar;

  @override
  String toString() {
    return 'ExpensesState.initial(state: $state, allItems: $allItems, items: $items, textSearch: $textSearch, settings: $settings, showSearchBar: $showSearchBar)';
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
                other.showSearchBar == showSearchBar));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(_allItems),
      const DeepCollectionEquality().hash(_items),
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
            List<Expense> allItems,
            List<Expense> items,
            String textSearch,
            ExpensesSetting settings,
            bool showSearchBar)
        initial,
  }) {
    return initial(state, allItems, items, textSearch, settings, showSearchBar);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BaseState state,
            List<Expense> allItems,
            List<Expense> items,
            String textSearch,
            ExpensesSetting settings,
            bool showSearchBar)?
        initial,
  }) {
    return initial?.call(
        state, allItems, items, textSearch, settings, showSearchBar);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BaseState state,
            List<Expense> allItems,
            List<Expense> items,
            String textSearch,
            ExpensesSetting settings,
            bool showSearchBar)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
          state, allItems, items, textSearch, settings, showSearchBar);
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

abstract class _Initial implements ExpensesState {
  const factory _Initial(
      {required final BaseState state,
      final List<Expense> allItems,
      final List<Expense> items,
      final String textSearch,
      required final ExpensesSetting settings,
      final bool showSearchBar}) = _$_Initial;

  @override
  BaseState get state;
  @override
  List<Expense> get allItems;
  @override
  List<Expense> get items;
  @override
  String get textSearch;
  @override
  ExpensesSetting get settings;
  @override
  bool get showSearchBar;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
