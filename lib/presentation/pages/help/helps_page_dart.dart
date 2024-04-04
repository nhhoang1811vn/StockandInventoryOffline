import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/help_content.dart';

import '../../markdown/md_provider_factory.dart';
import '../pages.dart';
class HelpsPage extends StatelessWidget {
  HelpsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.help_title)),
        body: ListView.separated(
            itemCount: HelpType.values.length,
            itemBuilder: (BuildContext context, int index) {
              HelpType type = HelpType.values[index];
              return ListTile(
                visualDensity: VisualDensity(vertical: -3), // to compact
                title: Text(type.getTitle(context),),
                onTap: (){
                  Navigator.of(context).pushNamed(Pages.help, arguments: {
                    "title": type.getTitle(context),
                    "content": MDProviderFactory.get().getHelpText(type)
                  });
                },
              );
            },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.grey[500]);
          },
        ));
  }
}
