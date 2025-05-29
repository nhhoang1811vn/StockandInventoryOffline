import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widgets/logo_app_bar.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../../domain/entities/document.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onOpenGoodsPage;
  final VoidCallback onOpenDocumentsPage;
  final VoidCallback onOpenPaymentsPage;

  HomePage(
      {required this.onOpenGoodsPage,
      required this.onOpenDocumentsPage,
      required this.onOpenPaymentsPage,
      required Key? key})
      : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {},
        builder: (context, state) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: LogoAppBar(),
              body: _buildContent(state),
            ));
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
                          openSuppliers)),
                  SizedBox(width: 16),
                  Expanded(
                      child: _buildSingleValueCard(
                          AppLocalizations.of(context)!.customers_title,
                          state.countCustomer.toString(),
                          UIConstants.customerIconData,
                          openCustomers)),
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
                  )),
                  SizedBox(width: 16),
                  Expanded(
                      child: _buildSingleValueCard(AppLocalizations.of(context)!.report_title, "",
                          UIConstants.reportIconData, openReport))
                ],
              ),
              //SizedBox(height: 16),
              //SaleReportWidget(),
              SizedBox(height: 16),
              _walletsCard(state)
            ],
          )),
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
                    Text(AppLocalizations.of(context)!.goods_title),//, style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      height: 4,
                    ),
                    Text(AppLocalizations.of(context)!.title_good_count + ": ${state.countGoods}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                        AppLocalizations.of(context)!.title_total_quantity +
                            ": ${Utils.getQuantityText(state.quantityTotal)}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                )),
                Icon(UIConstants.goodIconData, color: Theme.of(context).colorScheme.primary)
              ],
            ),
          ),
        ));
  }

  Widget _buildDocuments(HomeState state) {
    return Card(
        child: InkWell(
          onTap: widget.onOpenDocumentsPage,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.documents_title,
                          style: Theme.of(context).textTheme.titleMedium),
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
                                        color: Colors.red, // Change color as need,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.incoming_document_text,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text("${state.countIncomingDocument}",
                                          style: Theme.of(context).textTheme.titleMedium),
                                      Text("${Config.currencyFormat.format(state.sumPriceIncomingDocument)}",
                                          style: Theme.of(context).textTheme.titleMedium)
                                    ],
                                  )
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
                                        color: Colors.green, // Change color as need,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.outgoing_document_text,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Text("${state.countOutgoingDocument}",
                                          style: Theme.of(context).textTheme.titleMedium),
                                      Text("${Config.currencyFormat.format(state.sumPriceOutgoingDocument)}",
                                          style: Theme.of(context).textTheme.titleMedium)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  )),
                  Icon(
                    UIConstants.documentIconData,
                      color: Theme.of(context).colorScheme.primary
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                    onPressed: openSaveIncomingDocument,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wrap content
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.incoming_document_text,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: OutlinedButton(
                    onPressed: openSaveOutgoingDocument,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wrap content
                      children: [
                        Icon(Icons.remove, size: 20),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.outgoing_document_text,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )),
                ],
              )
            ]),
          ),
        ));
  }

  void openSaveIncomingDocument() async {
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.incoming;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    Navigator.of(context).pushNamed(Pages.save_document,
        arguments: {'item': item}).then((value) => context.read<HomeCubit>().initState());
  }

  void openSaveOutgoingDocument() async {
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = DocumentType.outgoing;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    Navigator.of(context).pushNamed(Pages.save_document,
        arguments: {'item': item}).then((value) => context.read<HomeCubit>().initState());
  }

  void openSuppliers() {
    Navigator.of(context).pushNamed(Pages.supplier_list).then((value) => context.read<HomeCubit>().initState());
    ;
  }

  void openCustomers() {
    Navigator.of(context).pushNamed(Pages.customer_list).then((value) => context.read<HomeCubit>().initState());
    ;
  }

  void openReport() {
    Navigator.of(context).pushNamed(Pages.report);
  }

  Widget _buildSingleValueCard(
      String title, String value, IconData icon, VoidCallback onTap) {
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
                )),
                Icon(icon, size: iconSize, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ));
  }

  Widget _walletsCard(HomeState state) {
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
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Icon(UIConstants.walletIconData, size: iconSize, color: Theme.of(context).colorScheme.primary),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${Config.simpleCurrencyFormat.format(state.totalBalance)}", style: Theme.of(context).textTheme.titleLarge),
                    Text(AppLocalizations.of(context)!.total_balance, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                )),
                OutlinedButton(
                  onPressed: () {
                    int storeId = storage.getSelectedStoreId();
                    Wallet item = Wallet();
                    item.color = Colors.blue.toARGB32();
                    item.storeId = storeId;
                    Navigator.of(context).pushNamed(Pages.save_wallet,
                        arguments: {'item': item}).then((value) => context.read<HomeCubit>().initState());
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                )
              ],
            ),
            SizedBox(height: 16),
            GridView.builder(
                itemCount: state.wallets.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.4, // Adjust height vs width
                ),
                itemBuilder: (context, index) {
                  return _walletCard(state.wallets[index]);
                })
          ],
        ),
      ),
    );
  }
  void _showWalletOptionsDialog(Wallet item) {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: (){
                  Navigator.pop(context);
                  context.read<HomeCubit>().deleteWallet(item);
                  context.read<HomeCubit>().initState();
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }
  Widget _walletCard(Wallet item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Color(item.color),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Pages.save_wallet,
              arguments: {'item': item}).then((value) => context.read<HomeCubit>().initState());
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(onPressed: (){
                    _showWalletOptionsDialog(item);
                  }, icon:  Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ))
                ],
              ),
              //SizedBox(height: 8),
              Text(Config.simpleCurrencyFormat.format(item.balance),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
