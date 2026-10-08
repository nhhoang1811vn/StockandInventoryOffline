import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/models/app_theme.dart';
import 'package:good_manager/presentation/pages/settings/view/bloc/settings_view_cubit.dart';

import '../../../../app_cubit.dart';
import '../../../dialog/dialog.dart';
import '../../../widget/widget.dart';

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
        return SettingsScaffold(
          title: context.tr("display"),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              SettingsSectionHeader(context.tr("theme"), isFirst: true),
              SettingsMenuCard(
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, appState) => SettingsMenuItem(
                      icon: Icons.brightness_6_outlined,
                      title: context.tr("theme"),
                      subtitle: appState.theme.label,
                      onTap: () async {
                        final theme = await showSelectTheme(context, appState);
                        if (theme != null) {
                          context.read<AppCubit>().setTheme(theme);
                        }
                      },
                      isLast: true,
                    ),
                  ),
                ],
              ),
              SettingsSectionHeader(context.tr("documents_colors")),
              SettingsMenuCard(
                children: [
                  SettingsColorItem(
                    icon: Icons.arrow_downward_rounded,
                    title: context.tr("incoming"),
                    color: state.incomingColor!,
                    onTap: () {
                      _showChoiceColorDialog(state.incomingColor!, (color) {
                        context
                            .read<SettingsViewCubit>()
                            .onIncomingColorChanged(color);
                      });
                    },
                  ),
                  SettingsColorItem(
                    icon: Icons.arrow_upward_rounded,
                    title: context.tr("outgoing"),
                    color: state.outgoingColor!,
                    onTap: () {
                      _showChoiceColorDialog(state.outgoingColor!, (color) {
                        context
                            .read<SettingsViewCubit>()
                            .onOutgoingColorChanged(color);
                      });
                    },
                    isLast: true,
                  ),
                ],
              ),
              SettingsSectionHeader(
                  context.tr("menu_item_min_quantity_color_title")),
              SettingsMenuCard(
                children: [
                  SettingsColorItem(
                    icon: Icons.palette_outlined,
                    title: context.tr("menu_item_min_quantity_color_title"),
                    color: state.reorderColor!,
                    onTap: () {
                      _showChoiceColorDialog(state.reorderColor!, (color) {
                        context
                            .read<SettingsViewCubit>()
                            .onReorderColorChanged(color);
                      });
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
    return showModalBottomSheet<AppTheme>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsBottomSheetTitle(title: context.tr("select_theme")),
                  ...AppTheme.values.map(
                    (type) => ListTile(
                      title: Text(type.label),
                      trailing: state.theme == type
                          ? Icon(Icons.check_rounded,
                              color: Theme.of(context).colorScheme.primary)
                          : (type.isLocked && !AppSettings.isPro())
                              ? const Icon(Icons.lock_outline,
                                  color: Colors.grey, size: 20)
                              : null,
                      onTap: () {
                        if (AppSettings.isPro() || !type.isLocked) {
                          Navigator.pop(context, type);
                        } else {
                          showBuySubscriptionDialog(
                            context,
                            message: context.tr("theme_locked_message"),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
