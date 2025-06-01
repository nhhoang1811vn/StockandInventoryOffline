import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:good_manager/presentation/pages/settings/minimum_quantity/bloc/minimum_quantity_cubit.dart';

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
                          onColorChanged: context
                              .read<MinimumQuantityCubit>()
                              .onColorChanged,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog
                          },
                          child: Text(AppLocalizations.of(context)!
                              .action_ok),
                        ),
                      ],
                    ));

                //context.read<MinimumQuantityCubit>().onShowInListChanged();
              },
              trailing: Container(
                width: 20, // Circle diameter
                height: 20,
                color: state.color,
              ),
            ),
            Divider(
              height: 1,
            ),
            SwitchListTile(
              value: state.showAlert,
              onChanged: (newValue) {
                context.read<MinimumQuantityCubit>().onShowAlertChanged();
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
