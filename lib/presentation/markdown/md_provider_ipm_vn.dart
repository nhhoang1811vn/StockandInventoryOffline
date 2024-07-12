import 'package:good_manager/presentation/markdown/md_provider.dart';
import 'package:good_manager/presentation/markdown/md_resource_vn.dart';
import 'package:good_manager/presentation/pages/help_content.dart';

class MDProviderIpmVN extends MDProvider{
  @override
  String getHelpText(HelpType type) {
    switch(type){
      case HelpType.STORE:
        return MarkdownResourceVN.helpStores;
      case HelpType.GOODS:
        return MarkdownResourceVN.helpGoods;
      case HelpType.DOCUMENTS:
        return MarkdownResourceVN.helpDocuments;
      case HelpType.EXPENSE:
        return MarkdownResourceVN.helpExpenses;
      case HelpType.SUPPLIER_AND_CUSTOMER:
        return MarkdownResourceVN.helpSupplierCustomers;
      default:
        return '';
    }
  }

  @override
  String getWhatNews() {
    return MarkdownResourceVN.whatNews;
  }
  @override
  String getDonationText() {
    return MarkdownResourceVN.donationText;
  }
}