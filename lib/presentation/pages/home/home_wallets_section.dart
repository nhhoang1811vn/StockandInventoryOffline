import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:good_manager/util/dimen.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../pages.dart';

class HomeWalletsSection extends StatelessWidget {
  static const double _cardGap = Dimens.cardGap;
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
        _buildSectionTitle(
          context,
          title: context.tr("title_wallet"),
        ),
        const SizedBox(height: _cardGap),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          _buildTotalBalance(context),
          const SizedBox(height: _cardGap),
          if (wallets.isEmpty)
            _buildEmptyWallets(context)
          else ...[
            _buildWalletList(context),
            const SizedBox(height: _cardGap),
            _buildSectionTitle(
              context,
              title: _selectedWallet != null
                  ? "${context.tr("payments")} · ${_selectedWallet!.name}"
                  : context.tr("payments"),
              onViewAll: onOpenPaymentsPage,
            ),
            const SizedBox(height: _cardGap),
            _buildPaymentsList(context),
          ],
        ],
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    VoidCallback? onViewAll,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              context.tr("view_all"),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTotalBalance(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return _HomeRowCard(
      onTap: onOpenWalletsPage,
      icon: Icons.account_balance_wallet_outlined,
      iconColor: color,
      title: context.tr("total_balance"),
      trailing: Text(
        CurrencyFormatter.format(context, totalBalance),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(color: color),
      ),
      showChevron: true,
    );
  }

  Widget _buildEmptyWallets(BuildContext context) {
    final theme = Theme.of(context);
    return _HomeRowCard(
      onTap: onAddWallet,
      icon: Icons.account_balance_wallet_outlined,
      iconColor: theme.colorScheme.primary,
      title: context.tr("action_add_wallet"),
      showChevron: true,
    );
  }

  List<Wallet> _orderedWallets() {
    final selected = _selectedWallet;
    if (selected == null || wallets.length < 2) return wallets;
    return [
      ...wallets.where((wallet) => wallet.id != selected.id),
      selected,
    ];
  }

  Widget _buildWalletList(BuildContext context) {
    final items = _orderedWallets();
    const peek = 54.0;
    const frontHeight = 156.0;
    final height = peek * (items.length - 1) + frontHeight;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          for (var index = 0; index < items.length; index++)
            Positioned(
              top: peek * index,
              left: 0,
              right: 0,
              height: frontHeight,
              child: _WalletFaceCard(
                wallet: items[index],
                expanded: index == items.length - 1,
                onTap: () {
                  final id = items[index].id;
                  if (id != null) onWalletSelected(id);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList(BuildContext context) {
    if (payments.isEmpty) {
      final theme = Theme.of(context);
      return _HomeRowCard(
        icon: Icons.payments_outlined,
        iconColor: theme.colorScheme.primary,
        title: context.tr("empty_payment"),
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      );
    }

    final recent = payments.take(5).toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      separatorBuilder: (_, __) => const SizedBox(height: _cardGap),
      itemBuilder: (context, index) {
        final payment = recent[index];
        final isInbound = payment.type == PaymentType.inbound;
        final color = isInbound ? Colors.green : Colors.red;
        return _HomeRowCard(
          onTap: () => Navigator.of(context).pushNamed(
            Pages.save_payment,
            arguments: {'item': payment},
          ),
          badgeText: payment.category?.icon ?? "💰",
          iconColor: color,
          title: payment.category != null
              ? payment.category!.name
              : context.tr("no_category"),
          subtitle: _paymentSubtitle(context, payment),
          trailing: Text(
            "${isInbound ? "+" : "-"}${CurrencyFormatter.format(context, payment.amount ?? 0)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        );
      },
    );
  }

  String _paymentSubtitle(BuildContext context, Payment item) {
    final date = DateFormatFactory.getDateFormat().format(item.date);
    final person = item.customer?.name ?? item.supplier?.name ?? "";
    if (person.isEmpty) return date;
    return "$date · $person";
  }
}

class _WalletFaceCard extends StatelessWidget {
  static const double _peek = 54;

  final Wallet wallet;
  final bool expanded;
  final VoidCallback onTap;

  const _WalletFaceCard({
    required this.wallet,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _walletColor(wallet.color);
    final onColor = color.computeLuminance() > 0.62
        ? const Color(0xFF1C1C1E)
        : Colors.white;
    final balance = CurrencyFormatter.format(context, wallet.balance);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(color, Colors.white, 0.16)!,
              Color.lerp(color, Colors.black, 0.28)!,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: _peek,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 11),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: onColor.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: onColor,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          wallet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: onColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        balance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: onColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (expanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        wallet.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onColor.withValues(alpha: 0.72),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        balance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: onColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _walletColor(int value) {
    if (value == 0) return const Color(0xFF6C5CE7);
    return Color(value).withValues(alpha: 1);
  }
}

class _HomeRowCard extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final String? badgeText;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showChevron;
  final TextStyle? titleStyle;

  const _HomeRowCard({
    this.onTap,
    this.icon,
    this.badgeText,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showChevron = false,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(Dimens.cardRadius);
    return Material(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: badgeText != null
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: Center(
                          child: Text(
                            badgeText!,
                            style: const TextStyle(fontSize: 18, height: 1),
                          ),
                        ),
                      )
                    : Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle ?? theme.textTheme.titleMedium,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
              if (showChevron) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
