import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

enum SortByText {
  no_sort(0),
  a_to_z(1),
  z_to_a(2);

  const SortByText(this.value);

  final int value;
}

extension SortByTextExtension on SortByText {
  String getText(BuildContext context) {
    switch (this) {
      case SortByText.no_sort:
        return context.tr("no_sort");
      case SortByText.a_to_z:
        return context.tr("a_to_z");
      case SortByText.z_to_a:
        return context.tr("z_to_a");
    }
  }
}
