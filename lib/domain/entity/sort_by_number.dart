import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

enum SortByNumber {
  no_sort(0),
  ascending(1),
  descending(2);

  const SortByNumber(this.value);

  final int value;
}

extension SortByNumberExtension on SortByNumber {
  String getText(BuildContext context) {
    switch (this) {
      case SortByNumber.no_sort:
        return context.tr("no_sort");
      case SortByNumber.ascending:
        return context.tr("ascending");
      case SortByNumber.descending:
        return context.tr("descending");
    }
  }
}
