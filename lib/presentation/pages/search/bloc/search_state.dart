part of 'search_cubit.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial({
    required BaseState state,
    @Default("") String query,
    @Default([]) List<Good> goods,
    @Default([]) List<Document> documents,
    @Default([]) List<Payment> payments,
    @Default([]) List<Group> groups,
    @Default([]) List<Wallet> wallets,
    Color? incomingColor,
    Color? outgoingColor,
  }) = _Initial;
}
