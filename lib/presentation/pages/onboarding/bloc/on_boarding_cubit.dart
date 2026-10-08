import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';

part 'on_boarding_cubit.freezed.dart';
part 'on_boarding_state.dart';

@injectable
class OnBoardingCubit extends Cubit<OnBoardingState> {
  final StoresUseCase useCase;

  OnBoardingCubit({required this.useCase})
      : super(const OnBoardingState.initial());

  void onAddStore() async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        exceptionError: '',
      ),
    );
    try {
      final name = _resolvedStoreName();
      Store store = Store();
      store.name = name;
      store.description = "";
      final storeId = await useCase.insert(store);
      if (isClosed) return;
      AppSettings.setSelectedStoreId(storeId);
      AppSettings.setSelectedStoreName(name);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          exceptionError: error.toString(),
        ),
      );
    }
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
  }

  String _resolvedStoreName() {
    final name = state.name.trim();
    if (name.isEmpty || name == 'main store') {
      return 'default_store_name'.tr();
    }
    return name;
  }
}
