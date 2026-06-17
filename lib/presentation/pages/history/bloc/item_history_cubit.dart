import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/models/list_item.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/util/util.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../repo/repo.dart';

part 'item_history_cubit.freezed.dart';
part 'item_history_state.dart';

@injectable
class ItemHistoryCubit extends Cubit<ItemHistoryState> {
  final GoodHistoryUseCases useCases;
  final DocumentUseCases documentUseCases;
  final DocumentTransactionRepository documentTransactionRepository;

  ItemHistoryCubit({
    required this.useCases,
    required this.documentUseCases,
    required this.documentTransactionRepository,
  }) : super(ItemHistoryState.initial(state: InitialState()));

  void initState(int goodId, DateTime? start, DateTime? end) {
    emit(
      state.copyWith(
        goodId: goodId,
        start: start,
        end: end,
        incomingColor: AppSettings.getIncomingDocumentColor(),
        outgoingColor: AppSettings.getOutgoingDocumentColor(),
      ),
    );
    loadItems();
  }

  Future<void> loadItems() async {
    if (state.start == null) {
      var goodHistories = await useCases.getAll(state.goodId!);
      if (isClosed) return;
      emit(
        state.copyWith(
          goodHistories: goodHistories,
          items: getListItems(goodHistories),
        ),
      );
    } else {
      var goodHistories =
          await useCases.getInRange(state.goodId!, state.start!, state.end!);
      if (isClosed) return;
      emit(
        state.copyWith(
          goodHistories: goodHistories,
          items: getListItems(goodHistories),
        ),
      );
    }
    updateSummaryInfo();
  }

  void updateSummaryInfo() async {
    DateTime startDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
    DateTime endDateTime = DateTime.now();
    if (state.start != null) {
      startDateTime = state.start!;
    }
    if (state.end != null) {
      endDateTime = state.end!;
    }
    List<Document> documentsPrePeriod = await documentUseCases.getInRange(
      DateTime.fromMillisecondsSinceEpoch(0),
      startDateTime.endOfYesterday(),
    );
    double sumQuantityIncomingPre =
        await getSumQuantityIncoming(state.goodId!, documentsPrePeriod);
    double sumQuantityOutgoingPre =
        await getSumQuantityOutgoing(state.goodId!, documentsPrePeriod);
    double startPeriodQuantity =
        sumQuantityIncomingPre - sumQuantityOutgoingPre;

    List<Document> documentsInPeriod = await documentUseCases.getInRange(
      startDateTime.startOfDay(),
      endDateTime.endOfDay(),
    );
    double inQuantity =
        await getSumQuantityIncoming(state.goodId!, documentsInPeriod);
    double outQuantity =
        await getSumQuantityOutgoing(state.goodId!, documentsInPeriod);
    double endPeriodQuantity = startPeriodQuantity + inQuantity - outQuantity;

    if (isClosed) return;
    emit(
      state.copyWith(
        startPeriodQuantity: startPeriodQuantity,
        inQuantity: inQuantity,
        outQuantity: outQuantity,
        endPeriodQuantity: endPeriodQuantity,
      ),
    );
  }

  Future<double> getSumQuantityIncoming(
    int goodId,
    List<Document> documents,
  ) async {
    double incoming = 0.0;
    for (Document document in documents) {
      incoming += await documentTransactionRepository
          .getSumQuantityByGoodIdAndByDocumentId(
        DocumentType.incoming,
        goodId,
        document.id!,
      );
    }
    return incoming;
  }

  Future<double> getSumQuantityOutgoing(
    int goodId,
    List<Document> documents,
  ) async {
    double outgoing = 0.0;
    for (Document document in documents) {
      outgoing += await documentTransactionRepository
          .getSumQuantityByGoodIdAndByDocumentId(
        DocumentType.outgoing,
        goodId,
        document.id!,
      );
    }
    return outgoing;
  }

  List<ListItem> getListItems(List<GoodHistory> goodHistories) {
    List<ListItem> groupedList = [];
    // Sort by date if needed
    //payments.sort((a, b) => a.date.compareTo(b.date));
    DateTime? currentGroupDate;
    for (var goodHistory in goodHistories) {
      DateTime date = goodHistory.document!.date;
      if (currentGroupDate == null || currentGroupDate != date) {
        currentGroupDate = date;
        groupedList.add(HeaderItem(date));
      }
      groupedList.add(GoodHistoryListItem(goodHistory));
    }
    return groupedList;
  }
}
