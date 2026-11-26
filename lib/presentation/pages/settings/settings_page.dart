import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import '../../widget/widget.dart';
import '../pages.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: context.tr("settings"),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 32),
        children: [
          SettingsMenuCard(
            children: [
              SettingsMenuItem(
                icon: Icons.tune_rounded,
                title: context.tr("general"),
                onTap: () =>
                    Navigator.of(context).pushNamed(Pages.settings_general),
              ),
              SettingsMenuItem(
                icon: Icons.visibility_outlined,
                title: context.tr("display"),
                onTap: () =>
                    Navigator.of(context).pushNamed(Pages.settings_view),
              ),
              SettingsMenuItem(
                icon: UIConstants.barcodeIconData,
                title: context.tr("menu_item_barcode_scanner"),
                onTap: () => Navigator.of(context)
                    .pushNamed(Pages.barcode_scanner_settings),
              ),
              SettingsMenuItem(
                icon: Icons.checklist_rounded,
                title: context.tr("good_properties"),
                tag: SettingsNewTag(label: context.tr("tag_new")),
                onTap: () => Navigator.of(context)
                    .pushNamed(Pages.settings_good_properties),
              ),
              SettingsMenuItem(
                icon: Icons.description_outlined,
                title: context.tr("document_properties"),
                tag: SettingsNewTag(label: context.tr("tag_new")),
                onTap: () => Navigator.of(context)
                    .pushNamed(Pages.settings_document_properties),
              ),
              SettingsMenuItem(
                icon: Icons.warning_amber_rounded,
                title: context.tr("menu_item_minimum_quantity"),
                onTap: () => Navigator.of(context)
                    .pushNamed(Pages.settings_minimum_quantity),
              ),
              SettingsMenuItem(
                icon: Icons.business_outlined,
                title: context.tr("menu_item_my_company"),
                onTap: () =>
                    Navigator.of(context).pushNamed(Pages.settings_my_company),
              ),
              SettingsMenuItem(
                icon: Icons.backup_outlined,
                title: context.tr("menu_item_backup_and_restore"),
                onTap: () =>
                    Navigator.of(context).pushNamed(Pages.settings_data),
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
