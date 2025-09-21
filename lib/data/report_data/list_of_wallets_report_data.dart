import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/util/util.dart';

import '../../domain/entity/payment.dart';
import '../../domain/entity/wallet.dart';
import '../app_settings.dart';

class ListOfWalletsReportData extends ReportData{

  final DateTime start;
  final DateTime end;
  final WalletUseCases walletUseCases;
  final PaymentUseCases paymentUseCases;

  ListOfWalletsReportData(
      {required this.start,
        required this.end,
        required this.walletUseCases,
        required this.paymentUseCases
      });


  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("label_wallet_name"),
      ColumnInfo("field_start_period", showTotal: true),
      ColumnInfo("field_in", showTotal: true),
      ColumnInfo("field_out", showTotal: true),
      ColumnInfo("field_end_period", showTotal: true),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async{
    List<MapEntry<int, List<String>>> results = [];
    int storeId = AppSettings.getSelectedStoreId();
    List<Wallet> wallets = await walletUseCases.getAllByStoreId(storeId);
    for (Wallet wallet in wallets) {
      List<Payment> prePayments = await paymentUseCases.getInRangeByWalletId(
        wallet.id!,
        DateTime.fromMillisecondsSinceEpoch(0),
        start.endOfYesterday(),
      );
      List<Payment> payments = await paymentUseCases.getInRangeByWalletId(
        wallet.id!,
        start,
        end,
      );

      double preRev = getRevenue(prePayments);
      double inAmount = payments
          .where((payment) => payment.type == PaymentType.inbound)
          .toList()
          .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));
      double outAmount = payments
          .where((payment) => payment.type == PaymentType.outbound)
          .toList()
          .fold(0.0, (sum, payment) => sum + (payment.amount ?? 0.0));

      results.add(MapEntry(wallet.id!, [
        wallet.name,
        getDoubleText(preRev),
        getDoubleText(inAmount),
        getDoubleText(outAmount),
        getDoubleText(preRev + inAmount - outAmount),
      ]));
    }
    return results;
  }

}