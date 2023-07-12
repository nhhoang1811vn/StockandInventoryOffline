/*
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';
import 'package:good_manager/domain/usecases/app/get_barcode_scanner_settings_usecase.dart';
import 'package:good_manager/domain/usecases/app/set_barcode_scanner_settings_usecase.dart';

class BarcodeScannerPresenter extends Presenter {
  Function getSettingsOnNext;
  Function getSettingsOnError;

  Function setSettingsOnComplete;
  Function setSettingsOnError;

  GetBarcodeScannerSettingsUseCase getBarcodeScannerSettingsUseCase;
  SetBarcodeScannerSettingsUseCase setBarcodeScannerSettingsUseCase;

  BarcodeScannerPresenter(repository) {
    getBarcodeScannerSettingsUseCase =
        GetBarcodeScannerSettingsUseCase(repository);
    setBarcodeScannerSettingsUseCase =
        SetBarcodeScannerSettingsUseCase(repository);
  }

  void getSettings() => getBarcodeScannerSettingsUseCase
      .execute(GetBarcodeScannerSettingsUseCaseObserver(this));

  void setSettings(BarcodeScannerSettings settings) =>
      setBarcodeScannerSettingsUseCase.execute(
          SetBarcodeScannerSettingsUseCaseObserver(this),
          SetBarcodeScannerSettingsParams(settings));

  @override
  void dispose() {
    getBarcodeScannerSettingsUseCase.dispose();
    setBarcodeScannerSettingsUseCase.dispose();
  }
}

class GetBarcodeScannerSettingsUseCaseObserver
    implements Observer<BarcodeScannerSettings> {
  final BarcodeScannerPresenter presenter;

  GetBarcodeScannerSettingsUseCaseObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getSettingsOnError(e);
  }

  @override
  void onNext(BarcodeScannerSettings response) {
    presenter.getSettingsOnNext(response);
  }
}

class SetBarcodeScannerSettingsUseCaseObserver implements Observer<void> {
  final BarcodeScannerPresenter presenter;

  SetBarcodeScannerSettingsUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    presenter.setSettingsOnComplete();
  }

  @override
  void onError(e) {
    presenter.setSettingsOnError(e);
  }

  @override
  void onNext(void response) {}
}
*/
