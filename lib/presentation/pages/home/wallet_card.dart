import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/util/currency_formatter.dart';

import '../../../domain/entity/entity.dart';
import '../../dialog/dialog.dart';
import '../pages.dart';
import 'bloc/home_cubit.dart';

class WalletCard extends StatelessWidget {
  final Wallet wallet;

  const WalletCard({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(wallet.color),
      child: SizedBox(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    wallet.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      _showWalletOptionsDialog(context, wallet);
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                CurrencyFormatter.format(context, wallet.balance),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWalletOptionsDialog(BuildContext context, Wallet item) {
    var items = [
      context.tr("edit"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("edit")) {
          await Navigator.of(context)
              .pushNamed(Pages.save_wallet, arguments: {"item": item});
          context.read<HomeCubit>().initState();
        } else if (items[index] ==
            context.tr("delete")) {
          context.read<HomeCubit>().deleteWallet(item);
          context.read<HomeCubit>().initState();
        }
      },
    );
  }
}
