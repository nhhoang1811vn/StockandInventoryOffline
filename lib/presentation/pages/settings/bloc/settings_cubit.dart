import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:injectable/injectable.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState.initial(
            enablePasscode: AppSettings.getEnablePasscode(),
            passcode: AppSettings.getPasscode(),
          ),
        );

  void onEnablePasscodeChanged(bool value, String passcode) {
    AppSettings.setEnablePasscode(value);
    AppSettings.setPasscode(passcode);
    emit(state.copyWith(enablePasscode: value, passcode: passcode));
  }
}
