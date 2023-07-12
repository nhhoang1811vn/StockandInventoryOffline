import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SortByNumber {
  no_sort(0),
  ascending(1),
  descending(2);

  const SortByNumber(this.value);
  final int value;
}

extension SortByNumberExtension on SortByNumber{
  String getText(BuildContext context){
    switch(this){
      case SortByNumber.no_sort:
        return AppLocalizations.of(context)!.sort_by_option_no_sort_text;
      case SortByNumber.ascending:
        return AppLocalizations.of(context)!.sort_by_option_ascending_text;
      case SortByNumber.descending:
        return AppLocalizations.of(context)!.sort_by_option_descending_text;
    }
  }
}
