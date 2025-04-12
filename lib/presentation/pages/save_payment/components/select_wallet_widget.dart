import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/presentation/pages/save_payment/components/wallet_selection_row.dart';
import 'package:good_manager/presentation/widgets/primary_button.dart';


class SelectWalletWidget extends StatefulWidget{
  final List<Wallet> items;
  final Wallet? selectedItem;
  final void Function(Wallet item) onPressed;
  final VoidCallback onAddButtonPressed;


  SelectWalletWidget({
    required this.items,
    required this.selectedItem,
    required this.onPressed,
    required this.onAddButtonPressed
  });

  @override
  State<StatefulWidget> createState() {
    return SelectWalletWidgetState();
  }
}
class SelectWalletWidgetState extends State<SelectWalletWidget>{

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Column(mainAxisSize: MainAxisSize.min,  // Ensures the column only takes as much space as needed
          children: [
          Text(AppLocalizations.of(context)!.label_select_wallet, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16,),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(shrinkWrap: true,itemCount: widget.items.length,itemBuilder: (BuildContext context, int index) {
              return WalletSelectionRow(widget.items[index], (item){
                widget.onPressed(item);
              },widget.items[index].id == widget.selectedItem?.id);
            },),
          ),
          Container(width: double.infinity, child:
          PrimaryButton(AppLocalizations.of(context)!.action_add_wallet, (){
            widget.onAddButtonPressed();
          }))
      ],),
    );
  }
}