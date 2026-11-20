import 'package:easy_localization/easy_localization.dart';
import 'package:good_manager/data/report_data/report_data.dart';

import '../../domain/entity/base_model.dart';
import '../../domain/entity/document.dart';
import '../../domain/entity/good.dart';
import '../../domain/usecase/customers/customers_usecases.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../../domain/usecase/goods/goods_usercases.dart';
import '../../domain/usecase/suppliers/suppliers_usecases.dart';
import '../app_settings.dart';
import 'column_info.dart';
import 'outgoing_sales_loader.dart';
import 'sales_by_customer_rows.dart';

/// Per-person report. For outgoing documents the persons are the store's
/// Customers (Sales by Customer); for incoming documents they are its
/// Suppliers (Purchase by Supplier, quantity and amount only).
class SalesByCustomerReportData extends ReportData {
  final DateTime start;
  final DateTime end;

  /// Customer or Supplier id depending on [type]; null means all persons
  /// (plus a "No customer" / "No supplier" row).
  final int? personId;
  final DocumentUseCases documentUseCases;
  final DocumentType type;
  final CustomersUseCase customersUseCase;
  final SuppliersUseCase suppliersUseCase;
  final GoodsUseCases goodsUseCases;

  SalesByCustomerReportData({
    required this.start,
    required this.end,
    required this.personId,
    required this.documentUseCases,
    this.type = DocumentType.outgoing,
    required this.customersUseCase,
    required this.suppliersUseCase,
    required this.goodsUseCases,
  });

  bool get _isSales => type == DocumentType.outgoing;

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo(_isSales ? "customer" : "supplier"),
      ColumnInfo("quantity", showTotal: true),
      ColumnInfo("amount", showTotal: true),
      if (_isSales) ...[
        ColumnInfo("cost", showTotal: true),
        ColumnInfo("profit", showTotal: true),
      ],
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    int storeId = AppSettings.getSelectedStoreId();
    final List<BaseModel> persons = _isSales
        ? await customersUseCase.getAllByStoreId(storeId)
        : await suppliersUseCase.getAllByStoreId(storeId);
    final List<Good> goods = await goodsUseCases.getAllByStoreId(storeId);
    final purchasePrices = <int, double?>{
      for (final good in goods)
        if (good.id != null) good.id!: good.purchasePrice,
    };
    final sales = await loadOutgoingSales(
      documentUseCases: documentUseCases,
      type: type,
      start: start,
      end: end,
    );
    return salesByCustomerTableRows(
      buildSalesByCustomerRows(
        type: type,
        customers: persons,
        documents: sales.documents,
        transactionsByDocumentId: sales.transactionsByDocumentId,
        purchasePriceByGoodId: purchasePrices,
        onlyCustomerId: personId,
      ),
      (_isSales ? 'no_customer' : 'no_supplier').tr(),
      withCost: _isSales,
    );
  }
}
