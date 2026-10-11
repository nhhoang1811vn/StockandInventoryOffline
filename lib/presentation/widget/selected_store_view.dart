import 'package:flutter/material.dart';

import '../../data/app_settings.dart';

class SelectedStoreView extends StatefulWidget {
  final bool canChange;
  final VoidCallback?  onPressed;

  SelectedStoreView({this.canChange = false, this.onPressed});

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
    return InkWell(
      onTap: () {
        widget.onPressed?.call();
      },
      child: Container(
        height: 30,
        color: Theme.of(context).colorScheme.primary,
        child: Stack(children: [
          Center(
            child: Text(
              storeName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.canChange)
            Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 24,
                    ))),
        ]),
      ),
    );
  }
}
