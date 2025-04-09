import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/good.dart';
import '../../../../domain/usecases/customers/customers_usecases.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';
import '../../base/base_state.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final Storage storage;
  final GoodsUseCases goodsUseCases;
  final DocumentUseCases documentsUseCases;
  final SuppliersUseCase supplierUseCases;
  final CustomersUseCase customerUseCase;
  HomeCubit({
    required this.storage,
    required this.goodsUseCases,
    required this.documentsUseCases,
    required this.supplierUseCases,
    required this.customerUseCase,
  }) : super(HomeState.initial(state: InitialState()));

  void initState() async{
      int storeId = storage.getSelectedStoreId();
      List<Good> goods = await goodsUseCases.getAllByStoreId(storeId);
      int countSupplier = await supplierUseCases.getCount(storeId);
      int countCustomer = await customerUseCase.getCount(storeId);

      List<Document> documents = await documentsUseCases.getAllByStoreId(storeId);
      int countIncomingDocument = 0;
      int countOutgoingDocument = 0;
      double sumPriceIncomingDocument = 0.0;
      double sumPriceOutgoingDocument = 0.0;
      for (Document item in documents){
        if (item.type == DocumentType.incoming){
          countIncomingDocument++;
          sumPriceIncomingDocument+= item.amount;
        }else{
          countOutgoingDocument++;
          sumPriceOutgoingDocument+= item.amount;
        }
      }
      double quantityTotal = 0;
      for (Good good in goods){
        quantityTotal += good.quantity;
      }

      emit(state.copyWith(
        countGoods: goods.length,
          quantityTotal: quantityTotal,
          countIncomingDocument: countIncomingDocument,
          sumPriceIncomingDocument: sumPriceIncomingDocument,
          countOutgoingDocument: countOutgoingDocument,
          sumPriceOutgoingDocument : sumPriceOutgoingDocument,
          countSupplier: countSupplier,
          countCustomer: countCustomer,
      ));
  }

}
