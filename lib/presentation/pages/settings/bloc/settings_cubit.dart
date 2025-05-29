import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/storage.dart';
import 'package:injectable/injectable.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final Storage storage;
  SettingsCubit({required this.storage})
      : super(
            SettingsState.initial(enablePasscode: storage.getEnablePasscode(), passcode: storage.getPasscode()));

  void onEnablePasscodeChanged(bool value, String passcode) {
    storage.setEnablePasscode(value);
    storage.setPasscode(passcode);
    emit(state.copyWith(enablePasscode: value, passcode: passcode));
  }
}
