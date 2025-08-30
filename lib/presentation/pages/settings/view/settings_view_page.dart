import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/settings/view/bloc/settings_view_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app.dart';
import '../../../dialog/dialog.dart';

class SettingsViewPage extends StatefulWidget {
  SettingsViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsViewPageState();
  }
}

class SettingsViewPageState extends State<SettingsViewPage> {
  String _subTitle = "";

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString("user_theme_mode");
    switch (themeString) {
      case 'light':
        _subTitle = AppLocalizations.of(context)!.theme_light;
        break;
      case 'dark':
        _subTitle = AppLocalizations.of(context)!.theme_dark;
        break;
      case 'system':
      default:
        _subTitle = AppLocalizations.of(context)!.theme_system;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsViewCubit, SettingsViewState>(
      listener: (context, state) async {},
      builder: (BuildContext context, SettingsViewState state) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text(AppLocalizations.of(context)!.menu_item_view),
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
          AppLocalizations.of(context)!.theme,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text(AppLocalizations.of(context)!.app_theme),
                subtitle: Text(_subTitle),
                onTap: () => _showThemeDialog(context),
                trailing: Icon(Icons.navigate_next),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          AppLocalizations.of(context)!.documents_colors,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title:
                Text(AppLocalizations.of(context)!.incoming_document_text),
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
                title:
                Text(AppLocalizations.of(context)!.outgoing_document_text),
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
          AppLocalizations.of(context)!.menu_item_min_quantity_color_title,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!
                      .menu_item_min_quantity_color_title,
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
    showSelectColorDialog(context, color: pickerColor, onItemSelected: (item) {
      hideDialog(context);
      callback(item);
    },);
  }

  void _showThemeDialog(BuildContext context) {
    var items = [
      AppLocalizations.of(context)!.theme_system,
      AppLocalizations.of(context)!.theme_light,
      AppLocalizations.of(context)!.theme_dark,
    ];
    showSelectOptionDialog(context,
      title: AppLocalizations.of(context)!.choose_theme,
      items: items, onItemSelected: (index) {
        MyAppState? state = context.findAncestorStateOfType<MyAppState>();
        if (items[index] == AppLocalizations.of(context)!.theme_system) {
          state?.changeTheme(ThemeMode.system);
        } else if (items[index] == AppLocalizations.of(context)!.theme_light) {
          state?.changeTheme(ThemeMode.light);
        } else if (items[index] == AppLocalizations.of(context)!.theme_dark) {
          state?.changeTheme(ThemeMode.dark);
        }
        hideDialog(context);
        fetch();
      },);
  }
}
