
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/onboarding/on_boarding_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/store.dart';

import '../pages.dart';

class OnBoardingController extends Controller {
  OnBoardingPresenter presenter;
  String name = "";

  OnBoardingController(storeRepository)
      : presenter = OnBoardingPresenter(storeRepository),
        super();

  @override
  void initListeners() {
    presenter.insertStoreOnNext = (storeId) async {
      presenter.setFirstTime(false);
      presenter.setSelectedStoreId(storeId);
      presenter.setSelectedStoreName(name);
      //Navigator.of(getContext()).pushReplacementNamed(Pages.main);
      Navigator.of(getContext()).pushReplacementNamed(Pages.home);
    };
    presenter.insertStoreOnError = (e) {
      showErrorToast(e.toString());
    };
  }

  void onAddStore(String name) {
    this.name = name;
    Store store = Store();
    store.name = name;
    store.description = "";
    presenter.insert(store);
  }
}
