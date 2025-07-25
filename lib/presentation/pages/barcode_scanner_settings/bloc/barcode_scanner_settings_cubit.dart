import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/batch_mode_scan.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';

part 'barcode_scanner_settings_cubit.freezed.dart';
part 'barcode_scanner_settings_state.dart';

@injectable
class BarcodeScannerSettingsCubit extends Cubit<BarcodeScannerSettingsState>{
  final Storage storage;

  BarcodeScannerSettingsCubit({
    required this.storage
  }) : super(BarcodeScannerSettingsState.initial(
      batchModeScan: storage.getBatchModeScan(),
      enableBeep: storage.getBarcodeScannerEnableBeep(),
      enableVibrate: storage.getBarcodeScannerEnableVibrate()));

  void onEnableBeepChanged(bool value) {
    storage.setBarcodeScannerEnableBeep(value);
    emit(state.copyWith(enableBeep: value));
  }

  void onEnableVibrateChanged(bool value) {
    storage.setBarcodeScannerEnableVibrate(value);
    emit(state.copyWith(enableVibrate: value));
  }

  void setBatchModeScan(BatchModeScan mode) {
    storage.setBatchModeScan(mode);
    emit(state.copyWith(batchModeScan: mode));
  }
}