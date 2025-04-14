import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entities/payment_category.dart';

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
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
            itemCount: categories.length + 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < categories.length){
                return _buildCategoryWidget(context, categories[index]);
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
  Widget _buildCategoryWidget(BuildContext context, PaymentCategory item) {
    bool selected = false;
    return InkWell(
      onTap: (){
        onPressed(item);
      },
      onLongPress: (){
        onLongPressed(item);
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

}