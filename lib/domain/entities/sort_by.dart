enum SortBy { no_sort, a_to_z, z_to_a }

extension SortByExtension on SortBy {
  int get value {
    switch (this) {
      case SortBy.no_sort:
        return 1;
      case SortBy.a_to_z:
        return 2;
      default:
        return 3;
    }
  }
}

class SortByHelper {
  static SortBy get(int value) {
    switch (value) {
      case 1:
        {
          return SortBy.no_sort;
        }
      case 2:
        {
          return SortBy.a_to_z;
        }
      default:
        {
          return SortBy.z_to_a;
        }
    }
  }
}
