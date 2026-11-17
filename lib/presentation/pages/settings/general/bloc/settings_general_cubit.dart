import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/services/biometric_auth_service.dart';
import '../../../../../data/app_settings.dart';
import '../../../../../models/currency.dart';

part 'settings_general_cubit.freezed.dart';
part 'settings_general_state.dart';

@injectable
class SettingsGeneralCubit extends Cubit<SettingsGeneralState> {
  final BiometricAuthService _biometric;

  SettingsGeneralCubit(this._biometric)
      : super(
          SettingsGeneralState.initial(
            enablePasscode: AppSettings.getEnablePasscode(),
            passcode: AppSettings.getPasscode(),
            enableFingerprint: AppSettings.getEnableFingerprint(),
            autoLockMinutes: AppSettings.getAutoLockMinutes(),
            currency: AppSettings.currency,
            imageSize: AppSettings.getImageSize(),
            showCropWindow: AppSettings.getShowCropWindow(),
          ),
        ) {
    loadBiometricAvailability();
  }

  Future<void> loadBiometricAvailability() async {
    final available = await _biometric.isAvailable();
    if (!isClosed) emit(state.copyWith(canUseBiometrics: available));
  }

  /// Turning it on requires one successful scan; a failed scan changes nothing.
  Future<void> onEnableFingerprintChanged(bool value, String reason) async {
    if (value && !await _biometric.authenticate(reason)) return;
    AppSettings.setEnableFingerprint(value);
    if (!isClosed) emit(state.copyWith(enableFingerprint: value));
  }

  void onAutoLockMinutesChanged(int value) {
    AppSettings.setAutoLockMinutes(value);
    emit(state.copyWith(autoLockMinutes: AppSettings.getAutoLockMinutes()));
  }

  void onImageSizeChanged(int value) {
    AppSettings.setImageSize(value);
    emit(state.copyWith(imageSize: AppSettings.getImageSize()));
  }

  void onShowCropWindowChanged(bool value) {
    AppSettings.setShowCropWindow(value);
    emit(state.copyWith(showCropWindow: value));
  }

  void onEnablePasscodeChanged(bool value, String passcode) {
    AppSettings.setEnablePasscode(value);
    AppSettings.setPasscode(passcode);
    if (!value) AppSettings.setEnableFingerprint(false);
    emit(state.copyWith(
      enablePasscode: value,
      passcode: passcode,
      enableFingerprint: value ? state.enableFingerprint : false,
    ));
  }

  void resetAutoDocumentNo() {
    AppSettings.resetAutoDocumentNo();
  }
  void onCurrencyChanged(Currency value){
    emit(state.copyWith(currency : value));
    AppSettings.currency = value;
  }
}
