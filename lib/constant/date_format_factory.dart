import 'package:intl/intl.dart';

import '../data/app_settings.dart';

class DateFormatFactory {
  static DateFormat dateFormatEnglish = DateFormat("yyyy/MM/dd", "en");
  static DateFormat dateFormatVietNam = DateFormat("dd/MM/yyyy", "vi");

  static DateFormat getDateFormat() {
    String code = AppSettings.getLanguageCode();
    if (code == "vi") {
      return dateFormatVietNam;
    } else {
      return dateFormatEnglish;
    }
  }

  static DateFormat dateAndTimeFormatEnglish = DateFormat("yyyy/MM/dd HH:mm", "en");
  static DateFormat dateAndTimeFormatVietNam = DateFormat("dd/MM/yyyy HH:mm", "vi");

  static DateFormat getDateAndTimeFormat() {
    String code = AppSettings.getLanguageCode();
    if (code == "vi") {
      return dateAndTimeFormatVietNam;
    } else {
      return dateAndTimeFormatEnglish;
    }
  }

  static DateFormat monthFormatEnglish = DateFormat.MMM("en");
  static DateFormat monthFormatVietNam = DateFormat.MMM("vi");

  static DateFormat getMonthFormat() {
    String code = AppSettings.getLanguageCode();
    if (code == "vi") {
      return monthFormatVietNam;
    } else {
      return monthFormatEnglish;
    }
  }
}
