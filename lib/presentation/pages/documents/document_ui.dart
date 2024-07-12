import '../../../domain/entities/document.dart';

enum DocumentUIType{
  date,
  data
}
class DocumentUI{
  final DocumentUIType type;
  final String dateText;
  final Document? document;
  DocumentUI(this.type, this.dateText, this.document);
}