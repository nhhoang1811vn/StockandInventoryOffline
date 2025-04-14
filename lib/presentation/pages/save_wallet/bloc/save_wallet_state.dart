part of 'save_wallet_cubit.dart';

@freezed
class SaveWalletState with _$SaveWalletState {
  const factory SaveWalletState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    Color? color,
    Wallet? item
  }) = _Initial;
}

