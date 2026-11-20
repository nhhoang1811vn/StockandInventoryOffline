import 'package:good_manager/data/report_data/inbound_payments_report_data.dart';
import 'package:good_manager/data/report_data/list_of_customer_payment_report_data.dart';
import 'package:good_manager/data/report_data/list_of_documents_report_data.dart';
import 'package:good_manager/data/report_data/list_of_supplier_payment_report_data.dart';
import 'package:good_manager/data/report_data/list_of_wallets_report_data.dart';
import 'package:good_manager/data/report_data/outbound_payments_report_data.dart';
import 'package:good_manager/data/report_data/reorder_report_data.dart';
import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecase/customers/customers_usecases.dart';
import '../../../domain/usecase/documents/document_usecases.dart';
import '../../../domain/usecase/goods/goods_usercases.dart';
import '../../../domain/usecase/groups/groups_usecases.dart';
import '../../../domain/usecase/payment/payment_usercases.dart';
import '../../../domain/usecase/suppliers/suppliers_usecases.dart';
import '../../../domain/usecase/wallets/wallet_usecases.dart';
import '../../../repo/document_transactions_repository.dart';
import 'debt_of_customer_report_data.dart';
import 'debt_of_supplier_report_data.dart';
import 'good_info_report_data.dart';
import 'list_of_goods_report_data.dart';
import 'sales_by_customer_report_data.dart';
import 'sales_by_date_report_data.dart';
import 'sales_by_item_report_data.dart';
import 'sales_by_month_report_data.dart';

@LazySingleton()
class ReportDataFactory {
  final GoodsUseCases goodsUseCases;
  final GroupsUseCases groupsUseCases;
  final PaymentUseCases paymentUseCases;
  final DocumentUseCases documentUseCases;
  final DocumentTransactionRepository documentTransactionRepository;
  final SuppliersUseCase suppliersUseCase;
  final CustomersUseCase customersUseCase;
  final WalletUseCases walletUseCases;

  ReportDataFactory({
    required this.goodsUseCases,
    required this.groupsUseCases,
    required this.paymentUseCases,
    required this.documentUseCases,
    required this.documentTransactionRepository,
    required this.suppliersUseCase,
    required this.customersUseCase,
    required this.walletUseCases,
  });

  ReportData create(
    ReportType type,
    DateTime? start,
    DateTime? end, {
    int? groupId,
    int? customerId,
    int? supplierId,
  }) {
    switch (type) {
      case ReportType.LIST_OF_GOODS:
        return ListOfGoodsReportData(
            start: start!,
            end: end!,
            goodsUseCases: goodsUseCases,
            groupsUseCases: groupsUseCases,
            documentUseCases: documentUseCases,
            documentTransactionRepository: documentTransactionRepository);
      case ReportType.LIST_OF_DOCUMENT:
        return ListOfDocumentsReportData(
            start: start!, end: end!, documentUseCases: documentUseCases);
      case ReportType.DEBTS_BY_SUPPLIER:
        return DebtOfSupplierReportData(
            start: start!,
            end: end!,
            suppliersUseCase: suppliersUseCase,
            documentUseCases: documentUseCases);
      case ReportType.DEBTS_BY_CUSTOMER:
        return DebtOfCustomerReportData(
            start: start!,
            end: end!,
            customersUseCase: customersUseCase,
            documentUseCases: documentUseCases);
      case ReportType.INBOUND_PAYMENTS:
        return InboundPaymentsReportData(
            start: start!, end: end!, paymentUseCases: paymentUseCases);
      case ReportType.OUTBOUND_PAYMENTS:
        return OutboundPaymentsReportData(
            start: start!, end: end!, paymentUseCases: paymentUseCases);
      case ReportType.LIST_OF_WALLETS:
        return ListOfWalletsReportData(
            start: start!,
            end: end!,
            walletUseCases: walletUseCases,
            paymentUseCases: paymentUseCases);
      case ReportType.LIST_OF_CUSTOMER_PAYMENTS:
        return ListOfCustomerPaymentReportData(
            start: start!,
            end: end!,
            customersUseCase: customersUseCase,
            paymentUseCases: paymentUseCases);
      case ReportType.LIST_OF_SUPPLIER_PAYMENTS:
        return ListOfSupplierPaymentReportData(
            start: start!,
            end: end!,
            suppliersUseCase: suppliersUseCase,
            paymentUseCases: paymentUseCases);
      case ReportType.RE_ORDER:
        return ReorderReportData(goodsUseCase: goodsUseCases);
      case ReportType.GOOD_INFO:
        return GoodInfoReportData(goodsUseCases: goodsUseCases, groupsUseCases: groupsUseCases);
      case ReportType.SALES_BY_DATE:
      case ReportType.PURCHASE_BY_DATE:
        return SalesByDateReportData(
            start: start!,
            end: end!,
            type: _documentTypeOf(type),
            documentUseCases: documentUseCases,
            goodsUseCases: goodsUseCases);
      case ReportType.SALES_BY_ITEM:
      case ReportType.PURCHASE_BY_ITEM:
        return SalesByItemReportData(
            start: start!,
            end: end!,
            groupId: groupId,
            type: _documentTypeOf(type),
            documentUseCases: documentUseCases,
            goodsUseCases: goodsUseCases);
      case ReportType.SALES_BY_MONTH:
      case ReportType.PURCHASE_BY_MONTH:
        return SalesByMonthReportData(
            start: start!,
            end: end!,
            type: _documentTypeOf(type),
            documentUseCases: documentUseCases,
            goodsUseCases: goodsUseCases);
      case ReportType.SALES_BY_CUSTOMER:
      case ReportType.PURCHASE_BY_SUPPLIER:
        return SalesByCustomerReportData(
            start: start!,
            end: end!,
            personId: type == ReportType.SALES_BY_CUSTOMER
                ? customerId
                : supplierId,
            type: _documentTypeOf(type),
            documentUseCases: documentUseCases,
            customersUseCase: customersUseCase,
            suppliersUseCase: suppliersUseCase,
            goodsUseCases: goodsUseCases);
    }
  }

  /// Sales reports read outgoing Documents, Purchase reports incoming ones.
  DocumentType _documentTypeOf(ReportType type) {
    switch (type) {
      case ReportType.PURCHASE_BY_DATE:
      case ReportType.PURCHASE_BY_ITEM:
      case ReportType.PURCHASE_BY_SUPPLIER:
      case ReportType.PURCHASE_BY_MONTH:
        return DocumentType.incoming;
      default:
        return DocumentType.outgoing;
    }
  }
}
