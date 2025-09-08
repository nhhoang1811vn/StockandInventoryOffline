import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:good_manager/models/app_language.dart';
import 'package:good_manager/presentation/pages/settings/general/bloc/settings_general_cubit.dart';

import '../../../../app_cubit.dart';
import '../../../../models/currency.dart';
import '../../../../util/util.dart';
import '../../../widget/views.dart';

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
        return Scaffold(
          appBar: new AppBar(
            title: new Text(context.tr("general")),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(SettingsGeneralState state) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              BlocBuilder<AppCubit, AppState>(
                builder:
                    (context, state) => ListTile(
                      leading: Icon(Icons.language_outlined),
                  title: Text("language").tr(),
                  subtitle: Text(state.language.label),
                  trailing: const Icon(Icons.navigate_next),
                  onTap: () async {
                    var language = await showSelectLanguage(
                      context,
                      state,
                    );
                    if (language != null) {
                      context.setLocale(language.locale);
                      context.read<AppCubit>().setLanguage(language);
                    }
                  },
                ),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text("currency").tr(),
                subtitle: Text(state.currency.label),
                onTap: () async {
                  Currency? newCurrency = await showSelectCurrency(
                    context,
                    state,
                  );
                  if (newCurrency != null) {
                    context.read<SettingsGeneralCubit>().onCurrencyChanged(
                      newCurrency,
                    );
                  }
                },
                trailing: const Icon(Icons.navigate_next),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text(
                  context.tr("menu_item_passcode_title"),
                ),
                subtitle: Text(
                  context.tr("menu_item_passcode_title"),
                ),
                trailing: Switch(
                  value: state.enablePasscode,
                  onChanged: (value) {
                    _handlePasscodeToggle(context, value, state.passcode);
                  },
                ),
                onTap: () {
                  _handlePasscodeToggle(
                    context,
                    !state.enablePasscode,
                    state.passcode,
                  );
                },
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.refresh_outlined),
                title: Text(
                  context.tr("menu_item_reset_numeration_documents_title"),
                ),
                onTap: () {
                  context.read<SettingsGeneralCubit>().resetAutoDocumentNo();
                  ToastUtils.showInfoToast(
                    context.tr("success"),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<AppLanguage?> showSelectLanguage(
      BuildContext context,
      AppState state,
      ) async {
    return await showModalBottomSheet<AppLanguage>(
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
                      "select_language".tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Column(
                    children:
                    AppLanguage.values
                        .map(
                          (type) => ListTile(
                        title: Text(type.label),
                        trailing:
                        state.language == type
                            ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                            : null,
                        onTap: () {
                          Navigator.pop(context, type);
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
  Future<Currency?> showSelectCurrency(
      BuildContext context,
      SettingsGeneralState state,
      ) async {
    return await showModalBottomSheet<Currency>(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "select_currency".tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Column(
                    children:
                    Currency.values
                        .map(
                          (type) => ListTile(
                        title: Text(type.label),
                        trailing:
                        state.currency == type
                            ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                            : null,
                        onTap: () => Navigator.pop(context, type),
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
