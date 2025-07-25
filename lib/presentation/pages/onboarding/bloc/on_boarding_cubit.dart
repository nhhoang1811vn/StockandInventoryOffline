import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/usecases/stores/stores_usecases.dart';

part 'on_boarding_cubit.freezed.dart';
part 'on_boarding_state.dart';

@injectable
class OnBoardingCubit extends Cubit<OnBoardingState> {
  final StoresUseCase useCase;
  final AppSettings appSettings;
  OnBoardingCubit({required this.useCase, required this.appSettings}) : super(const OnBoardingState.initial());
  void onAddStore() async{
    try{
      Store store = Store();
      store.name = state.name;
      store.description = "";
      final storeId = await useCase.insert(store);
      //storage.setFirstTime(false);
      appSettings.setSelectedStoreId(storeId);
      appSettings.setSelectedStoreName(state.name);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    }catch(error){
      emit(state.copyWith(status: FormzSubmissionStatus.failure, exceptionError: error.toString()));
    }
  }
  void nameChanged(String value){
    emit(state.copyWith(name: value));
  }
}
