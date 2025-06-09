import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/presentation/pages/payment/components/category_selection.dart';

class CategoriesGridView extends StatelessWidget{
  final List<PaymentCategory> categories;
  final VoidCallback onAddNewButtonPressed;
  final void Function(PaymentCategory item) onPressed;
  final void Function(PaymentCategory item) onLongPressed;
  CategoriesGridView({
    required this.categories,
    required this.onAddNewButtonPressed,
    required this.onPressed,
    required this.onLongPressed
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
            itemCount: categories.length + 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,

            ),
            itemBuilder: (context, index) {
              if (index < categories.length){
                //return _buildCategoryWidget(context, categories[index]);
                return CategorySelection(item: categories[index], isSelected: false, onPressed: (){
                  onPressed(categories[index]);
                }, onLongPressed: (){
                  onLongPressed(categories[index]);
                },);
              }else{
                return _buildAddCategoryWidget();
              }
            }),
      ),
    );
  }
  Widget _buildAddCategoryWidget(){
    return InkWell(
      onTap: (){
        onAddNewButtonPressed();
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
}