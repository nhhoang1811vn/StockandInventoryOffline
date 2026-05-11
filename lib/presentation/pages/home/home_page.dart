import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/wallet_card.dart';
import 'package:good_manager/presentation/pages/payment/components/payment_item_row.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
import '../../../di/di.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../widget/snackbar_widgets.dart';
import '../base/base_state.dart';
import '../main/main_page.dart';
import '../pages.dart';
import '../settings/data/bloc/settings_data_cubit.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onOpenGoodsPage;
  final VoidCallback onOpenDocumentsPage;
  //final VoidCallback onOpenPaymentsPage;

  HomePage({
    required this.onOpenGoodsPage,
    required this.onOpenDocumentsPage,
    //required this.onOpenPaymentsPage,
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
    _checkShowVersionInfo();
  }

  void _checkShowVersionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    bool isSkipped = prefs.getBool('version_2_0_0_skipped') ?? false;
    if (isSkipped) return;

    int showCount = prefs.getInt('version_2_0_0_show_count') ?? 0;
    if (showCount < 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showVersionInfoDialog();
      });
      await prefs.setInt('version_2_0_0_show_count', showCount + 1);
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
              context.tr("buy_subscription_to_add_more_entity"),
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
      SelectedStoreView(canChange: true, onPressed: () async{
        final result = await Navigator.of(context)
            .pushNamed(Pages.store_list, arguments: {"isSelection": true});
        if (result != null) {
          Store store = result as Store;

          AppSettings.setSelectedStoreId(store.id!);
          AppSettings.setSelectedStoreName(store.name);

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
          );
        }
      },),
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
                    context.tr("suppliers"),
                    state.countSupplier.toString(),
                    UIConstants.supplierIconData,
                    openSuppliers,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSingleValueCard(
                    context.tr("customers"),
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
                    context.tr("payments_title"),
                    "",
                    UIConstants.paymentIconData,
                    openPayments,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSingleValueCard(
                    context.tr("report_title"),
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
            _buildAnnouncementCard(),
            SizedBox(height: 16),
            _walletsCard(context, state),
          ],
        ),
      ),
    ];
    return SingleChildScrollView(child: Column(children: children));
  }

  Widget _buildAnnouncementCard() {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () => _showVersionInfoDialog(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.rocket_launch, color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Version 2.0.0: Online Collaboration",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Multiple users can now work on the same store with real-time updates and sharing.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 12),
              Text(
                "Migration Guide:",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (isGuest) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "You are in Guest Mode. Please log in first to sync your data.",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.orange[900]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Pages.link_with);
                        },
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step 1: Sync your data",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: isGuest ? null : () => onSyncDataPressed(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Sync Data"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step 2: Download new app",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Join Closed Beta"),
                                  content: const Text(
                                    "Please send me your Gmail address so I can add you as a tester on Google Play.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        final Uri emailUri = Uri(
                                          scheme: 'mailto',
                                          path: 'nhhoang1811vn@gmail.com',
                                          query: Uri.encodeFull(
                                            'subject=Join Closed Beta Program&body=I want to join the Closed Beta program.',
                                          ),
                                        );

                                        await launchUrl(emailUri);
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            NavigatorUtils.openUrl(
                              "https://apps.apple.com/us/app/stock-inventory-online/id6761761103",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Download Now"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                "Tap to learn more about new features!",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSyncDataPressed() async {
    showProgressIndicator(context);
    final error = await getIt<SettingsDataCubit>().syncToRealtimeDB();
    hideDialog(context);
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWhenSuccess(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(error));
    }
  }

  void _showVersionInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("What's New in v2.0.0"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🚀 Major Update: Online Collaboration",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              _buildFeatureRow(Icons.cloud, "Introduced Online Mode powered by Firebase Realtime Database."),
              _buildFeatureRow(Icons.sync, "Real-time Updates – store data now syncs instantly across all devices."),
              _buildFeatureRow(Icons.share, "Store Sharing – go to 'Stores' and tap the Share button to invite others."),
              _buildFeatureRow(Icons.manage_accounts, "Role Management – assign members as Editor or Viewer."),
              _buildFeatureRow(Icons.people, "Multi-user Access – multiple users can work on the same store simultaneously."),
              _buildFeatureRow(Icons.flash_on, "Improved performance and synchronization reliability."),
              Divider(height: 24),
              Text("Instructions for Data Migration:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              _buildFeatureRow(Icons.looks_one, "Step 1: Sync your data to ensure everything is backed up online."),
              _buildFeatureRow(Icons.looks_two, "Step 2: Download the new 'Stock Inventory Online' app and log in."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('version_2_0_0_skipped', true);
              Navigator.pop(context);
            },
            child: Text(context.tr("skip"), style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr("ok")),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
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
                      context.tr("goods"),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      context.tr("title_good_count") +
                          ": ${state.countGoods}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      context.tr("title_total_quantity") +
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
                          context.tr("documents"),
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
                                          context.tr("incoming"),
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
                                          CurrencyFormatter.format(context, state.sumPriceIncomingDocument),
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
                                          context.tr("outgoing"),
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
                                          CurrencyFormatter.format(context, state.sumPriceOutgoingDocument),
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
                            context.tr("incoming"),
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
                            context.tr("outgoing"),
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
    item.name = context.tr("document_name_no") + autoDocumentNo;
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
    item.name = context.tr("document_name_no") + autoDocumentNo;
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
  void openPayments() {
    Navigator.of(context).pushNamed(Pages.payments,
      arguments: {"setting": null, "initialIndex": 0},
    );
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
                  context.tr("title_wallet"),
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
                        CurrencyFormatter.format(context, state.totalBalance),
                        //"${Config.currencyFormat.format(state.totalBalance)}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(context.tr("total_balance")),
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
                        context.tr("action_add_wallet"),
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
