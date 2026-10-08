import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/free_limits.dart';
import '../../../../domain/usecase/usecase.dart';
import '../../../../util/util.dart';
import '../../base/base_state.dart';
import 'wallets_state.dart';

@injectable
class WalletsCubit extends Cubit<WalletsState> {
  final WalletUseCases walletUseCases;

  WalletsCubit({required this.walletUseCases}) : super(WalletsState.initial());

  void initState() {
    loadItems();
  }

  Future<void> loadItems() async {
    emit(state.copyWith(state: LoadingState()));
    final storeId = AppSettings.getSelectedStoreId();
    final items = await walletUseCases.getAllByStoreId(storeId);
    if (isClosed) return;
    emit(state.copyWith(
      state: LoadSuccessState(),
      items: items,
    ));
  }

  Future<void> delete(int id) async {
    await walletUseCases.delete(id);
    await loadItems();
  }

  Future<void> onAddButtonClicked() async {
    final storeId = AppSettings.getSelectedStoreId();
    int count = await walletUseCases.getCount(storeId);
    bool isPro = await RevenueCatService.isPro();
    if (isClosed) return;
    if (count < FreeLimits.walletLimit || isPro) {
      Wallet item = Wallet();
      item.color = 0xFF2196F3;
      item.storeId = storeId;
      emit(state.copyWith(state: OpenSaveWalletPageState(item)));
    } else {
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
    }
  }

  void onEditClicked(Wallet item) {
    emit(state.copyWith(state: OpenSaveWalletPageState(item)));
  }
}
