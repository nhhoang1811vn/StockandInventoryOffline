import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/settings/minimum_quantity/bloc/minimum_quantity_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../dialog/dialog.dart';
import '../../../markdown/md_provider_factory.dart';
import '../../../widget/widget.dart';
import '../../help_content.dart';
import '../../pages.dart';

class MinimumQuantityPage extends StatefulWidget {
  MinimumQuantityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MinimumQuantityPageState();
  }
}

class MinimumQuantityPageState extends State<MinimumQuantityPage> {
  @override
  void initState() {
    super.initState();
    context.read<MinimumQuantityCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MinimumQuantityCubit, MinimumQuantityState>(
      listener: (context, state) async {},
      builder: (BuildContext context, MinimumQuantityState state) {
        return SettingsScaffold(
          title: context.tr("menu_item_minimum_quantity"),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline_rounded),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Pages.help,
                  arguments: {
                    "title": context.tr("menu_item_minimum_quantity"),
                    "content":
                        MDProviderFactory.get().getHelpText(HelpType.MIN_QUAN),
                  },
                );
              },
            ),
            const SizedBox(width: 16),
          ],
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              SettingsSectionHeader(context.tr("display"), isFirst: true),
              SettingsMenuCard(
                children: [
                  SettingsSwitchItem(
                    icon: Icons.inventory_2_outlined,
                    title: context
                        .tr("menu_item_show_min_quantity_items_page_title"),
                    value: state.showInItem,
                    onChanged: (_) => context
                        .read<MinimumQuantityCubit>()
                        .onShowInItemChanged(),
                  ),
                  SettingsSwitchItem(
                    icon: Icons.view_list_outlined,
                    title: context
                        .tr("menu_item_show_min_quantity_list_page_title"),
                    value: state.showInList,
                    onChanged: (_) => context
                        .read<MinimumQuantityCubit>()
                        .onShowInListChanged(),
                  ),
                  SettingsColorItem(
                    icon: Icons.palette_outlined,
                    title: context.tr("menu_item_min_quantity_color_title"),
                    color: state.color ?? Theme.of(context).colorScheme.primary,
                    onTap: () {
                      showSelectColorDialog(
                        context,
                        color: state.color ??
                            Theme.of(context).colorScheme.primary,
                        onItemSelected: (item) {
                          hideDialog(context);
                          context
                              .read<MinimumQuantityCubit>()
                              .onColorChanged(item);
                        },
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),
              SettingsSectionHeader(context.tr("notifications")),
              SettingsMenuCard(
                children: [
                  SettingsSwitchItem(
                    icon: Icons.notifications_outlined,
                    title: context.tr("menu_item_show_low_stock_alert_title"),
                    subtitle: context.tr("menu_item_show_low_stock_alert_desc"),
                    value: state.showAlert,
                    onChanged: (newValue) async {
                      if (newValue) {
                        await requestNotificationPermission(context);
                        context
                            .read<MinimumQuantityCubit>()
                            .onShowAlertChanged(true);
                      } else {
                        context
                            .read<MinimumQuantityCubit>()
                            .onShowAlertChanged(newValue);
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

  Future<bool> requestNotificationPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        final result = await Permission.notification.request();
        return result.isGranted;
      }
      if (status.isPermanentlyDenied) {
        _showPermissionDialog(context);
        return false;
      }
    } else if (Platform.isIOS) {
      final result = await Permission.notification.request();
      if (result == PermissionStatus.denied ||
          result == PermissionStatus.permanentlyDenied) {
        _showPermissionDialog(context);
        return false;
      }
    }
    return true;
  }

  void _showPermissionDialog(BuildContext context) {
    showCustomAlertDialog(
      context,
      title: context.tr("notification_permission"),
      message: context.tr("notification_permission_content"),
      positiveText: context.tr("open_settings"),
      onPositivePressed: () async {
        hideDialog(context);
        openAppSettings();
      },
    );
  }
}
