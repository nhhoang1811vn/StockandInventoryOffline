import 'package:good_manager/presentation/markdown/md_provider.dart';
import 'package:good_manager/presentation/markdown/md_resource_en.dart';
import 'package:good_manager/presentation/pages/help_content.dart';

class MDProviderIpmEN extends MDProvider{
  @override
  String getHelpText(HelpType type) {
    switch(type){
      case HelpType.STORE:
        return MarkdownResourceEN.helpStores;
      case HelpType.GOODS:
        return MarkdownResourceEN.helpGoods;
      case HelpType.DOCUMENTS:
        return MarkdownResourceEN.helpDocuments;
      case HelpType.SUPPLIER_AND_CUSTOMER:
        return MarkdownResourceEN.helpSupplierCustomers;
      case HelpType.PAYMENTS:
        return MarkdownResourceEN.helpPayments;
      default:
        return '';
    }
  }

  @override
  String getWhatNews() {
    return MarkdownResourceEN.whatNews;
  }
  @override
  String getDonationText() {
    return MarkdownResourceEN.donationText;
  }
}