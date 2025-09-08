import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/help_content.dart';

import '../../markdown/md_provider_factory.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(context.tr("help_title"))),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              for (int i = 0; i < HelpType.values.length; i++) ...[
                ListTile(
                  title: Text(HelpType.values[i].getTitle(context)),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Pages.help,
                      arguments: {
                        "title": HelpType.values[i].getTitle(context),
                        "content": MDProviderFactory.get()
                            .getHelpText(HelpType.values[i]),
                      },
                    );

                    //onReportTypeTapped(HelpType.values[i]);
                  },
                ),
                if (i < HelpType.values.length - 1) Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
