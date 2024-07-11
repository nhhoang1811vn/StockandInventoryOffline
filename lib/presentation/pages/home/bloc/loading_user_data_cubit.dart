import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/domain/usecases/stores/stores_usecases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

part 'loading_user_data_cubit.freezed.dart';
part 'loading_user_data_state.dart';


@injectable
class LoadingUserDataCubit extends Cubit<LoadingUserDataState> {
  final StoresUseCase useCase;
  final Storage storage;
  LoadingUserDataCubit({required this.useCase, required this.storage}) : super(LoadingUserDataState.initial(state: InitialState()));


  Future<bool> checkStore() async{
    final stores = await useCase.getAll();
    return Future.value(stores.isNotEmpty);
  }
  Future<void> updateSelectedStore() async {
    final storeId = storage.getSelectedStoreId();
    final stores = await useCase.getAll();
    var matched = false;
    for (var store in stores){
      if (storeId != -1 && storeId == store.id){
         matched = true;
         break;
      }
    }
    if (!matched){
      storage.setSelectedStoreId(stores.first.id!);
      storage.setSelectedStoreName(stores.first.name);
    }
  }
}