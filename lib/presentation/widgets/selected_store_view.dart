import 'package:flutter/material.dart';
import 'package:good_manager/main.dart';

import '../constants.dart';

class SelectedStoreView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectedStoreViewState();
  }
}

class SelectedStoreViewState extends State<SelectedStoreView> {
  String storeName = storage.getSelectedStoreName();

  SelectedStoreViewState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Theme.of(context).colorScheme.primary,
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
