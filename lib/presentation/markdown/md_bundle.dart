import 'package:good_manager/presentation/markdown/md_provider.dart';
import 'package:good_manager/presentation/pages/help_content.dart';

class MarkdownBundle {
  const MarkdownBundle({
    required this.whatNews,
    required this.helpStores,
    required this.helpGoods,
    required this.helpDocuments,
    required this.helpSupplierCustomers,
    required this.helpPayments,
    required this.helpMinQuan,
  });

  final String whatNews;
  final String helpStores;
  final String helpGoods;
  final String helpDocuments;
  final String helpSupplierCustomers;
  final String helpPayments;
  final String helpMinQuan;
}

class MDProviderFromBundle extends MDProvider {
  MDProviderFromBundle(this.bundle);

  final MarkdownBundle bundle;

  @override
  String getHelpText(HelpType type) {
    switch (type) {
      case HelpType.STORE:
        return bundle.helpStores;
      case HelpType.GOODS:
        return bundle.helpGoods;
      case HelpType.DOCUMENTS:
        return bundle.helpDocuments;
      case HelpType.SUPPLIER_AND_CUSTOMER:
        return bundle.helpSupplierCustomers;
      case HelpType.PAYMENTS:
        return bundle.helpPayments;
      case HelpType.MIN_QUAN:
        return bundle.helpMinQuan;
    }
  }

  @override
  String getWhatNews() => bundle.whatNews;
}
