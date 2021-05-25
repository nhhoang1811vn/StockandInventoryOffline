import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/data/app_data_manager.dart';

class DocumentsPresenter extends Presenter {
  Future<String> getAutoDocumentName() async {
    return appDataManager.sharedPrefsHelper.getAutoDocumentName();
  }

  @override
  void dispose() {}
}