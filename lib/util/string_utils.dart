class StringUtils {
  StringUtils._(); // coverage:ignore-line

  static bool sameFiles(List<String> files1, List<String> files2) {
    if (files1.length != files2.length) {
      return false;
    }
    for (var i = 0; i < files1.length; i++) {
      if (files1[i] != files2[i]) {
        return false;
      }
    }
    return true;
  }

  static String formatNumber(double value) {
    if (value >= 1e9) {
      // Billions (1e9 = 1,000,000,000)
      return '${(value / 1e9).toStringAsFixed(1)}B'; // 1 decimal place for billions
    } else if (value >= 1e6) {
      // Millions (1e6 = 1,000,000)
      return '${(value / 1e6).toStringAsFixed(1)}M'; // 1 decimal place for millions
    } else if (value >= 1e3) {
      // Thousands (1e3 = 1,000)
      return '${(value / 1e3).toStringAsFixed(0)}K'; // No decimals for thousands
    } else {
      return value
          .toStringAsFixed(0); // Show the value as it is for smaller numbers
    }
  }

  static String getQuantityText(double num) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return num.toString().replaceAll(regex, '');
  }
}
