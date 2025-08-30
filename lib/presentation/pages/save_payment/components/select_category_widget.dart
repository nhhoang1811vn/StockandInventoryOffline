import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/payment/components/category_selection.dart';

import '../../../../domain/entity/entity.dart';

class SelectCategoryWidget extends StatefulWidget {
  final List<PaymentCategory> categories;
  final PaymentCategory? selectedCategory;
  final Function(PaymentCategory item) onPressed;
  final VoidCallback onAddNewButtonPressed;

  SelectCategoryWidget({
    required this.categories,
    required this.selectedCategory,
    required this.onPressed,
    required this.onAddNewButtonPressed,
  });

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

  Widget _buildAddCategoryWidget() {
    return InkWell(
      onTap: () {
        widget.onAddNewButtonPressed(); //widget.onPressed(item);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            //color: Colors.grey.shade700,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ), // No decoration if not selected

        child: Icon(
          Icons.add,
          //color: Colors.grey.shade700
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.label_select_payment_category,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          //CategoriesGridView(categories: widget.categories, onAddNewButtonPressed: widget.onAddNewButtonPressed, onPressed: (item){}, onLongPressed: (item){})
          Card(
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
                  if (index < widget.categories.length) {
                    var item = widget.categories[index];
                    bool isSelected = item.id == widget.selectedCategory?.id;
                    return CategorySelection(
                      item: item,
                      isSelected: isSelected,
                      onPressed: () {
                        widget.onPressed(item);
                      },
                    );
                  } else {
                    return _buildAddCategoryWidget();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
