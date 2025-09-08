part of 'app_cubit.dart';
@freezed
class AppState with _$AppState{
  const factory AppState.initial({
    @Default(0) int selectedTab,
    @Default(AppTheme.system_default) AppTheme theme,
    @Default(AppLanguage.english) AppLanguage language,
  }) = _Initial;
}
