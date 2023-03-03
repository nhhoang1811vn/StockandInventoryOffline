import 'package:flutter/material.dart';

import '../../data/app_data_manager.dart';
import '../utils/constants.dart';

class SelectedStoreView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectedStoreViewState();
  }
}

class SelectedStoreViewState extends State<SelectedStoreView> {
  String storeName = "";

  SelectedStoreViewState() {
    appDataManager.sharedPrefsHelper
        .getSelectedStoreName()
        .then((value) => setState(() {
              storeName = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: UIConstants.primaryDarkColor,
      child: Center(
        child: Text(
          storeName,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
