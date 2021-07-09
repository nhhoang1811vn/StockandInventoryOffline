import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SortByNumber { no_sort, ascending, descending }

class SortByNumberHelper {
  static SortByNumber get(int value) {
    switch (value) {
      case 1:
        {
          return SortByNumber.ascending;
        }
      case 2:
        {
          return SortByNumber.descending;
        }
      default:
        {
          return SortByNumber.no_sort;
        }
    }
  }

  static String getText(BuildContext context, SortByNumber a) {
    switch (a) {
      case SortByNumber.ascending:
        {
          return AppLocalizations.of(context).sort_by_option_ascending_text;
        }
      case SortByNumber.descending:
        {
          return AppLocalizations.of(context).sort_by_option_descending_text;
        }
      default:
        {
          return AppLocalizations.of(context).sort_by_option_no_sort_text;
        }
    }
  }

  static int getValue(SortByNumber a) {
    switch (a) {
      case SortByNumber.ascending:
        {
          return 1;
        }
      case SortByNumber.descending:
        {
          return 2;
        }
      default:
        {
          return 0;
        }
    }
  }
}
