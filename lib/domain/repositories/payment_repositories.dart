import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class PaymentRepository
    extends BaseRepository<Payment> {
  Future<List<Payment>> getByDocumentId(int documentId);
}
