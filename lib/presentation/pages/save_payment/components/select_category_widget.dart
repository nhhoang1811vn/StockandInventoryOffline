import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/presentation/widgets/categories_grid_view.dart';


class SelectCategoryWidget extends StatefulWidget {
  final List<PaymentCategory> categories;
  final PaymentCategory? selectedCategory;
  final void Function(PaymentCategory item) onPressed;
  final VoidCallback onAddNewButtonPressed;

  SelectCategoryWidget(
      {required this.categories,
      required this.selectedCategory,
      required this.onPressed,
      required this.onAddNewButtonPressed});

  @override
  State<StatefulWidget> createState() {
    return SelectCategoryWidgetState();
  }
}

class SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  @override
  void initState() {
    super.initState();
  }
  Widget _buildAddCategoryWidget(){
    return InkWell(
      onTap: (){
        widget.onAddNewButtonPressed();//widget.onPressed(item);
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
  Widget _buildWidget(PaymentCategory item) {
    bool selected = item.id == widget.selectedCategory?.id;
    return InkWell(
      onTap: (){
        widget.onPressed(item);
      },
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

          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text(item.icon, style: TextStyle(fontSize: 28)),
            SizedBox(height: 4),
            Text(
              item.name,
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
          //CategoriesGridView(categories: widget.categories, onAddNewButtonPressed: widget.onAddNewButtonPressed, onPressed: (item){}, onLongPressed: (item){})
          Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                  itemCount: widget.categories.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (index < widget.categories.length){
                      return _buildWidget(widget.categories[index]);
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
