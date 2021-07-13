import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/general_infomation.dart';
import 'package:good_manager/domain/usecases/get_general_information_usecase.dart';

class HomePresenter extends Presenter {
  Function getGeneralInformationOnNext;
  Function getGeneralInformationOnError;

  GetGeneralInformationUseCase getGeneralInformationUseCase;

  HomePresenter(
      storeRepository,
      goodRepository,
      documentRepository,
      transactionRepository,
      supplierRepository,
      customerRepository,
      expenseRepository)
      : super() {
    getGeneralInformationUseCase = GetGeneralInformationUseCase(
        storeRepository,
        goodRepository,
        documentRepository,
        transactionRepository,
        supplierRepository,
        customerRepository,
        expenseRepository);
  }

  void getGeneralInformation() =>
      getGeneralInformationUseCase.execute(GetGeneralInformationObserver(this));

  @override
  void dispose() {
    getGeneralInformationUseCase.dispose();
  }
}

class GetGeneralInformationObserver extends Observer<GeneralInformation> {
  final HomePresenter presenter;

  GetGeneralInformationObserver(this.presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    presenter.getGeneralInformationOnError(e);
  }

  @override
  void onNext(GeneralInformation response) {
    presenter.getGeneralInformationOnNext(response);
  }
}
