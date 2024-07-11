import 'package:good_manager/domain/entities/good_history.dart';

abstract class GoodHistoryUseCases{
  Future<List<GoodHistory>> getAll(int goodId);
  Future<List<GoodHistory>> getInRange(int goodId, DateTime start, DateTime end, );
}