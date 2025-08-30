import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:good_manager/core/services/notification_service.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/wallet_card.dart';
import 'package:good_manager/presentation/pages/payment/components/payment_item_row.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../core/services/low_stock_service.dart';
import '../../../di/di.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../base/base_state.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onOpenGoodsPage;
  final VoidCallback onOpenDocumentsPage;
  final VoidCallback onOpenPaymentsPage;

  HomePage({
    required this.onOpenGoodsPage,
    required this.onOpenDocumentsPage,
    required this.onOpenPaymentsPage,
  }) : super();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().initState();
    var isShowLowStockAlert = context.read<HomeCubit>().isShowLowStockAlert();
    if (isShowLowStockAlert) {
      _requestPermissions();
      _checkLowStockAndShowAlert();
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> _checkLowStockAndShowAlert() async {
    final lowStockService = getIt<LowStockService>();
    final hasLowStock = await lowStockService.hasLowStock();

    if (hasLowStock && context.mounted) {
      NotificationService.showNotification(
        id: 0,
        title: AppLocalizations.of(context)!.notification_low_stock_alert_title,
        body:
            AppLocalizations.of(context)!.notification_low_stock_alert_message,
        payload: "reorder",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is OpenSaveWalletPageState) {
          final currentState = state.state as OpenSaveWalletPageState;
          Navigator.of(context).pushNamed(
            Pages.save_wallet,
            arguments: {
              'item': currentState.item,
            },
          ).then((value) => context.read<HomeCubit>().initState());
        } else if (state.state is OpenBuySubscriptionDialogState) {
          showBuySubscriptionDialog(
            context,
            message: sprintf(
              AppLocalizations.of(context)!.buy_subscription_to_add_more_entity,
              [FreeLimits.walletLimit],
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: LogoAppBar(),
        body: _buildContent(state),
      ),
    );
  }

  double iconSize = 20;

  Widget _buildContent(HomeState state) {
    List<Widget> children = [
      SelectedStoreView(),
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildGoods(state),
            SizedBox(height: 16),
            _buildDocuments(state),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSingleValueCard(
                    AppLocalizations.of(context)!.suppliers_title,
                    state.countSupplier.toString(),
                    UIConstants.supplierIconData,
                    openSuppliers,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSingleValueCard(
                    AppLocalizations.of(context)!.customers_title,
                    state.countCustomer.toString(),
                    UIConstants.customerIconData,
                    openCustomers,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSingleValueCard(
                    AppLocalizations.of(context)!.payments_title,
                    "",
                    UIConstants.paymentIconData,
                    widget.onOpenPaymentsPage,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSingleValueCard(
                    AppLocalizations.of(context)!.report_title,
                    "",
                    UIConstants.reportIconData,
                    openReport,
                  ),
                ),
              ],
            ),
            //SizedBox(height: 16),
            //SaleReportWidget(),
            SizedBox(height: 16),
            _walletsCard(context, state),
          ],
        ),
      ),
    ];
    return SingleChildScrollView(child: Column(children: children));
  }

  Widget _buildGoods(HomeState state) {
    return Card(
      child: InkWell(
        onTap: widget.onOpenGoodsPage,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.goods_title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      AppLocalizations.of(context)!.title_good_count +
                          ": ${state.countGoods}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      AppLocalizations.of(context)!.title_total_quantity +
                          ": ${StringUtils.getQuantityText(state.quantityTotal)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                UIConstants.goodIconData,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocuments(HomeState state) {
    return Card(
      child: InkWell(
        onTap: widget.onOpenDocumentsPage,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.documents_title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: state.incomingColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .incoming_document_text,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          "${state.countIncomingDocument}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          "${Config.currencyFormat.format(state.sumPriceIncomingDocument)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 32,
                            ),
                            Expanded(
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: state.outgoingColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .outgoing_document_text,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          "${state.countOutgoingDocument}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          "${Config.currencyFormat.format(state.sumPriceOutgoingDocument)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    UIConstants.documentIconData,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: openSaveIncomingDocument,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wrap content
                        children: [
                          Icon(Icons.add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!
                                .incoming_document_text,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: openSaveOutgoingDocument,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Wrap content
                        children: [
                          Icon(Icons.remove, size: 20),
                          SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!
                                .outgoing_document_text,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openSaveIncomingDocument() async {
    int storeId = context.read<HomeCubit>().getSelectedStoreId();
    String autoDocumentNo = context.read<HomeCubit>().getAutoDocumentNo();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.incoming;
    item.name = AppLocalizations.of(context)!.document_name_no + autoDocumentNo;
    Navigator.of(context).pushNamed(
      Pages.save_document,
      arguments: {
        'item': item,
      },
    ).then((value) => context.read<HomeCubit>().initState());
  }

  void openSaveOutgoingDocument() async {
    int storeId = context.read<HomeCubit>().getSelectedStoreId();
    String autoDocumentNo = context.read<HomeCubit>().getAutoDocumentNo();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.outgoing;
    item.name = AppLocalizations.of(context)!.document_name_no + autoDocumentNo;
    Navigator.of(context).pushNamed(
      Pages.save_document,
      arguments: {
        'item': item,
      },
    ).then((value) => context.read<HomeCubit>().initState());
  }

  void openSuppliers() {
    Navigator.of(context)
        .pushNamed(Pages.supplier_list)
        .then((value) => context.read<HomeCubit>().initState());
    ;
  }

  void openCustomers() {
    Navigator.of(context)
        .pushNamed(Pages.customer_list)
        .then((value) => context.read<HomeCubit>().initState());
    ;
  }

  void openReport() {
    Navigator.of(context).pushNamed(Pages.report);
  }

  Widget _buildSingleValueCard(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      height: 4,
                    ),
                    Text(value, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Icon(
                icon,
                size: iconSize,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _walletsCard(BuildContext context, HomeState state) {
    final double cardHeight = 160;
    final double overlap = 50;
    final int walletCount = state.wallets.length;
    final double totalHeight =
        walletCount > 0 ? cardHeight + overlap * (walletCount - 1) + 20 : 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.title_wallet,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Icon(
                  UIConstants.walletIconData,
                  size: iconSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Config.simpleCurrencyFormat.format(state.totalBalance)}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(AppLocalizations.of(context)!.total_balance),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.read<HomeCubit>().onAddWalletClicked();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Wrap content
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.action_add_wallet,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: totalHeight,
              child: Stack(
                children: List.generate(state.wallets.length, (index) {
                  final wallet = state.wallets[index];
                  return AnimatedPositioned(
                    key: ValueKey(wallet.id),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    top: overlap * (state.wallets.length - index - 1),
                    child: GestureDetector(
                      onTap: () {
                        context.read<HomeCubit>().onWalletTapped(index);
                      },
                      child: WalletCard(wallet: wallet),
                    ),
                  );
                }),
              ),
            ),
            if (state.payments.isNotEmpty)
              Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Recent Payments",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Column(
                    children: state.payments.map((payment) {
                      return PaymentItemRow(
                        payment,
                        ColorUtils.getItemBgColor1(context),
                        (item) {},
                        (item) {},
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
