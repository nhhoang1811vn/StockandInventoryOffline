import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/payment/components/wallet_selection.dart';


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

          child: Icon(Icons.add,
              //color: Colors.grey.shade700
          )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.label_select_wallet,
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                  itemCount: widget.items.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    if (index < widget.items.length){
                      var item = widget.items[index];
                      var isSelected = item.id == widget.selectedItem?.id;
                      return WalletSelection(item: item, isSelected: isSelected, showBalance: true,onPressed: (){
                        widget.onPressed(item);
                      });
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