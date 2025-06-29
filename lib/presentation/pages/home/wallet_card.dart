import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/constants.dart';

import '../../../domain/entities/wallet.dart';
import '../../../l10n/app_localizations.dart';
import '../pages.dart';
import 'bloc/home_cubit.dart';

class WalletCard extends StatelessWidget {
  final Wallet wallet;


  const WalletCard({
    super.key,
    required this.wallet
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(wallet.color),
      child: SizedBox(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(wallet.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),),
                Spacer(),
                IconButton(onPressed: (){
                  _showWalletOptionsDialog(context, wallet);
                }, icon:  Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ))
              ],),
              const Spacer(),
              Text(Config.currencyFormat.format(wallet.balance), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  void _showWalletOptionsDialog(BuildContext context, Wallet item) {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () async{

                  Navigator.pop(context);
                  await Navigator.of(context).pushNamed(Pages.save_wallet, arguments: {"item" : item});
                  context.read<HomeCubit>().initState();
                },
                child: Text(AppLocalizations.of(context)!.action_edit),
              ),
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
}