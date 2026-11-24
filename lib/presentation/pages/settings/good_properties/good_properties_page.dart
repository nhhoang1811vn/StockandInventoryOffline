import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant/constant.dart';
import '../../../widget/widget.dart';
import 'bloc/good_properties_cubit.dart';
import 'change_quantity_decimals_dialog.dart';

class GoodPropertiesPage extends StatefulWidget {
  const GoodPropertiesPage({Key? key}) : super(key: key);

  @override
  State<GoodPropertiesPage> createState() => _GoodPropertiesPageState();
}

class _GoodPropertiesPageState extends State<GoodPropertiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<GoodPropertiesCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoodPropertiesCubit, GoodPropertiesState>(
      builder: (context, state) {
        final cubit = context.read<GoodPropertiesCubit>();
        return SettingsScaffold(
          title: context.tr("good_properties"),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              SettingsMenuCard(
                children: [
                  SettingsSwitchItem(
                    icon: Icons.image_outlined,
                    title: context.tr("good_properties_image"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showImage,
                    onChanged: cubit.onShowImageChanged,
                  ),
                  SettingsSwitchItem(
                    icon: UIConstants.barcodeIconData,
                    title: context.tr("barcode"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showBarcode,
                    onChanged: cubit.onShowBarcodeChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.notes_outlined,
                    title: context.tr("label_description"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showDescription,
                    onChanged: cubit.onShowDescriptionChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.shopping_cart_outlined,
                    title: context.tr("purchase_price"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showPurchasePrice,
                    onChanged: cubit.onShowPurchasePriceChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.sell_outlined,
                    title: context.tr("sale_price"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showSalePrice,
                    onChanged: cubit.onShowSalePriceChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.warning_amber_rounded,
                    title: context.tr("min_quantity"),
                    subtitle: context.tr("good_properties_toggle_hint"),
                    value: state.showMinQuantity,
                    onChanged: cubit.onShowMinQuantityChanged,
                    isLast: true,
                  ),
                ],
              ),
              SettingsSectionHeader(context.tr("uniqueness")),
              SettingsMenuCard(
                children: [
                  SettingsSwitchItem(
                    icon: UIConstants.barcodeIconData,
                    title: context.tr("unique_barcode"),
                    subtitle: context.tr("unique_barcode_hint"),
                    value: state.uniqueBarcode,
                    onChanged: cubit.onUniqueBarcodeChanged,
                  ),
                  SettingsSwitchItem(
                    icon: Icons.folder_outlined,
                    title: context.tr("unique_group"),
                    subtitle: context.tr("unique_group_hint"),
                    value: state.uniqueGroupName,
                    onChanged: cubit.onUniqueGroupNameChanged,
                    isLast: true,
                  ),
                ],
              ),
              SettingsSectionHeader(context.tr("quantity_field")),
              SettingsMenuCard(
                children: [
                  SettingsSwitchItem(
                    icon: Icons.inventory_2_outlined,
                    title: context.tr("allow_negative_stock"),
                    subtitle: context.tr("allow_negative_stock_hint"),
                    value: state.allowNegativeStock,
                    onChanged: cubit.onAllowNegativeStockChanged,
                  ),
                  SettingsMenuItem(
                    icon: Icons.pin_outlined,
                    title: context.tr("decimal_digits"),
                    subtitle: state.quantityDecimals.toString(),
                    onTap: () async {
                      final value = await showDialog<int>(
                        context: context,
                        builder: (_) => ChangeQuantityDecimalsDialogWidget(
                            state.quantityDecimals),
                      );
                      if (value != null) {
                        cubit.onQuantityDecimalsChanged(value);
                      }
                    },
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
