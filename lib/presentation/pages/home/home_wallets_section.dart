import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/util/currency_formatter.dart';

import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';
import '../pages.dart';
import '../payment/components/payment_item_row.dart';
import '../wallets/components/wallet_item_row.dart';

class HomeWalletsSection extends StatelessWidget {
  final List<Wallet> wallets;
  final int? selectedWalletId;
  final double totalBalance;
  final List<Payment> payments;
  final bool isLoading;
  final ValueChanged<int> onWalletSelected;
  final VoidCallback onAddWallet;
  final VoidCallback onOpenWalletsPage;
  final VoidCallback onOpenPaymentsPage;

  const HomeWalletsSection({
    super.key,
    required this.wallets,
    required this.selectedWalletId,
    required this.totalBalance,
    required this.payments,
    this.isLoading = false,
    required this.onWalletSelected,
    required this.onAddWallet,
    required this.onOpenWalletsPage,
    required this.onOpenPaymentsPage,
  });

  Wallet? get _selectedWallet {
    if (selectedWalletId == null) return null;
    for (final wallet in wallets) {
      if (wallet.id == selectedWalletId) return wallet;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 12),
        if (isLoading)
          _buildSectionLoading()
        else ...[
          _buildTotalBalance(context),
          const SizedBox(height: 16),
          if (wallets.isEmpty)
            _buildEmptyWallets(context)
          else ...[
            _buildWalletList(context),
            const SizedBox(height: 20),
            _buildPaymentsHeader(context),
            const SizedBox(height: 8),
            _buildPaymentsList(context),
          ],
        ],
      ],
    );
  }

  Widget _buildSectionLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.tr("title_wallet"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        GestureDetector(
          onTap: onOpenWalletsPage,
          child: Text(
            context.tr("view_all"),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalBalance(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.tr("total_balance"),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Text(
            CurrencyFormatter.format(context, totalBalance),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWallets(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: theme.colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr("title_wallet"),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              context.tr("action_add_wallet"),
              onAddWallet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wallets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return GestureDetector(
          onTap: () {
            if (wallet.id != null) {
              onWalletSelected(wallet.id!);
            }
          },
          child: WalletItemRow(
            wallet,
            isSelected: wallet.id == selectedWalletId,
          ),
        );
      },
    );
  }

  Widget _buildPaymentsHeader(BuildContext context) {
    final wallet = _selectedWallet;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            wallet != null
                ? "${context.tr("payments")} · ${wallet.name}"
                : context.tr("payments"),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onOpenPaymentsPage,
          child: Text(
            context.tr("view_all"),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsList(BuildContext context) {
    if (payments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          context.tr("empty_payment"),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      );
    }

    final recent = payments.take(5).toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final payment = recent[index];
        return PaymentItemRow(
          payment,
          Colors.transparent,
          (_) => Navigator.of(context).pushNamed(
            Pages.save_payment,
            arguments: {'item': payment},
          ),
          (_) {},
        );
      },
    );
  }
}
