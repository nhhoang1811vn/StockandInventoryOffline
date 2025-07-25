import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:good_manager/presentation/pages/settings/minimum_quantity/bloc/minimum_quantity_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../markdown/md_provider_factory.dart';
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
  bool _isNotificationPermissionGranted = false;
  @override
  void initState() {
    super.initState();
    context.read<MinimumQuantityCubit>().init();
    loadNotificationPermissionGranted();
  }
  void loadNotificationPermissionGranted() async{
    _isNotificationPermissionGranted = await isNotificationPermissionGranted();
    setState(() {

    });
  }

  Future<bool> isNotificationPermissionGranted() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await Permission.notification.isGranted;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MinimumQuantityCubit, MinimumQuantityState>(
        listener: (context, state) async {},
        builder: (BuildContext context, MinimumQuantityState state) {
          return Scaffold(
            appBar: new AppBar(
              actions: [_buildHelpMenu()],
                title: new Text(
                    AppLocalizations.of(context)!.menu_item_minimum_quantity)),
            body: _buildBody(state),
          );
        });
  }
  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Pages.help, arguments: {
            "title": AppLocalizations.of(context)!.menu_item_minimum_quantity,
            "content": MDProviderFactory.get().getHelpText(HelpType.MIN_QUAN)
          });
        },
        icon: Icon(Icons.help));
  }
  Future<bool> requestNotificationPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;

      if (status.isGranted) return true;

      if (status.isDenied) {
        final result = await Permission.notification.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDialog(context);
        return false;
      }
    } else if (Platform.isIOS) {
      final plugin = FlutterLocalNotificationsPlugin();
      await plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      // iOS doesn't return status — recommend assuming they granted and showing a test notification
      return true;
    }

    return false;
  }
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.notification_permission),
        content: Text(AppLocalizations.of(context)!.notification_permission_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.text_cancel),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.open_settings),
          ),
        ],
      ),
    );
  }
  Widget _buildBody(MinimumQuantityState state) {
    return ListView(padding: EdgeInsets.all(16), children: [
      Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            SwitchListTile(
              value: state.showInItem,
              onChanged: (newValue) {
                context.read<MinimumQuantityCubit>().onShowInItemChanged();
              },
              title: Text(AppLocalizations.of(context)!
                  .menu_item_show_min_quantity_items_page_title),
            ),
            Divider(
              height: 1,
            ),
            SwitchListTile(
              value: state.showInList,
              onChanged: (newValue) {
                context.read<MinimumQuantityCubit>().onShowInListChanged();
              },
              title: Text(AppLocalizations.of(context)!
                  .menu_item_show_min_quantity_list_page_title),
            ),
            Divider(
              height: 1,
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!
                  .menu_item_min_quantity_color_title),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (builder) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!
                          .title_pick_color),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: state.color,
                          onColorChanged: (newColor){
                            context
                                .read<MinimumQuantityCubit>()
                                .onColorChanged(newColor);
                            Navigator.of(context).pop();
                          } ,
                        ),
                      ),
                      // actions: [
                      //   TextButton(
                      //     onPressed: () {
                      //       Navigator.of(context)
                      //           .pop(); // Close the dialog
                      //     },
                      //     child: Text(AppLocalizations.of(context)!
                      //         .action_ok),
                      //   ),
                      // ],
                    ));

                //context.read<MinimumQuantityCubit>().onShowInListChanged();
              },
              trailing: Container(
                width: 20, // Circle diameter
                height: 20,
                decoration: BoxDecoration(
                  color: state.color, // use your color here
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            SwitchListTile(
              value: (_isNotificationPermissionGranted && state.showAlert),
              onChanged: (newValue) async{
                if (newValue && !_isNotificationPermissionGranted){
// Request permission first
                  final granted = await requestNotificationPermission(context);

                  if (granted) {
                    setState(() {
                      _isNotificationPermissionGranted = true;
                    });
                    context.read<MinimumQuantityCubit>().onShowAlertChanged(true);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.notification_permission_required_message)),
                      );
                    }
                  }
                }else{
                  context.read<MinimumQuantityCubit>().onShowAlertChanged(newValue);
                }
              },
              title: Text(AppLocalizations.of(context)!
                  .menu_item_show_low_stock_alert_title),
              subtitle: Text(AppLocalizations.of(context)!
                  .menu_item_show_low_stock_alert_desc),
            )
          ]))
    ]);
  }
}
