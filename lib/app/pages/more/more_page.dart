import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/stores/stores_page.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_page.dart';

import '../pages.dart';

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MorePageState();
  }
}

class MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.perm_contact_calendar),
          title: Text('Suppliers'),
          subtitle: Text('Suppliers information'),
          onTap: () => {
            //Navigator.of(context).pushNamed(SuppliersPageWidget.routeName,
                //arguments: SuppliersPageArgument(false))
          },
        ),
        ListTile(
          leading: Icon(Icons.perm_contact_calendar),
          title: Text('Customers'),
          subtitle: Text('Customers information'),
        ),
        ListTile(
          leading: Icon(Icons.store),
          title: Text('Stores'),
          subtitle: Text('Stores information'),
          onTap: () => {
            Navigator.of(context).pushNamed(Pages.store_list)
          },
        ),
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
    );
  }
}
