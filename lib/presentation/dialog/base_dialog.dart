import 'package:flutter/material.dart';

import '../../util/util.dart';

abstract class BaseDialog extends StatefulWidget {
  const BaseDialog({
    super.key,
  });
}

abstract class BaseDialogState<T extends BaseDialog> extends State<T> {
  @override
  void initState() {
    super.initState();
  }

  var defaultInsetPadding = const EdgeInsets.symmetric(
    horizontal: Dimens.spacingNormal,
    vertical: Dimens.spacingXLarge,
  );

  var shape = const RoundedRectangleBorder(
    side: BorderSide(color: Colors.grey, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(24)),
  );

  Widget titleWidget(String? value) {
    return (value == null)
        ? const SizedBox()
        : Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Dimens.textLarge,
              ),
            ),
          );
  }
}
