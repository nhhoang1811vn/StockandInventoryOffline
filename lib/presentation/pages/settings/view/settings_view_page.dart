import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/models/app_theme.dart';
import 'package:good_manager/presentation/pages/settings/view/bloc/settings_view_cubit.dart';

import '../../../../app_cubit.dart';
import '../../../dialog/dialog.dart';

class SettingsViewPage extends StatefulWidget {
  SettingsViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsViewPageState();
  }
}

class SettingsViewPageState extends State<SettingsViewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsViewCubit, SettingsViewState>(
      listener: (context, state) async {},
      builder: (BuildContext context, SettingsViewState state) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text(context.tr("display")),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SettingsViewState state) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          context.tr("theme"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              BlocBuilder<AppCubit, AppState>(
                builder: (context, state) => ListTile(
                  leading: Icon(Icons.brightness_6),
                  title: Text("theme").tr(),
                  subtitle: Text(state.theme.label),
                  trailing: const Icon(Icons.navigate_next),
                  onTap: () async {
                    var theme = await showSelectTheme(
                      context,
                      state,
                    );
                    if (theme != null) {
                      context.read<AppCubit>().setTheme(theme);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          context.tr("documents_colors"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(context.tr("incoming")),
                trailing: Container(
                  width: 20, // Circle diameter
                  height: 20,
                  decoration: BoxDecoration(
                    color: state.incomingColor, // use your color here
                    shape: BoxShape.circle,
                  ),
                  //color: state.color,
                ),
                onTap: () {
                  _showChoiceColorDialog(state.incomingColor!, (color) {
                    context
                        .read<SettingsViewCubit>()
                        .onIncomingColorChanged(color);
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text(context.tr("outgoing")),
                trailing: Container(
                  width: 20, // Circle diameter
                  height: 20,
                  decoration: BoxDecoration(
                    color: state.outgoingColor, // use your color here
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  _showChoiceColorDialog(state.outgoingColor!, (color) {
                    context
                        .read<SettingsViewCubit>()
                        .onOutgoingColorChanged(color);
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          context.tr("menu_item_min_quantity_color_title"),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  context.tr("menu_item_min_quantity_color_title"),
                ),
                trailing: Container(
                  width: 20, // Circle diameter
                  height: 20,
                  decoration: BoxDecoration(
                    color: state.reorderColor, // use your color here
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  _showChoiceColorDialog(state.reorderColor!, (color) {
                    context
                        .read<SettingsViewCubit>()
                        .onReorderColorChanged(color);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showChoiceColorDialog(Color pickerColor, ValueChanged<Color> callback) {
    showSelectColorDialog(
      context,
      color: pickerColor,
      onItemSelected: (item) {
        hideDialog(context);
        callback(item);
      },
    );
  }

  Future<AppTheme?> showSelectTheme(
    BuildContext context,
    AppState state,
  ) async {
    return await showModalBottomSheet<AppTheme>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          // 70% of screen height
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "select_theme".tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Column(
                    children: AppTheme.values
                        .map(
                          (type) => ListTile(
                            title: Text(type.label),
                            trailing: state.theme == type
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : (type.isLocked && !AppSettings.isPro())
                                    ? Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                        size: 20,
                                      )
                                    : null,
                            onTap: () {
                              if (AppSettings.isPro() || !type.isLocked) {
                                Navigator.pop(context, type);
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
