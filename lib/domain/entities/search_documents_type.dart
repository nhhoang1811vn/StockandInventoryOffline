enum SearchDocumentsType { byName, byDescription, byCustomerSupplier }

class SearchDocumentsTypeHelper {
  static SearchDocumentsType get(int value) {
    switch (value) {
      case 1:
        {
          return SearchDocumentsType.byName;
        }
      case 2:
        {
          return SearchDocumentsType.byDescription;
        }
      default:
        {
          return SearchDocumentsType.byCustomerSupplier;
        }
    }
  }

  static int getValue(SearchDocumentsType a) {
    switch (a) {
      case SearchDocumentsType.byName:
        {
          return 1;
        }
      case SearchDocumentsType.byDescription:
        {
          return 2;
        }
      default:
        {
          return 3;
        }
    }
  }
}
