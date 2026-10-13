import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/home_wallets_section.dart';
import 'package:good_manager/presentation/widget/widget.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../di/di.dart';
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
import '../settings/data/bloc/settings_data_cubit.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onOpenGoodsPage;
  final VoidCallback onOpenDocumentsPage;
  final VoidCallback onOpenMenuPage;

  HomePage({
    required this.onOpenGoodsPage,
    required this.onOpenDocumentsPage,
    required this.onOpenMenuPage,
  }) : super();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const double _cardGap = 12;
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
                const SizedBox(height: _cardGap),
                _buildAnnouncementCard(),
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
    final theme = Theme.of(context);
    final store = state.selectedStore;
    final storeName = store?.name ?? AppSettings.getSelectedStoreName();
    final Uint8List? storeLogoBytes = tryDecodeBase64(store?.file);

    final user = FirebaseAuth.instance.currentUser;
    String? photoUrl = user?.photoURL;
    if (user?.providerData.isNotEmpty == true) {
      photoUrl = user!.providerData.first.photoURL;
    }

    return Row(
      children: [
        GestureDetector(
          onTap: _onChangeStore,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.primary,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              backgroundImage:
                  storeLogoBytes != null ? MemoryImage(storeLogoBytes) : null,
              child: storeLogoBytes == null
                  ? Icon(
                      Icons.store_rounded,
                      color: theme.colorScheme.primary,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _onChangeStore,
            child: Text(
              storeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: widget.onOpenMenuPage,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Icon(Icons.person, size: 24, color: theme.colorScheme.primary)
                : null,
          ),
        ),
      ],
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
        Expanded(
          child: _buildStatCard(
            state.lowStockCount.toString(),
            context.tr("low_stock"),
            Icons.show_chart,
            Theme.of(context).colorScheme.primary,
            onTap: () {
              Navigator.of(context).pushNamed(Pages.good_list_view, arguments: {
                'items': state.lowStockGoods,
                'title': context.tr("low_stock"),
                'emptyIcon': Icons.show_chart,
              });
            },
          ),
        ),
        const SizedBox(width: _cardGap),
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
              ),
              const SizedBox(height: _cardGap),
              _buildDocumentSummaryRow(
                icon: Icons.file_upload_outlined,
                color: outgoingColor,
                label: context.tr("outgoing"),
                count: state.countOutgoingDocument,
                amount: state.sumPriceOutgoingDocument,
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
        [document.name],
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

  Widget _buildAnnouncementCard() {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showVersionInfoDialog(),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.rocket_launch, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr("v2_announcement_title"),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr("v2_announcement_subtitle"),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                context.tr("v2_migration_guide"),
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (isGuest) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.tr("guest_mode_sync_warning"),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: Colors.orange[900]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Pages.link_with);
                        },
                        child: Text(context.tr("login")),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr("step_1_sync_your_data"),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: isGuest ? null : () => onSyncDataPressed(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(context.tr("sync_data")),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr("step_2_download_new_app"),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              NavigatorUtils.openUrl(
                                "https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutteronline",
                              );
                            } else {
                              NavigatorUtils.openUrl(
                                "https://apps.apple.com/us/app/stock-inventory-online/id6761761103",
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(context.tr("download_now")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.tr("tap_to_learn_new_features"),
                style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarWhenFailureWithText(error));
    }
  }

  void _showVersionInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(context.tr("whats_new_v2_title")),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.tr("whats_new_v2_heading"),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildFeatureRow(
                  Icons.cloud, context.tr("v2_feature_online_mode")),
              _buildFeatureRow(Icons.sync, context.tr("v2_feature_realtime")),
              _buildFeatureRow(Icons.share, context.tr("v2_feature_sharing")),
              _buildFeatureRow(
                  Icons.manage_accounts, context.tr("v2_feature_roles")),
              _buildFeatureRow(
                  Icons.people, context.tr("v2_feature_multiuser")),
              _buildFeatureRow(
                  Icons.flash_on, context.tr("v2_feature_performance")),
              const Divider(height: 24),
              Text(context.tr("v2_migration_heading"),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildFeatureRow(
                  Icons.looks_one, context.tr("v2_migration_step_1")),
              _buildFeatureRow(
                  Icons.looks_two, context.tr("v2_migration_step_2")),
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
            child: Text(context.tr("skip"),
                style: const TextStyle(color: Colors.grey)),
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
          const SizedBox(width: 8),
          Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
