import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';
import '../../../../../models/currency.dart';

part 'settings_general_cubit.freezed.dart';
part 'settings_general_state.dart';

@injectable
class SettingsGeneralCubit extends Cubit<SettingsGeneralState> {
  SettingsGeneralCubit()
      : super(
          SettingsGeneralState.initial(
            enablePasscode: AppSettings.getEnablePasscode(),
            passcode: AppSettings.getPasscode(),
            currency: AppSettings.currency
          ),
        );

  void onEnablePasscodeChanged(bool value, String passcode) {
    AppSettings.setEnablePasscode(value);
    AppSettings.setPasscode(passcode);
    emit(state.copyWith(enablePasscode: value, passcode: passcode));
  }

  void resetAutoDocumentNo() {
    AppSettings.resetAutoDocumentNo();
  }
  void onCurrencyChanged(Currency value){
    emit(state.copyWith(currency : value));
    AppSettings.currency = value;
  }
}
