import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/barcode_scanner/barcode_scanner_presenter.dart';
import 'package:good_manager/app/pages/barcode_scanner/change_batch_mode_scan_dialog.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';

class BarcodeScannerController extends Controller {
  BarcodeScannerPresenter presenter;
  BarcodeScannerSettings _settings;

  BarcodeScannerSettings get settings => _settings;

  BarcodeScannerController(repository)
      : presenter = BarcodeScannerPresenter(repository),
        super() {
    _settings = BarcodeScannerSettings();
    //isLoading = true;
    retrieveSettings();
  }

  void retrieveSettings() {
    presenter.getSettings();
  }

  @override
  void initListeners() {
    presenter.getSettingsOnNext = (settings) {
      this._settings = settings;
      refreshUI();
    };
    presenter.getSettingsOnError = (e) {
      showErrorToast(e.toString());
    };

    presenter.setSettingsOnComplete = () {};
    presenter.setSettingsOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void setEnableBeep(bool value) {
    _settings.enableBeep = value;
    presenter.setSettings(_settings);
    refreshUI();
  }

  void setEnableVibrate(bool value) {
    _settings.enableVibrate = value;
    presenter.setSettings(_settings);
    refreshUI();
  }

  void onChangeBatchModeScan() {
    showDialog(
        context: getContext(),
        builder: (_) => ChangeBatchModeScanDialogWidget(
            _settings.batchModeScan, (it) => {onChangedBatchModeScan(it)}),
        barrierDismissible: true);
  }

  void onChangedBatchModeScan(BatchModeScan mode) {
    _settings.batchModeScan = mode;
    presenter.setSettings(_settings);
    refreshUI();
  }

  String getBatchModeScanText() {
    if (_settings == null) {
      return "";
    }
    if (_settings.batchModeScan == BatchModeScan.AUTO) {
      return AppLocalizations.of(getContext()).after_each_scan_auto;
    } else {
      return AppLocalizations.of(getContext()).after_each_scan_manually;
    }
  }
}
