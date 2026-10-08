import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/help_content.dart';

import '../../markdown/md_provider_factory.dart';
import '../../widget/widget.dart';
import '../pages.dart';

class HelpsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HelpsPageState();
  }
}

class HelpsPageState extends State<HelpsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      title: context.tr("help_title"),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SettingsSectionHeader(context.tr("help_title"), isFirst: true),
          SettingsMenuCard(
            children: [
              for (int i = 0; i < HelpType.values.length; i++)
                SettingsMenuItem(
                  icon: HelpType.values[i].getIcon(),
                  title: HelpType.values[i].getTitle(context),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Pages.help,
                      arguments: {
                        "title": HelpType.values[i].getTitle(context),
                        "content": MDProviderFactory.get()
                            .getHelpText(HelpType.values[i]),
                      },
                    );
                  },
                  isLast: i == HelpType.values.length - 1,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
