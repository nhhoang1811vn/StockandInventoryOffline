import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/presentation/constants.dart';
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
  Widget _buildAddCategoryWidget(){
    return InkWell(
      onTap: (){
        widget.onAddButtonPressed();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade700,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ), // No decoration if not selected

          child: Icon(Icons.add, color: Colors.grey.shade700)),
    );
  }
  Widget _buildWidget(Wallet item) {
    bool selected = item.id == widget.selectedItem?.id;
    return InkWell(
      onTap: (){
        widget.onPressed(item);
      },
      //onLongPress: (){
      //  widget.onLongPressed(item);
      //},
      borderRadius: BorderRadius.circular(16),
      child: Container(
          decoration: selected
              ? BoxDecoration(
            color: Colors.blue.shade50,
            border: Border.all(
              color: Colors.blue.shade700,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          )
              : null, // No decoration if not selected

          child: Column(mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, // Optional, helpful if Column grows
              crossAxisAlignment: CrossAxisAlignment.center,children: [
            Icon(UIConstants.walletIconData, color: Color(item.color), size: 24),
            SizedBox(height: 4),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ])),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.label_select_payment_category,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16),
          Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                  itemCount: widget.items.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Two columns
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    if (index < widget.items.length){
                      return _buildWidget(widget.items[index]);
                    }else{
                      return _buildAddCategoryWidget();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}