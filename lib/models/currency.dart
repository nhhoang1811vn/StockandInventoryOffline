import 'package:hive/hive.dart';

part 'currency.g.dart';

/// Stored with Hive by declaration order. Append new values only.
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
  @HiveField(20)
  vnd,
  @HiveField(21)
  idr,
  @HiveField(22)
  myr,
  @HiveField(23)
  php,
  @HiveField(24)
  twd,
  @HiveField(25)
  brl,
  @HiveField(26)
  zar,
  @HiveField(27)
  rub,
  @HiveField(28)
  tryLira,
  @HiveField(29)
  sar,
  @HiveField(30)
  qar,
  @HiveField(31)
  kwd,
  @HiveField(32)
  bhd,
  @HiveField(33)
  ils,
  @HiveField(34)
  egp,
  @HiveField(35)
  pkr,
  @HiveField(36)
  bdt,
  @HiveField(37)
  lkr,
  @HiveField(38)
  npr,
  @HiveField(39)
  pln,
  @HiveField(40)
  dkk,
  @HiveField(41)
  czk,
  @HiveField(42)
  huf,
  @HiveField(43)
  ron,
  @HiveField(44)
  uah,
  @HiveField(45)
  bgn,
  @HiveField(46)
  rsd,
  @HiveField(47)
  isk,
  @HiveField(48)
  ars,
  @HiveField(49)
  clp,
  @HiveField(50)
  cop,
  @HiveField(51)
  pen,
  @HiveField(52)
  uyu,
  @HiveField(53)
  dop,
  @HiveField(54)
  gtq,
  @HiveField(55)
  crc,
  @HiveField(56)
  bob,
  @HiveField(57)
  pyg,
  @HiveField(58)
  hnl,
  @HiveField(59)
  nio,
  @HiveField(60)
  pab,
  @HiveField(61)
  jmd,
  @HiveField(62)
  ttd,
  @HiveField(63)
  cup,
  @HiveField(64)
  ves,
  @HiveField(65)
  kes,
  @HiveField(66)
  ghs,
  @HiveField(67)
  mad,
  @HiveField(68)
  dzd,
  @HiveField(69)
  tnd,
  @HiveField(70)
  etb,
  @HiveField(71)
  tzs,
  @HiveField(72)
  ugx,
  @HiveField(73)
  xof,
  @HiveField(74)
  xaf,
  @HiveField(75)
  zmw,
  @HiveField(76)
  aoa,
  @HiveField(77)
  mzn,
  @HiveField(78)
  cdf,
  @HiveField(79)
  mur,
  @HiveField(80)
  bwp,
  @HiveField(81)
  nad,
  @HiveField(82)
  rwf,
  @HiveField(83)
  mga,
  @HiveField(84)
  khr,
  @HiveField(85)
  lak,
  @HiveField(86)
  mmk,
  @HiveField(87)
  bnd,
  @HiveField(88)
  iqd,
  @HiveField(89)
  jod,
  @HiveField(90)
  fjd,
  @HiveField(91)
  mop,
  @HiveField(92)
  kzt,
  @HiveField(93)
  uzs,
  @HiveField(94)
  azn,
  @HiveField(95)
  gel,
  @HiveField(96)
  amd,
  @HiveField(97)
  byn,
  @HiveField(98)
  mdl,
  @HiveField(99)
  bam,
  @HiveField(100)
  all,
  @HiveField(101)
  mkd,
  @HiveField(102)
  irr,
  @HiveField(103)
  afn,
  @HiveField(104)
  yer,
  @HiveField(105)
  syp,
  @HiveField(106)
  lyd,
  @HiveField(107)
  mnt,
  @HiveField(108)
  kgs,
  @HiveField(109)
  btn,
  @HiveField(110)
  mvr,
  @HiveField(111)
  xpf,
}

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;

  const CurrencyInfo(this.code, this.symbol, this.name);
}

extension CurrencyExtension on Currency {
  static const Map<Currency, CurrencyInfo> _info = {
    Currency.usd: CurrencyInfo('USD', r'$', 'United States Dollar'),
    Currency.eur: CurrencyInfo('EUR', '€', 'Euro'),
    Currency.jpy: CurrencyInfo('JPY', '¥', 'Japanese Yen'),
    Currency.gbp: CurrencyInfo('GBP', '£', 'British Pound Sterling'),
    Currency.aud: CurrencyInfo('AUD', r'A$', 'Australian Dollar'),
    Currency.cad: CurrencyInfo('CAD', r'C$', 'Canadian Dollar'),
    Currency.chf: CurrencyInfo('CHF', 'CHF', 'Swiss Franc'),
    Currency.cny: CurrencyInfo('CNY', '¥', 'Chinese Yuan'),
    Currency.hkd: CurrencyInfo('HKD', r'HK$', 'Hong Kong Dollar'),
    Currency.nzd: CurrencyInfo('NZD', r'NZ$', 'New Zealand Dollar'),
    Currency.sek: CurrencyInfo('SEK', 'kr', 'Swedish Krona'),
    Currency.krw: CurrencyInfo('KRW', '₩', 'South Korean Won'),
    Currency.sgd: CurrencyInfo('SGD', r'S$', 'Singapore Dollar'),
    Currency.nok: CurrencyInfo('NOK', 'kr', 'Norwegian Krone'),
    Currency.mxn: CurrencyInfo('MXN', r'$', 'Mexican Peso'),
    Currency.ngn: CurrencyInfo('NGN', '₦', 'Nigerian Naira'),
    Currency.thb: CurrencyInfo('THB', '฿', 'Thai Baht'),
    Currency.aed: CurrencyInfo('AED', 'د.إ', 'United Arab Emirates Dirham'),
    Currency.inr: CurrencyInfo('INR', '₹', 'Indian Rupee'),
    Currency.omr: CurrencyInfo('OMR', 'ر.ع.', 'Omani Riyal'),
    Currency.vnd: CurrencyInfo('VND', '₫', 'Vietnamese Dong'),
    Currency.idr: CurrencyInfo('IDR', 'Rp', 'Indonesian Rupiah'),
    Currency.myr: CurrencyInfo('MYR', 'RM', 'Malaysian Ringgit'),
    Currency.php: CurrencyInfo('PHP', '₱', 'Philippine Peso'),
    Currency.twd: CurrencyInfo('TWD', r'NT$', 'New Taiwan Dollar'),
    Currency.brl: CurrencyInfo('BRL', r'R$', 'Brazilian Real'),
    Currency.zar: CurrencyInfo('ZAR', 'R', 'South African Rand'),
    Currency.rub: CurrencyInfo('RUB', '₽', 'Russian Ruble'),
    Currency.tryLira: CurrencyInfo('TRY', '₺', 'Turkish Lira'),
    Currency.sar: CurrencyInfo('SAR', '﷼', 'Saudi Riyal'),
    Currency.qar: CurrencyInfo('QAR', '﷼', 'Qatari Riyal'),
    Currency.kwd: CurrencyInfo('KWD', 'د.ك', 'Kuwaiti Dinar'),
    Currency.bhd: CurrencyInfo('BHD', '.د.ب', 'Bahraini Dinar'),
    Currency.ils: CurrencyInfo('ILS', '₪', 'Israeli Shekel'),
    Currency.egp: CurrencyInfo('EGP', 'E£', 'Egyptian Pound'),
    Currency.pkr: CurrencyInfo('PKR', '₨', 'Pakistani Rupee'),
    Currency.bdt: CurrencyInfo('BDT', '৳', 'Bangladeshi Taka'),
    Currency.lkr: CurrencyInfo('LKR', 'Rs', 'Sri Lankan Rupee'),
    Currency.npr: CurrencyInfo('NPR', 'Rs', 'Nepalese Rupee'),
    Currency.pln: CurrencyInfo('PLN', 'zł', 'Polish Zloty'),
    Currency.dkk: CurrencyInfo('DKK', 'kr', 'Danish Krone'),
    Currency.czk: CurrencyInfo('CZK', 'Kč', 'Czech Koruna'),
    Currency.huf: CurrencyInfo('HUF', 'Ft', 'Hungarian Forint'),
    Currency.ron: CurrencyInfo('RON', 'lei', 'Romanian Leu'),
    Currency.uah: CurrencyInfo('UAH', '₴', 'Ukrainian Hryvnia'),
    Currency.bgn: CurrencyInfo('BGN', 'лв', 'Bulgarian Lev'),
    Currency.rsd: CurrencyInfo('RSD', 'дин', 'Serbian Dinar'),
    Currency.isk: CurrencyInfo('ISK', 'kr', 'Icelandic Krona'),
    Currency.ars: CurrencyInfo('ARS', r'$', 'Argentine Peso'),
    Currency.clp: CurrencyInfo('CLP', r'$', 'Chilean Peso'),
    Currency.cop: CurrencyInfo('COP', r'$', 'Colombian Peso'),
    Currency.pen: CurrencyInfo('PEN', 'S/', 'Peruvian Sol'),
    Currency.uyu: CurrencyInfo('UYU', r'$U', 'Uruguayan Peso'),
    Currency.dop: CurrencyInfo('DOP', r'RD$', 'Dominican Peso'),
    Currency.gtq: CurrencyInfo('GTQ', 'Q', 'Guatemalan Quetzal'),
    Currency.crc: CurrencyInfo('CRC', '₡', 'Costa Rican Colon'),
    Currency.bob: CurrencyInfo('BOB', 'Bs', 'Bolivian Boliviano'),
    Currency.pyg: CurrencyInfo('PYG', '₲', 'Paraguayan Guarani'),
    Currency.hnl: CurrencyInfo('HNL', 'L', 'Honduran Lempira'),
    Currency.nio: CurrencyInfo('NIO', r'C$', 'Nicaraguan Cordoba'),
    Currency.pab: CurrencyInfo('PAB', 'B/.', 'Panamanian Balboa'),
    Currency.jmd: CurrencyInfo('JMD', r'J$', 'Jamaican Dollar'),
    Currency.ttd: CurrencyInfo('TTD', r'TT$', 'Trinidad and Tobago Dollar'),
    Currency.cup: CurrencyInfo('CUP', r'$', 'Cuban Peso'),
    Currency.ves: CurrencyInfo('VES', 'Bs.', 'Venezuelan Bolivar'),
    Currency.kes: CurrencyInfo('KES', 'KSh', 'Kenyan Shilling'),
    Currency.ghs: CurrencyInfo('GHS', '₵', 'Ghanaian Cedi'),
    Currency.mad: CurrencyInfo('MAD', 'د.م.', 'Moroccan Dirham'),
    Currency.dzd: CurrencyInfo('DZD', 'د.ج', 'Algerian Dinar'),
    Currency.tnd: CurrencyInfo('TND', 'د.ت', 'Tunisian Dinar'),
    Currency.etb: CurrencyInfo('ETB', 'Br', 'Ethiopian Birr'),
    Currency.tzs: CurrencyInfo('TZS', 'TSh', 'Tanzanian Shilling'),
    Currency.ugx: CurrencyInfo('UGX', 'USh', 'Ugandan Shilling'),
    Currency.xof: CurrencyInfo('XOF', 'CFA', 'West African CFA Franc'),
    Currency.xaf: CurrencyInfo('XAF', 'FCFA', 'Central African CFA Franc'),
    Currency.zmw: CurrencyInfo('ZMW', 'ZK', 'Zambian Kwacha'),
    Currency.aoa: CurrencyInfo('AOA', 'Kz', 'Angolan Kwanza'),
    Currency.mzn: CurrencyInfo('MZN', 'MT', 'Mozambican Metical'),
    Currency.cdf: CurrencyInfo('CDF', 'FC', 'Congolese Franc'),
    Currency.mur: CurrencyInfo('MUR', '₨', 'Mauritian Rupee'),
    Currency.bwp: CurrencyInfo('BWP', 'P', 'Botswana Pula'),
    Currency.nad: CurrencyInfo('NAD', r'N$', 'Namibian Dollar'),
    Currency.rwf: CurrencyInfo('RWF', 'FRw', 'Rwandan Franc'),
    Currency.mga: CurrencyInfo('MGA', 'Ar', 'Malagasy Ariary'),
    Currency.khr: CurrencyInfo('KHR', '៛', 'Cambodian Riel'),
    Currency.lak: CurrencyInfo('LAK', '₭', 'Lao Kip'),
    Currency.mmk: CurrencyInfo('MMK', 'K', 'Myanmar Kyat'),
    Currency.bnd: CurrencyInfo('BND', r'B$', 'Brunei Dollar'),
    Currency.iqd: CurrencyInfo('IQD', 'ع.د', 'Iraqi Dinar'),
    Currency.jod: CurrencyInfo('JOD', 'د.ا', 'Jordanian Dinar'),
    Currency.fjd: CurrencyInfo('FJD', r'FJ$', 'Fijian Dollar'),
    Currency.mop: CurrencyInfo('MOP', r'MOP$', 'Macanese Pataca'),
    Currency.kzt: CurrencyInfo('KZT', '₸', 'Kazakhstani Tenge'),
    Currency.uzs: CurrencyInfo('UZS', 'soʻm', 'Uzbekistani Som'),
    Currency.azn: CurrencyInfo('AZN', '₼', 'Azerbaijani Manat'),
    Currency.gel: CurrencyInfo('GEL', '₾', 'Georgian Lari'),
    Currency.amd: CurrencyInfo('AMD', '֏', 'Armenian Dram'),
    Currency.byn: CurrencyInfo('BYN', 'Br', 'Belarusian Ruble'),
    Currency.mdl: CurrencyInfo('MDL', 'L', 'Moldovan Leu'),
    Currency.bam:
        CurrencyInfo('BAM', 'KM', 'Bosnia-Herzegovina Convertible Mark'),
    Currency.all: CurrencyInfo('ALL', 'L', 'Albanian Lek'),
    Currency.mkd: CurrencyInfo('MKD', 'ден', 'Macedonian Denar'),
    Currency.irr: CurrencyInfo('IRR', '﷼', 'Iranian Rial'),
    Currency.afn: CurrencyInfo('AFN', '؋', 'Afghan Afghani'),
    Currency.yer: CurrencyInfo('YER', '﷼', 'Yemeni Rial'),
    Currency.syp: CurrencyInfo('SYP', '£', 'Syrian Pound'),
    Currency.lyd: CurrencyInfo('LYD', 'ل.د', 'Libyan Dinar'),
    Currency.mnt: CurrencyInfo('MNT', '₮', 'Mongolian Tugrik'),
    Currency.kgs: CurrencyInfo('KGS', 'с', 'Kyrgyzstani Som'),
    Currency.btn: CurrencyInfo('BTN', 'Nu.', 'Bhutanese Ngultrum'),
    Currency.mvr: CurrencyInfo('MVR', 'Rf', 'Maldivian Rufiyaa'),
    Currency.xpf: CurrencyInfo('XPF', 'Fr', 'CFP Franc'),
  };

  CurrencyInfo get info => _info[this]!;

  String get symbol => info.symbol;

  String get label => '${info.code} (${info.symbol}) - ${info.name}';
}
