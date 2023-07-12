/*
import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/general_infomation.dart';
import 'package:good_manager/domain/repositories/customer_repositories.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:good_manager/domain/repositories/expense_repositories.dart';
import 'package:good_manager/domain/repositories/goods_repositories.dart';
import 'package:good_manager/domain/repositories/stores_repositories.dart';
import 'package:good_manager/domain/repositories/suppliers_repositories.dart';

class GetGeneralInformationUseCase extends UseCase<GeneralInformation, void> {
  final StoresRepository storeRepository;
  final GoodsRepository goodRepository;
  final DocumentRepository documentRepository;
  final DocumentTransactionRepository transactionRepository;
  final SuppliersRepository supplierRepository;
  final CustomerRepository customerRepository;
  final ExpenseRepository expenseRepository;

  GetGeneralInformationUseCase(
      this.storeRepository,
      this.goodRepository,
      this.documentRepository,
      this.transactionRepository,
      this.supplierRepository,
      this.customerRepository,
      this.expenseRepository);

  @override
  Future<Stream<GeneralInformation>> buildUseCaseStream(void params) async {
    final StreamController<GeneralInformation> controller = StreamController();
    try {
      GeneralInformation item = GeneralInformation();
      int id = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
      item.storeName = (await storeRepository.get(id)).name;
      item.countGood = await goodRepository.getCount();
      item.quantityGood = await transactionRepository.getSumQuantity();
      item.countDocument = await documentRepository.getCount();
      //item.countSupplier = await supplierRepository.getCount();
      item.countCustomer = await customerRepository.getCount();
      item.sumExpense = await expenseRepository.getSum();
      controller.add(item);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}
*/
