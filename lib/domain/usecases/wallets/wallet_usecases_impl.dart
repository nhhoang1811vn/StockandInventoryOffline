import 'dart:async';

import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/repositories/wallet_repositories.dart';
import 'package:good_manager/domain/usecases/wallets/wallet_usecases.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WalletUseCases)
class WalletUseCasesImpl implements WalletUseCases{
  final WalletRepository repository;

  WalletUseCasesImpl({required this.repository});
  @override
  Future<int> insert(Wallet item) {
    return repository.insert(item);
  }
  @override
  Future<bool> update(Wallet item) {
    return repository.update(item);
  }

  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<List<Wallet>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<Wallet>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

}