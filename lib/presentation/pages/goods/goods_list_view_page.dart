import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/goods/good_item_row.dart';

import '../../../constant/constant.dart';
import '../pages.dart';

class GoodsListViewPage extends StatelessWidget {
  final List<Good> items;
  final String title;
  final IconData? emptyIcon;

  const GoodsListViewPage({
    super.key,
    required this.items,
    required this.title,
    this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    emptyIcon ?? UIConstants.goodIconData,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr("no_goods"),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final good = items[index];
                return GoodItemRow(
                  item: good,
                  quantity: good.quantity,
                  showBarcode: true,
                  showDescription: true,
                  showMinQuantity: true,
                  minQuantityColor: Colors.red,
                  onGoodTapped: (item) {
                    Navigator.of(context).pushNamed(
                      Pages.save_good,
                      arguments: {"item": item},
                    );
                  },
                  onGoodLongPressed: (item) {},
                  isSelection: false,
                );
              },
            ),
    );
  }
}
