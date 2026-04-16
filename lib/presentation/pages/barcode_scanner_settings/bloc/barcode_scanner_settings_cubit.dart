import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/entity.dart';

part 'barcode_scanner_settings_cubit.freezed.dart';
part 'barcode_scanner_settings_state.dart';

@injectable
class BarcodeScannerSettingsCubit extends Cubit<BarcodeScannerSettingsState> {
  BarcodeScannerSettingsCubit()
      : super(
          BarcodeScannerSettingsState.initial(
            batchModeScan: AppSettings.getBatchModeScan(),
            enableBeep: AppSettings.getBarcodeScannerEnableBeep(),
            enableVibrate: AppSettings.getBarcodeScannerEnableVibrate(),
          ),
        );

  void onEnableBeepChanged(bool value) {
    AppSettings.setBarcodeScannerEnableBeep(value);
    emit(state.copyWith(enableBeep: value));
  }

  void onEnableVibrateChanged(bool value) {
    AppSettings.setBarcodeScannerEnableVibrate(value);
    emit(state.copyWith(enableVibrate: value));
  }

  void setBatchModeScan(BatchModeScan mode) {
    AppSettings.setBatchModeScan(mode);
    emit(state.copyWith(batchModeScan: mode));
  }
}
