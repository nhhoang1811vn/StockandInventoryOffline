import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';

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
      appBar:
          new AppBar(title: new Text(AppLocalizations.of(context).title_more)),
      body: ListView(
        key: globalKey,
        children: [
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
            return ListTile(
              leading: Image.asset(UIConstants.storeIconPath, width: 24),
              title: Text(AppLocalizations.of(context).stores_title),
              subtitle: Text(AppLocalizations.of(context).stores_description),
              onTap: () => controller.openStoresPage(),
            );
          }),
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
            return ListTile(
              leading: Image.asset(UIConstants.supplierIconPath, width: 24),
              title: Text(AppLocalizations.of(context).suppliers_title),
              subtitle:
                  Text(AppLocalizations.of(context).suppliers_description),
              onTap: () => controller.openSuppliersPage(),
            );
          }),
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
            return ListTile(
              leading: Image.asset(UIConstants.customerIconPath, width: 24),
              title: Text(AppLocalizations.of(context).customers_title),
              subtitle:
                  Text(AppLocalizations.of(context).customers_description),
              onTap: () => controller.openCustomersPage(),
            );
          }),
          ListTile(
            dense: true,
            title: Text('Other SSTeam Experiences'),
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
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
            return ListTile(
              leading: Image.asset(UIConstants.invitationIconPath, width: 24),
              title: Text(
                  AppLocalizations.of(context).menu_item_invite_friend_header),
              subtitle: Text(AppLocalizations.of(context)
                  .menu_item_invite_friend_description),
              onTap: () => controller.onInviteFriend(),
            );
          }),
          ListTile(
            leading: Image.asset(UIConstants.ratingIconPath, width: 24),
            title: Text(
                AppLocalizations.of(context).menu_item_write_review_header),
            subtitle: Text(AppLocalizations.of(context)
                .menu_item_write_review_description),
          ),
          ControlledWidgetBuilder<MoreController>(
              builder: (context, controller) {
            return ListTile(
              leading: Image.asset(UIConstants.feedbackIconPath, width: 24),
              title:
                  Text(AppLocalizations.of(context).menu_item_feedback_header),
              subtitle: Text(
                  AppLocalizations.of(context).menu_item_feedback_description),
              onTap: () => controller.onFeedback(),
            );
          }),
          ListTile(
            leading: Image.asset(UIConstants.communityIconPath, width: 24),
            title:
                Text(AppLocalizations.of(context).menu_item_community_header),
            subtitle: Text(
                AppLocalizations.of(context).menu_item_community_description),
          )
        ],
      ));
}
