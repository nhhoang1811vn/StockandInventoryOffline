import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/payment/components/category_selection.dart';

import '../../domain/entity/entity.dart';

class CategoriesGridView extends StatelessWidget {
  final String header;
  final List<PaymentCategory> categories;
  final VoidCallback onAddNewButtonPressed;
  final Function(PaymentCategory) onPressed;
  final Function(PaymentCategory) onLongPressed;

  CategoriesGridView({
    required this.header,
    required this.categories,
    required this.onAddNewButtonPressed,
    required this.onPressed,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        GridView.builder(
          itemCount: categories.length + 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 110,
          ),
          itemBuilder: (context, index) {
            if (index < categories.length) {
              return CategorySelection(
                item: categories[index],
                isSelected: false,
                onPressed: () {
                  onPressed(categories[index]);
                },
                onLongPressed: () {
                  onLongPressed(categories[index]);
                },
              );
            }
            return _buildAddCategoryWidget(theme, isDark);
          },
        ),
      ],
    );
  }

  Widget _buildAddCategoryWidget(ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAddNewButtonPressed,
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
