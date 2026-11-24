import 'package:good_manager/util/dimen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/goods/good_item_row.dart';

import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
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
    final goodProperties = AppSettings.getGoodPropertiesSettings();
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr("no_goods"),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(Dimens.screenPadding),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final good = items[index];
                return GoodItemRow(
                  item: good,
                  quantity: good.quantity,
                  showBarcode: goodProperties.showBarcode,
                  showDescription: goodProperties.showDescription,
                  showMinQuantity: goodProperties.showMinQuantity,
                  showPurchasePrice: goodProperties.showPurchasePrice,
                  showSalePrice: goodProperties.showSalePrice,
                  showImage: goodProperties.showImage,
                  showLowStockIndicator: goodProperties.showMinQuantity,
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
