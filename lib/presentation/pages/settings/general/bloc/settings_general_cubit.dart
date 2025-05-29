import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/storage.dart';
import 'package:injectable/injectable.dart';

part 'settings_general_cubit.freezed.dart';
part 'settings_general_state.dart';

@injectable
class SettingsGeneralCubit extends Cubit<SettingsGeneralState> {
  final Storage storage;
  SettingsGeneralCubit({required this.storage})
      : super(
      SettingsGeneralState.initial(enablePasscode: storage.getEnablePasscode(), passcode: storage.getPasscode()));

  void onEnablePasscodeChanged(bool value, String passcode) {
    storage.setEnablePasscode(value);
    storage.setPasscode(passcode);
    emit(state.copyWith(enablePasscode: value, passcode: passcode));
  }
}
