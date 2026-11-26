import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/common/platform_support.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/base/insufficient_stock_message.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/home_online_app_promo.dart';
import 'package:good_manager/presentation/pages/home/home_store_header.dart';
import 'package:good_manager/presentation/pages/home/home_wallets_section.dart';
import 'package:good_manager/presentation/pages/home/home_windows_banner.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../../util/base64_utils.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../utils.dart';
import '../base/base_state.dart';
import '../documents/components/document_item_row.dart';
import '../main/main_page.dart';
import '../pages.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onOpenGoodsPage;
  final VoidCallback onOpenDocumentsPage;

  HomePage({
    required this.onOpenGoodsPage,
    required this.onOpenDocumentsPage,
  }) : super();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const double _cardGap = Dimens.cardGap;
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().initState();
    RevenueCatService.isPro();
    _maybeShowOnlineAppPopup();
  }

  Future<void> _maybeShowOnlineAppPopup() async {
    if (!isMobilePlatform) return;
    final prefs = await SharedPreferences.getInstance();
    if (!await OnlineAppPromo.shouldShowPopup(prefs)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showOnlineAppDialog(context);
    });
  }

  void _openOnlineAppStore() => NavigatorUtils.openUrl(
        Platform.isAndroid ? Config.onlineAppAndroidUrl : Config.onlineAppIosUrl,
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is InsufficientStockError) {
          ToastUtils.showErrorToast(insufficientStockMessage(
            (state.state as InsufficientStockError).error,
            AppSettings.getQuantityDecimals(),
            context.tr,
          ));
        } else if (state.state is OpenSaveWalletPageState) {
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state),
                const SizedBox(height: 16),
                _buildSearchRow(),
                const SizedBox(height: _cardGap),
                _buildStatsRow(state),
                const SizedBox(height: _cardGap),
                _buildDocumentsEntry(state),
                const SizedBox(height: _cardGap),
                _buildAddDocumentOptions(state),
                const SizedBox(height: _cardGap),
                _buildAddPaymentOptions(),
                const SizedBox(height: _cardGap),
                if (state.isLoadingRecentDocuments ||
                    state.recentDocuments.isNotEmpty) ...[
                  _buildRecentDocumentsHeader(),
                  const SizedBox(height: _cardGap),
                  if (state.isLoadingRecentDocuments)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    _buildRecentDocumentsList(state),
                  const SizedBox(height: _cardGap),
                ],
                _buildPartnersSection(state),
                const SizedBox(height: _cardGap),
                HomeWalletsSection(
                  wallets: state.wallets,
                  selectedWalletId: state.selectedWalletId,
                  totalBalance: state.totalBalance,
                  payments: state.payments,
                  isLoading: state.isLoadingWallets,
                  onWalletSelected: (id) =>
                      context.read<HomeCubit>().selectWallet(id),
                  onAddWallet: () =>
                      context.read<HomeCubit>().onAddWalletClicked(),
                  onOpenWalletsPage: () {
                    Navigator.of(context).pushNamed(Pages.wallet_list);
                  },
                  onOpenPaymentsPage: () {
                    Navigator.of(context).pushNamed(
                      Pages.payments,
                      arguments: {"setting": null, "initialIndex": 0},
                    );
                  },
                ),
                // The Online app and the Windows version only matter to
                // Android/iOS users (store links).
                if (isMobilePlatform) ...[
                  const SizedBox(height: _cardGap),
                  HomeOnlineAppCard(
                    title: context.tr("v2_announcement_title"),
                    subtitle: context.tr("v2_announcement_subtitle"),
                    downloadLabel: context.tr("download_now"),
                    hint: context.tr("tap_to_learn_new_features"),
                    onTap: () => showOnlineAppDialog(context),
                    onDownload: _openOnlineAppStore,
                  ),
                  const SizedBox(height: _cardGap),
                  HomeWindowsBanner(
                    title: context.tr("windows_banner_title"),
                    message: context.tr("windows_banner_message"),
                    downloadLabel: context.tr("windows_banner_download"),
                    guideLabel: context.tr("windows_banner_guide"),
                    onDownload: () =>
                        NavigatorUtils.openUrl(Config.windowsReleaseUrl),
                    onGuide: () =>
                        NavigatorUtils.openUrl(Config.windowsGuideUrl),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onChangeStore() async {
    final result = await Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": true});
    if (result != null && context.mounted) {
      Store store = result as Store;
      AppSettings.setSelectedStoreId(store.id!);
      AppSettings.setSelectedStoreName(store.name);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildHeader(HomeState state) {
    final store = state.selectedStore;
    final storeName = store?.name ?? AppSettings.getSelectedStoreName();
    final Uint8List? storeLogoBytes = tryDecodeBase64(store?.file);

    return ValueListenableBuilder<bool>(
      valueListenable: RevenueCatService.proNotifier,
      builder: (context, isPro, _) => HomeStoreHeader(
        storeName: storeName,
        logoBytes: storeLogoBytes,
        isPro: isPro,
        premiumLabel: context.tr("premium"),
        onTap: _onChangeStore,
      ),
    );
  }

  Widget _buildSearchRow() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Pages.search);
      },
      child: const AbsorbPointer(
        child: SearchBarWidget(),
      ),
    );
  }

  Widget _buildStatsRow(HomeState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            state.outOfStockCount.toString(),
            context.tr("out_of_stock"),
            Icons.shopping_basket_outlined,
            Theme.of(context).colorScheme.primary,
            onTap: () {
              Navigator.of(context).pushNamed(Pages.good_list_view, arguments: {
                'items': state.outOfStockGoods,
                'title': context.tr("out_of_stock"),
                'emptyIcon': Icons.shopping_basket_outlined,
              });
            },
          ),
        ),
        const SizedBox(width: _cardGap),
        if (state.showLowStock) ...[
          Expanded(
            child: _buildStatCard(
              state.lowStockCount.toString(),
              context.tr("low_stock"),
              Icons.show_chart,
              Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.of(context)
                    .pushNamed(Pages.good_list_view, arguments: {
                  'items': state.lowStockGoods,
                  'title': context.tr("low_stock"),
                  'emptyIcon': Icons.show_chart,
                });
              },
            ),
          ),
          const SizedBox(width: _cardGap),
        ],
        Expanded(
          child: _buildStatCard(
            state.countGoods.toString(),
            context.tr("total_items"),
            Icons.inventory_2_outlined,
            Theme.of(context).colorScheme.primary,
            onTap: widget.onOpenGoodsPage,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsEntry(HomeState state) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final radius = BorderRadius.circular(16);
    final incomingColor = state.incomingColor ?? Colors.red;
    final outgoingColor = state.outgoingColor ?? Colors.green;
    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: widget.onOpenDocumentsPage,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      UIConstants.documentIconData,
                      color: color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr("documents"),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    state.countDocuments.toString(),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ],
              ),
              const SizedBox(height: _cardGap),
              _buildDocumentSummaryRow(
                icon: Icons.file_download_outlined,
                color: incomingColor,
                label: context.tr("incoming"),
                count: state.countIncomingDocument,
                amount: state.sumPriceIncomingDocument,
                showAmount: AppSettings.getGoodPropertiesSettings()
                    .showPriceFor(DocumentType.incoming),
              ),
              const SizedBox(height: _cardGap),
              _buildDocumentSummaryRow(
                icon: Icons.file_upload_outlined,
                color: outgoingColor,
                label: context.tr("outgoing"),
                count: state.countOutgoingDocument,
                amount: state.sumPriceOutgoingDocument,
                showAmount: AppSettings.getGoodPropertiesSettings()
                    .showPriceFor(DocumentType.outgoing),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentSummaryRow({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
    required double amount,
    bool showAmount = true,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            "$label ($count)",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
        ),
        if (showAmount) ...[
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              CurrencyFormatter.format(context, amount),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPartnersSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr("person_name"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: _cardGap),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context.tr("suppliers"),
                UIConstants.supplierIconData,
                Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Pages.supplier_list)
                      .then((value) => context.read<HomeCubit>().initState());
                },
                value: state.countSupplier.toString(),
              ),
            ),
            const SizedBox(width: _cardGap),
            Expanded(
              child: _buildQuickActionCard(
                context.tr("customers"),
                UIConstants.customerIconData,
                Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Pages.customer_list)
                      .then((value) => context.read<HomeCubit>().initState());
                },
                value: state.countCustomer.toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
    String? value,
  }) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(16);
    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 12),
              if (value != null)
                Text(
                  "$label ($value)",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                )
              else
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentDocumentsHeader() {
    return Text(
      context.tr("recent_documents"),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildRecentDocumentsList(HomeState state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.recentDocuments.length,
      separatorBuilder: (context, index) => const SizedBox(height: _cardGap),
      itemBuilder: (context, index) {
        final item = state.recentDocuments[index];
        return DocumentItemRow(
          item: item,
          bgColor: Theme.of(context).colorScheme.surface,
          incomingColor: state.incomingColor ?? Colors.red,
          outgoingColor: state.outgoingColor ?? Colors.green,
          onDocumentTapped: (doc) {
            Navigator.of(context).pushNamed(
              Pages.save_document,
              arguments: {'item': doc},
            ).then((value) => context.read<HomeCubit>().initState());
          },
          onDocumentLongPressed: onLongPressedDocument,
          margin: EdgeInsets.zero,
        );
      },
    );
  }

  void onLongPressedDocument(Document item) {
    var status = Utils.getStatus(item);
    var showCreatePaymentOption = false;
    var showViewPaymentOption = false;
    if (status == DocumentPaidStatus.partial ||
        status == DocumentPaidStatus.unpaid) {
      showCreatePaymentOption = true;
    }
    if (status == DocumentPaidStatus.partial ||
        status == DocumentPaidStatus.paid) {
      showViewPaymentOption = true;
    }

    var items = [
      if (showViewPaymentOption) context.tr("action_view_payments"),
      if (showCreatePaymentOption) context.tr("action_create_payment"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("action_view_payments")) {
          await Navigator.of(context).pushNamed(
            Pages.payment_history,
            arguments: {"documentId": item.id},
          );
          if (!mounted) return;
          context.read<HomeCubit>().initState();
        } else if (items[index] == context.tr("action_create_payment")) {
          final payment =
              await context.read<HomeCubit>().createPaymentDraft(item);
          if (!mounted) return;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_payment,
            arguments: {"item": payment},
          );
          if (result != null && mounted) {
            context.read<HomeCubit>().initState();
          }
        } else if (items[index] == context.tr("delete")) {
          showDeleteDocumentConfirm(item);
        }
      },
    );
  }

  void showDeleteDocumentConfirm(Document document) {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [
          AppSettings.getDocumentPropertiesSettings()
              .displayName(document, context.tr)
        ],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        context.read<HomeCubit>().deleteDocument(document.id!);
      },
    );
  }

  Widget _buildAddDocumentOptions(HomeState state) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            context.tr("incoming"),
            Icons.file_download_outlined,
            state.incomingColor ?? Colors.red,
            onTap: () => _onAddDocumentWithType(DocumentType.incoming),
          ),
        ),
        const SizedBox(width: _cardGap),
        Expanded(
          child: _buildQuickActionCard(
            context.tr("outgoing"),
            Icons.file_upload_outlined,
            state.outgoingColor ?? Colors.green,
            onTap: () => _onAddDocumentWithType(DocumentType.outgoing),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPaymentOptions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            context.tr("title_inbound_payment"),
            Icons.call_received,
            Colors.green,
            onTap: () => _onAddPaymentWithType(PaymentType.inbound),
          ),
        ),
        const SizedBox(width: _cardGap),
        Expanded(
          child: _buildQuickActionCard(
            context.tr("title_outbound_payment"),
            Icons.call_made,
            Colors.red,
            onTap: () => _onAddPaymentWithType(PaymentType.outbound),
          ),
        ),
      ],
    );
  }

  void _onAddDocumentWithType(DocumentType type) async {
    int storeId = context.read<HomeCubit>().getSelectedStoreId();
    String autoDocumentNo = context.read<HomeCubit>().getAutoDocumentNo();
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = context.tr("document_name_no") + autoDocumentNo;
    await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: {'item': item});
    if (mounted) context.read<HomeCubit>().initState();
  }

  void _onAddPaymentWithType(PaymentType type) {
    final item = Payment();
    item.type = type;
    item.storeId = AppSettings.getSelectedStoreId();
    item.walletId = context.read<HomeCubit>().state.selectedWalletId ??
        AppSettings.getSavePaymentLastSelectedWalletId();
    Navigator.of(context).pushNamed(
      Pages.save_payment,
      arguments: {'item': item},
    ).then((value) => context.read<HomeCubit>().initState());
  }
}
