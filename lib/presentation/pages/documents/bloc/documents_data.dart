import 'package:good_manager/presentation/pages/base/base_data.dart';

import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/documents_settings.dart';

class DocumentsData extends BaseData{
  final List<Document> items;
  final List<Document> incomingItems;
  final List<Document> outgoingItems;
  final bool showSearchBar;
  final String textSearch;
  final DocumentSettings settings;
  DocumentsData(super.state, this.items, this.incomingItems, this.outgoingItems, this.showSearchBar, this.textSearch, this.settings);

}