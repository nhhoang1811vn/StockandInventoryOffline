import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:good_manager/models/app_language.dart';
import 'package:good_manager/presentation/pages/settings/general/bloc/settings_general_cubit.dart';

import '../../../../app_cubit.dart';
import '../../../../models/currency.dart';
import '../../../../util/util.dart';
import '../../../widget/widget.dart';

class SettingsGeneralPage extends StatefulWidget {
  SettingsGeneralPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsGeneralPageState();
  }
}

class SettingsGeneralPageState extends State<SettingsGeneralPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsGeneralCubit, SettingsGeneralState>(
      listener: (context, state) async {},
      builder: (BuildContext context, SettingsGeneralState state) {
        return SettingsScaffold(
          title: context.tr("general"),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              SettingsSectionHeader(context.tr("general"), isFirst: true),
              SettingsMenuCard(
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, appState) => SettingsMenuItem(
                      icon: Icons.language_outlined,
                      title: context.tr("language"),
                      subtitle: appState.language.label,
                      onTap: () async {
                        final language =
                            await showSelectLanguage(context, appState);
                        if (language != null) {
                          context.setLocale(language.locale);
                          context.read<AppCubit>().setLanguage(language);
                        }
                      },
                    ),
                  ),
                  SettingsMenuItem(
                    icon: Icons.attach_money_rounded,
                    title: context.tr("currency"),
                    subtitle: state.currency.label,
                    onTap: () async {
                      final newCurrency =
                          await showSelectCurrency(context, state);
                      if (newCurrency != null) {
                        context
                            .read<SettingsGeneralCubit>()
                            .onCurrencyChanged(newCurrency);
                      }
                    },
                  ),
                  SettingsSwitchItem(
                    icon: Icons.lock_outline_rounded,
                    title: context.tr("menu_item_passcode_title"),
                    subtitle: context.tr("menu_item_passcode_title"),
                    value: state.enablePasscode,
                    onChanged: (value) =>
                        _handlePasscodeToggle(context, value, state.passcode),
                  ),
                  SettingsMenuItem(
                    icon: Icons.refresh_rounded,
                    title: context
                        .tr("menu_item_reset_numeration_documents_title"),
                    onTap: () {
                      context
                          .read<SettingsGeneralCubit>()
                          .resetAutoDocumentNo();
                      ToastUtils.showInfoToast(context.tr("success"));
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

  Future<AppLanguage?> showSelectLanguage(BuildContext context,
      AppState state,) async {
    return showModalBottomSheet<AppLanguage>(
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
                  SettingsBottomSheetTitle(
                      title: context.tr("select_language")),
                  ...AppLanguage.values.map(
                    (type) => ListTile(
                      title: Text(type.label),
                      trailing: state.language == type
                          ? Icon(Icons.check_rounded,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () => Navigator.pop(context, type),
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

  Future<Currency?> showSelectCurrency(BuildContext context,
      SettingsGeneralState state,) async {
    return showModalBottomSheet<Currency>(
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
                  SettingsBottomSheetTitle(
                      title: context.tr("select_currency")),
                  ...Currency.values.map(
                    (type) => ListTile(
                      title: Text(type.label),
                      trailing: state.currency == type
                          ? Icon(Icons.check_rounded,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () => Navigator.pop(context, type),
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

  void _handlePasscodeToggle(
    BuildContext context,
    bool newValue,
    String currentPasscode,
  ) {
    if (newValue) {
      screenLockCreate(
        context: context,
        onConfirmed: (passcode) {
          Navigator.pop(context);
          context
              .read<SettingsGeneralCubit>()
              .onEnablePasscodeChanged(newValue, passcode);
        },
      );
    } else {
      screenLock(
        context: context,
        correctString: currentPasscode,
        canCancel: true,
        onUnlocked: () {
          Navigator.pop(context);
          context
              .read<SettingsGeneralCubit>()
              .onEnablePasscodeChanged(newValue, "");
        },
      );
    }
  }
}
