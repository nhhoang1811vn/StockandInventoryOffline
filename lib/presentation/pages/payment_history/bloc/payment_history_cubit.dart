import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entity/entity.dart';

part 'payment_history_cubit.freezed.dart';
part 'payment_history_state.dart';

@injectable
class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final PaymentUseCases useCases;

  PaymentHistoryCubit({
    required this.useCases,
  }) : super(PaymentHistoryState.initial(state: InitialState()));

  void initState(int documentId) {
    emit(state.copyWith(documentId: documentId));
    loadItems();
  }

  Future<void> loadItems() async {
    var payments = await useCases.getByDocumentId(state.documentId!);
    if (isClosed) return;
    emit(state.copyWith(items: payments));
    updateSummaryInfo();
  }

  void updateSummaryInfo() async {
    // emit(state.copyWith(startPeriodQuantity: startPeriodQuantity, inQuantity: inQuantity, outQuantity: outQuantity, endPeriodQuantity: endPeriodQuantity));
  }
}
