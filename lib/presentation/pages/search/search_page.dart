import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/documents/components/document_item_row.dart';
import 'package:good_manager/presentation/pages/goods/good_item_row.dart';
import 'package:good_manager/presentation/pages/goods/group_item_row.dart';
import 'package:good_manager/presentation/pages/payment/components/payment_item_row.dart';
import 'package:good_manager/presentation/pages/wallets/components/wallet_item_row.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/presentation/widget/search_bar_widget.dart';
import 'package:sprintf/sprintf.dart';

import '../../../domain/entity/entity.dart';
import '../../dialog/dialog.dart';
import '../pages.dart';
import 'bloc/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    context.read<SearchCubit>().init();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SearchBarWidget(
                focusNode: _focusNode,
                onTextChanged: (text) {
                  context.read<SearchCubit>().onSearchTextChanged(text);
                },
              ),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildMessageState(
    BuildContext context,
    IconData icon,
    String message,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state.query.isEmpty) {
      return _buildMessageState(
        context,
        Icons.search,
        context.tr("type_to_search"),
      );
    }

    final hasResults = state.goods.isNotEmpty ||
        state.documents.isNotEmpty ||
        state.payments.isNotEmpty ||
        state.groups.isNotEmpty ||
        state.wallets.isNotEmpty;

    if (!hasResults) {
      return _buildMessageState(
        context,
        Icons.search_off,
        context.tr("no_results_found"),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.goods.isNotEmpty) ...[
          _buildSectionHeader(context, context.tr("goods")),
          ...state.goods.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GoodItemRow(
                  item: item,
                  quantity: item.quantity,
                  showBarcode: true,
                  showDescription: true,
                  showMinQuantity: true,
                  minQuantityColor: Colors.red,
                  onGoodTapped: (good) {
                    Navigator.of(context).pushNamed(
                      Pages.save_good,
                      arguments: {'item': good},
                    );
                  },
                  onGoodLongPressed: onLongPressedGood,
                  isSelection: false,
                ),
              )),
        ],
        if (state.documents.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("documents")),
          ...state.documents.map((item) => DocumentItemRow(
                item: item,
                bgColor: Theme.of(context).colorScheme.surface,
                incomingColor: state.incomingColor ?? Colors.red,
                outgoingColor: state.outgoingColor ?? Colors.green,
                onDocumentTapped: (doc) {
                  Navigator.of(context).pushNamed(
                    Pages.save_document,
                    arguments: {'item': doc},
                  );
                },
                onDocumentLongPressed: onLongPressedDocument,
              )),
        ],
        if (state.groups.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("groups")),
          ...state.groups.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GroupItemRow(
                  item,
                  (group) {
                    Navigator.of(context).pushNamed(
                      Pages.save_group,
                      arguments: {'item': group},
                    );
                  },
                  onLongPressedGroup,
                ),
              )),
        ],
        if (state.wallets.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("wallets")),
          ...state.wallets.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Pages.save_wallet,
                      arguments: {'item': item},
                    );
                  },
                  onLongPress: () => onLongPressedWallet(item),
                  child: WalletItemRow(item),
                ),
              )),
        ],
        if (state.payments.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("payments")),
          ...state.payments.map((item) => PaymentItemRow(
                item,
                Theme.of(context).colorScheme.surface,
                (payment) {
                  Navigator.of(context).pushNamed(
                    Pages.save_payment,
                    arguments: {'item': payment},
                  );
                },
                onLongPressedPayment,
              )),
        ],
      ],
    );
  }

  void onLongPressedGood(Good item) {
    if (item.id == null) return;
    final items = [
      context.tr("action_move_to_group"),
      context.tr("item_history_title"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("action_move_to_group")) {
          openSelectGroupForGood(item);
        } else if (items[index] == context.tr("item_history_title")) {
          Navigator.of(context)
              .pushNamed(Pages.good_history, arguments: {'goodId': item.id});
        } else if (items[index] == context.tr("delete")) {
          showDeleteConfirm(
            sprintf(context.tr("message_confirm_delete"), [item.name]),
            () => context.read<SearchCubit>().deleteGood(item.id!),
          );
        }
      },
    );
  }

  void openSelectGroupForGood(Good item) async {
    final result = await Navigator.of(context)
        .pushNamed(Pages.select_group, arguments: {"groupId": item.groupId});
    if (result == null || !mounted) return;
    final map = result as Map<dynamic, dynamic>;
    final selectedGroupId = map["groupId"] as int?;
    if (item.groupId != selectedGroupId) {
      context.read<SearchCubit>().moveGoodToGroup(item, selectedGroupId);
    }
  }

  void onLongPressedGroup(Group item) {
    final items = [
      context.tr("action_move_to_group"),
      context.tr("action_edit_group"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("action_move_to_group")) {
          openSelectGroupForGroup(item);
        } else if (items[index] == context.tr("action_edit_group")) {
          await Navigator.of(context)
              .pushNamed(Pages.save_group, arguments: {"item": item});
          if (!mounted) return;
          context.read<SearchCubit>().init();
        } else if (items[index] == context.tr("delete")) {
          context.read<SearchCubit>().deleteGroup(item.id!);
        }
      },
    );
  }

  void openSelectGroupForGroup(Group item) async {
    final result = await Navigator.of(context).pushNamed(
      Pages.select_group,
      arguments: {"groupId": item.groupId, "id": item.id},
    );
    if (result == null || !mounted) return;
    final map = result as Map<dynamic, dynamic>;
    final selectedGroupId = map["groupId"] as int?;
    if (item.groupId != selectedGroupId) {
      context.read<SearchCubit>().moveGroupToGroup(item, selectedGroupId);
    }
  }

  void onLongPressedDocument(Document item) {
    final status = Utils.getStatus(item);
    final showCreatePaymentOption = status == DocumentPaidStatus.partial ||
        status == DocumentPaidStatus.unpaid;
    final showViewPaymentOption = status == DocumentPaidStatus.partial ||
        status == DocumentPaidStatus.paid;

    final items = [
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
          context.read<SearchCubit>().init();
        } else if (items[index] == context.tr("action_create_payment")) {
          final payment =
              await context.read<SearchCubit>().createPaymentDraft(item);
          if (!mounted) return;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_payment,
            arguments: {"item": payment},
          );
          if (result != null && mounted) {
            context.read<SearchCubit>().init();
          }
        } else if (items[index] == context.tr("delete")) {
          showDeleteConfirm(
            sprintf(context.tr("message_confirm_delete"), [item.name]),
            () => context.read<SearchCubit>().deleteDocument(item.id!),
          );
        }
      },
    );
  }

  void onLongPressedWallet(Wallet item) {
    showSelectOptionDialog(
      context,
      items: [context.tr("delete")],
      onItemSelected: (index) {
        showDeleteConfirm(
          sprintf(context.tr("message_confirm_delete"), [item.name]),
          () => context.read<SearchCubit>().deleteWallet(item.id!),
        );
      },
    );
  }

  void onLongPressedPayment(Payment item) {
    showSelectOptionDialog(
      context,
      items: [context.tr("delete")],
      onItemSelected: (index) {
        showDeleteConfirm(
          context.tr("message_confirm_delete_no_args"),
          () => context.read<SearchCubit>().deletePayment(item.id!),
        );
      },
    );
  }

  void showDeleteConfirm(String message, VoidCallback onConfirm) {
    showCustomAlertDialog(
      context,
      message: message,
      onPositivePressed: () async {
        hideDialog(context);
        onConfirm();
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
