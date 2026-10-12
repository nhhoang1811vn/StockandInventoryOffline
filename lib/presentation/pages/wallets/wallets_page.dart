import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/wallets/components/wallet_item_row.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../pages.dart';
import 'bloc/wallets_cubit.dart';
import 'bloc/wallets_state.dart';

class WalletsPage extends StatefulWidget {
  @override
  WalletsPageState createState() => WalletsPageState();
}

class WalletsPageState extends State<WalletsPage> {
  final FocusNode searchTextFocusNode = FocusNode();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    context.read<WalletsCubit>().initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<WalletsCubit, WalletsState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is OpenSaveWalletPageState) {
          final currentState = state.state as OpenSaveWalletPageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_wallet,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<WalletsCubit>().loadItems();
          }
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: SafeArea(child: _buildBody(state)),
      ),
    );
  }

  AppBar _buildAppBar(WalletsState state) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        context.tr("title_wallet"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.read<WalletsCubit>().onAddButtonClicked(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(WalletsState state) {
    if (state.state is LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = _filterWallets(state.items);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              setState(() => _searchText = newValue);
            },
            focusNode: searchTextFocusNode,
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? _buildEmpty(noResults: _searchText.trim().isNotEmpty)
              : _buildListView(items),
        ),
        _buildSummary(items),
      ],
    );
  }

  Widget _buildSummary(List<Wallet> items) {
    final total = items.fold<double>(0, (sum, item) => sum + item.balance);
    return SummaryLine([
      SummaryLine.item(context.tr("title_wallet"), items.length.toString()),
      SummaryLine.item(
        context.tr("total_balance"),
        CurrencyFormatter.format(context, total),
      ),
    ]);
  }

  List<Wallet> _filterWallets(List<Wallet> items) {
    final query = _searchText.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.number.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildListView(List<Wallet> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final wallet = items[index];
        return GestureDetector(
          onTap: () => _handleOnPressed(wallet),
          onLongPress: () => _handleOnLongPressed(wallet),
          child: WalletItemRow(wallet),
        );
      },
    );
  }

  Widget _buildEmpty({required bool noResults}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            noResults ? Icons.search_off : UIConstants.walletIconData,
            size: 64,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(noResults ? "no_results_found" : "title_wallet"),
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }

  void _handleOnPressed(Wallet item) {
    context.read<WalletsCubit>().onEditClicked(item);
  }

  void _handleOnLongPressed(Wallet item) {
    showSelectOptionDialog(
      context,
      items: [context.tr("delete")],
      onItemSelected: (index) {
        showDeleteConfirmPopup(item);
      },
    );
  }

  void showDeleteConfirmPopup(Wallet item) async {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [item.name],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        await context.read<WalletsCubit>().delete(item.id!);
      },
    );
  }
}
