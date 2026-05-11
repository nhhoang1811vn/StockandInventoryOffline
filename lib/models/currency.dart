import 'package:hive/hive.dart';

part 'currency.g.dart';

@HiveType(typeId: 5)
enum Currency {
  @HiveField(0) usd,
  @HiveField(1) eur,
  @HiveField(2) jpy,
  @HiveField(3) gbp,
  @HiveField(4) aud,
  @HiveField(5) cad,
  @HiveField(6) chf,
  @HiveField(7) cny,
  @HiveField(8) hkd,
  @HiveField(9) nzd,
  @HiveField(10) sek,
  @HiveField(11) krw,
  @HiveField(12) sgd,
  @HiveField(13) nok,
  @HiveField(14) mxn,
  @HiveField(15) ngn,
  @HiveField(16) thb,
  @HiveField(17) aed,
  @HiveField(18) inr,
  @HiveField(19) omr,
}

extension CurrencyExtension on Currency {
  String get symbol {
    switch (this) {
      case Currency.usd: return "\$";
      case Currency.eur: return "€";
      case Currency.jpy: return "¥";
      case Currency.gbp: return "£";
      case Currency.aud: return "A\$";
      case Currency.cad: return "C\$";
      case Currency.chf: return "CHF";
      case Currency.cny: return "¥";
      case Currency.hkd: return "HK\$";
      case Currency.nzd: return "NZ\$";
      case Currency.sek: return "kr";
      case Currency.krw: return "₩";
      case Currency.sgd: return "S\$";
      case Currency.nok: return "kr";
      case Currency.mxn: return "\$";
      case Currency.ngn: return "₦";
      case Currency.thb: return "฿";
      case Currency.aed: return "د.إ";
      case Currency.inr: return "₹";
      case Currency.omr: return "ر.ع.";
    }
  }

  String get label {
    switch (this) {
      case Currency.usd: return "USD (\$) - United States Dollar";
      case Currency.eur: return "EUR (€) - Euro";
      case Currency.jpy: return "JPY (¥) - Japanese Yen";
      case Currency.gbp: return "GBP (£) - British Pound Sterling";
      case Currency.aud: return "AUD (A\$) - Australian Dollar";
      case Currency.cad: return "CAD (C\$) - Canadian Dollar";
      case Currency.chf: return "CHF (CHF) - Swiss Franc";
      case Currency.cny: return "CNY (¥) - Chinese Yuan";
      case Currency.hkd: return "HKD (HK\$) - Hong Kong Dollar";
      case Currency.nzd: return "NZD (NZ\$) - New Zealand Dollar";
      case Currency.sek: return "SEK (kr) - Swedish Krona";
      case Currency.krw: return "KRW (₩) - South Korean Won";
      case Currency.sgd: return "SGD (S\$) - Singapore Dollar";
      case Currency.nok: return "NOK (kr) - Norwegian Krone";
      case Currency.mxn: return "MXN (\$) - Mexican Peso";
      case Currency.ngn: return "NGN (₦) - Nigerian Naira";
      case Currency.thb: return "THB (฿) - Thai Baht";
      case Currency.aed: return "AED (د.إ) - United Arab Emirates Dirham";
      case Currency.inr: return "INR (₹) - Indian Rupee";
      case Currency.omr: return "OMR (ر.ع.) - Omani Riyal";
    }
  }
}
