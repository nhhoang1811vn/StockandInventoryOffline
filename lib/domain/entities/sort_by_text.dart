enum SortByText { no_sort, a_to_z, z_to_a }

class SortByTextHelper {
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
