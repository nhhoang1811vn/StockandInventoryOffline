import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/domain/usecases/goods/goods_history_usecases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

part 'item_history_cubit.freezed.dart';
part 'item_history_state.dart';

@injectable
class ItemHistoryCubit extends Cubit<ItemHistoryState>{
  final GoodHistoryUseCases useCases;
  ItemHistoryCubit({
    required this.useCases
  }) : super(ItemHistoryState.initial(state: InitialState()));

  void initState(int goodId, DateTime? start, DateTime? end){
    emit(state.copyWith(goodId: goodId, start: start, end: end));
    loadItems();
  }
  loadItems() async{
    if (state.start == null){
      var items = await useCases.getAll(state.goodId!);
      emit(state.copyWith(items: items));
    }else{
      var items = await useCases.getInRange(state.goodId!, state.start!, state.end!);
      emit(state.copyWith(items: items));
    }
  }

}