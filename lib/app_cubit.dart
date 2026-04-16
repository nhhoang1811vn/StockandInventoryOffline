import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'data/app_settings.dart';
import 'models/app_language.dart';
import 'models/app_theme.dart';

part 'app_cubit.freezed.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial(
      selectedTab: 0,
      theme: AppSettings.appTheme,
      language: AppSettings.appLanguage
  ));

  void setTheme(AppTheme theme) async {
    AppSettings.appTheme = theme;
    emit(state.copyWith(theme: theme));
  }
  void setLanguage(AppLanguage language) async{
    AppSettings.appLanguage = language;
    emit(state.copyWith(language: language));
  }
  void onSelectedTabChanged(int tab){
    emit(state.copyWith(selectedTab : tab));
  }
}
