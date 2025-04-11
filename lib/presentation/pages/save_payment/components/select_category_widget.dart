import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/presentation/pages/save_payment/components/category_selection_row.dart';
import 'package:good_manager/presentation/widgets/primary_button.dart';


class SelectCategoryWidget extends StatefulWidget{
  final List<PaymentCategory> categories;
  final PaymentCategory? selectedCategory;
  final void Function(PaymentCategory item) onPressed;
  final void Function(PaymentCategory item) onLongPressed;
  final VoidCallback onAddNewCategoryButtonPressed;

  SelectCategoryWidget({required this.categories, required this.selectedCategory, required this.onPressed, required this.onLongPressed,required this.onAddNewCategoryButtonPressed});

  @override
  State<StatefulWidget> createState() {
    return SelectCategoryWidgetState();
  }
}
class SelectCategoryWidgetState extends State<SelectCategoryWidget>{

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
          Text(AppLocalizations.of(context)!.label_select_payment_category, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16,),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(shrinkWrap: true,itemCount: widget.categories.length,itemBuilder: (BuildContext context, int index) {
              return CategorySelectionRow(widget.categories[index], (item){
                widget.onPressed(item);
              }, (item){
                widget.onLongPressed(item);
              }, widget.categories[index].id == widget.selectedCategory?.id);
            },),
          ),
          Container(width: double.infinity, child:
          PrimaryButton(AppLocalizations.of(context)!.action_add_payment_category, (){
            widget.onAddNewCategoryButtonPressed();
          }))


          //_buildToolbar(),
      ],),
    );
  }
}