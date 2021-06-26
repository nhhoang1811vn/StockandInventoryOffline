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
