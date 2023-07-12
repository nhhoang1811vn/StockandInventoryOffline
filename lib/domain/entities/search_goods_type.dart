import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SearchGoodsType {
  byName(1),
  byDescription(2),
  byBarcode(3),
  everywhere(4);

  const SearchGoodsType(this.value);
  final int value;
}
extension SearchGoodsTypeExtension on SearchGoodsType{
  String getText(BuildContext context){
    switch(this){
      case SearchGoodsType.byName:
        return AppLocalizations.of(context)!.search_goods_type_by_name;
      case SearchGoodsType.byDescription:
        return AppLocalizations.of(context)!.search_goods_type_by_description;
      case SearchGoodsType.byBarcode:
        return AppLocalizations.of(context)!.search_goods_type_by_barcode;
      default:
        return AppLocalizations.of(context)!.search_goods_type_everywhere;
    }
  }
}
