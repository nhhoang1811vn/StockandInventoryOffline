enum SearchGoodsType { byName, byDescription, byBarcode, everywhere }

class SearchGoodsTypeHelper {
  static SearchGoodsType get(int value) {
    switch (value) {
      case 1:
        {
          return SearchGoodsType.byName;
        }
      case 2:
        {
          return SearchGoodsType.byDescription;
        }
      case 3:
        {
          return SearchGoodsType.byBarcode;
        }
      default:
        {
          return SearchGoodsType.everywhere;
        }
    }
  }

  static int getValue(SearchGoodsType a) {
    switch (a) {
      case SearchGoodsType.byName:
        {
          return 1;
        }
      case SearchGoodsType.byDescription:
        {
          return 2;
        }
      case SearchGoodsType.byBarcode:
        {
          return 3;
        }
      default:
        {
          return 0;
        }
    }
  }
}
