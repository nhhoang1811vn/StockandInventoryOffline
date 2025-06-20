import 'package:flutter/widgets.dart';
import 'package:good_manager/l10n/app_localizations.dart';

enum SortByText {
  no_sort(0),
  a_to_z(1),
  z_to_a(2);
  const SortByText(this.value);
  final int value;
}
extension SortByTextExtension on SortByText{
  String getText(BuildContext context){
    switch(this){
      case SortByText.no_sort:
        return AppLocalizations.of(context)!.sort_by_option_no_sort_text;
      case SortByText.a_to_z:
        return AppLocalizations.of(context)!.sort_by_option_a_to_z_text;
      case SortByText.z_to_a:
        return AppLocalizations.of(context)!.sort_by_option_z_to_a_text;
    }
  }
}
