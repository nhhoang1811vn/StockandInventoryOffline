import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

abstract class DocumentRepository
    extends BaseCommonRepository<Document, DocumentSettings> {}
