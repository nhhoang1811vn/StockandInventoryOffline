import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/usecase/stores/stores_usecases.dart';

part 'startup_state.dart';

/// Decides where the app goes after launch: Main when a Store exists,
/// Onboarding when none does. Reads local data only.
@injectable
class StartupCubit extends Cubit<StartupState> {
  final StoresUseCase useCase;

  StartupCubit(this.useCase) : super(StartupLoading());

  Future<void> load() async {
    emit(StartupLoading());
    try {
      final stores = await useCase.getAll();
      if (isClosed) return;
      if (stores.isEmpty) {
        emit(StartupNoStore());
        return;
      }
      final selectedId = AppSettings.getSelectedStoreId();
      final matched =
          selectedId != -1 && stores.any((store) => store.id == selectedId);
      if (!matched) {
        AppSettings.setSelectedStoreId(stores.first.id!);
        AppSettings.setSelectedStoreName(stores.first.name);
      }
      emit(StartupHasStore());
    } catch (_) {
      if (isClosed) return;
      emit(StartupFailure("startup_data_error".tr()));
    }
  }
}
