import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SortByText { no_sort, a_to_z, z_to_a }

class SortByTextHelper {
  static String getText(BuildContext context, SortByText a) {
    switch (a) {
      case SortByText.no_sort:
        {
          return AppLocalizations.of(context).sort_by_option_no_sort_text;
        }
      case SortByText.a_to_z:
        {
          return AppLocalizations.of(context).sort_by_option_a_to_z_text;
        }
      default:
        {
          return AppLocalizations.of(context).sort_by_option_z_to_a_text;
        }
    }
  }

  static SortByText get(int value) {
    switch (value) {
      case 1:
        {
          return SortByText.a_to_z;
        }
      case 2:
        {
          return SortByText.z_to_a;
        }
      default:
        {
          return SortByText.no_sort;
        }
    }
  }

  static int getValue(SortByText a) {
    switch (a) {
      case SortByText.a_to_z:
        {
          return 1;
        }
      case SortByText.z_to_a:
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
