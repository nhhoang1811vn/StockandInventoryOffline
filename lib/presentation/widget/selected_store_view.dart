import 'package:flutter/material.dart';

import '../../data/app_settings.dart';

class SelectedStoreView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectedStoreViewState();
  }
}

class SelectedStoreViewState extends State<SelectedStoreView> {
  SelectedStoreViewState();

  @override
  Widget build(BuildContext context) {
    String storeName = AppSettings.getSelectedStoreName();
    return Container(
      height: 30,
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Text(
          storeName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
