import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'more_controller.dart';

class MorePage extends View {
  MorePage({Key key}) : super(key: key);

  @override
  MorePageView createState() => MorePageView();
}

class MorePageView extends ViewState<MorePage, MoreController> {
  MorePageView() : super(MoreController());

  @override
  Widget get view => Scaffold(
      appBar: new AppBar(title: new Text(AppLocalizations.of(context).title_more)),
      body: ListView(
        key: globalKey,
        children: [
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
            return ListTile(
              leading: Icon(Icons.perm_contact_calendar),
              title: Text('Suppliers'),
              subtitle: Text('Suppliers information'),
              onTap: () => controller.openSuppliersPage(),
            );
          }),
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
                return ListTile(
                  leading: Icon(Icons.perm_contact_calendar),
                  title: Text('Customers'),
                  subtitle: Text('Customers information'),
                  onTap: () => controller.openCustomersPage(),
                );
              }),
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
                return ListTile(
                  leading: Icon(Icons.store),
                  title: Text('Stores'),
                  subtitle: Text('Stores information'),
                  onTap: () => controller.openStoresPage(),
                );
              }),
          ListTile(
            dense: true,
            title: Text('Other SS Team Experiences'),
          ),
          ListTile(
            leading: Icon(Icons.mail_outline),
            title: Text('Todo'),
            subtitle: Text('Great app for personally task manager'),
          ),
          ListTile(
            dense: true,
            title: Text('Good Manager'),
          ),
          ListTile(
            leading: Icon(Icons.mail_outline),
            title: Text('Invite friends'),
            subtitle: Text('Share the good app to your friends'),
          ),
          ListTile(
            leading: Icon(Icons.star_rate),
            title: Text('Write a review'),
            subtitle: Text('Write a review'),
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            subtitle: Text('Share your feedback to improve the app'),
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_sharp),
            title: Text('Community'),
            subtitle: Text('Our app community'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('About'),
          ),
        ],
      ));
}
