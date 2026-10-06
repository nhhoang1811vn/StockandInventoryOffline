import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'wallets_state.freezed.dart';

@freezed
class WalletsState with _$WalletsState {
  const factory WalletsState({
    required BaseState state,
    @Default([]) List<Wallet> items,
  }) = _WalletsState;

  factory WalletsState.initial() => WalletsState(
        state: InitialState(),
      );
}
