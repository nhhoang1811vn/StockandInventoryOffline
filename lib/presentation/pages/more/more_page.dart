import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/main/main_page.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../../common/path_utils.dart';
import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
import '../../../data/data.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../markdown/md_provider_factory.dart';
import '../../widget/widget.dart';
import '../pages.dart';

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MorePageState();
  }
}

class MorePageState extends State<MorePage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _loadIsPro();
  }

  void _loadIsPro() async {
    bool isPro = await RevenueCatService.isPro();
    setState(() {
      _isPro = isPro;
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _buildStockPremiumBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        "Stock Premium Active",
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    return Scaffold(
      appBar: LogoAppBar(),
      body: ListView(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 16),
                _buildProfile(),
                SizedBox(height: 16),
                buildDivider(indent: 0),
                if (isAnonymous)
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.upgrade),
                        title: Text(
                          AppLocalizations.of(context)!
                              .menu_item_upgrade_account,
                        ),
                        onTap: () => onUpgradeAccountItemPressed(),
                      ),
                      buildDivider(),
                    ],
                  ),
                buildDivider(),
                ListTile(
                  leading: Icon(UIConstants.settingIconData),
                  title: Text(AppLocalizations.of(context)!.settings_title),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onSettingsItemPressed(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.production_quantity_limits),
                  title:
                      Text(AppLocalizations.of(context)!.subscriptions_title),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onSubscriptionItemPressed(context),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(UIConstants.storeIconData),
                  title: Text(AppLocalizations.of(context)!.stores_title),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onStoresItemPressed(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.change_circle),
                  title:
                      Text(AppLocalizations.of(context)!.change_tracking_store),
                  subtitle: Text("${AppSettings.getSelectedStoreName()}"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onChangeTrackingStoreItemPressed(context),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.mail_outline),
                  title: Text(
                    AppLocalizations.of(context)!
                        .menu_item_invite_friend_header,
                  ),
                  onTap: () => onInviteFriend(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.question_answer_outlined),
                  title: Text(
                    AppLocalizations.of(context)!.question_or_suggestion_title,
                  ),
                  onTap: () => onSelectMessageType(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.star),
                  title:
                      Text(AppLocalizations.of(context)!.review_the_app_title),
                  onTap: () async {
                    //NotificationService.showNotification(id: 1, title: "title", body: "body");
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    } else {
                      await inAppReview.openStoreListing();
                    }
                  },
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                // ListTile(
                //   leading: Icon(Icons.mail_outline),
                //   title: Text(AppLocalizations.of(context)!
                //       .menu_item_invite_friend_header),
                //   onTap: () => onInviteFriend(context),
                // ),
                // buildDivider(),
                // ListTile(
                //   leading: Icon(Icons.question_answer_outlined),
                //   title: Text(
                //       AppLocalizations.of(context)!.question_or_suggestion_title),
                //   onTap: () => onSelectMessageType(context),
                // ),
                // buildDivider(),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text(AppLocalizations.of(context)!.help_title),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => onHelp(context),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.flag_outlined),
                  title: Text(AppLocalizations.of(context)!.whats_new_title),
                  onTap: () => onWhatsNew(context),
                  trailing: Icon(Icons.navigate_next),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text(AppLocalizations.of(context)!.terms_of_use_title),
                  onTap: () => onTermsOfUse(),
                  trailing: Icon(Icons.navigate_next),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.security),
                  title:
                      Text(AppLocalizations.of(context)!.privacy_policy_title),
                  onTap: () => onPrivacyPolicy(),
                  trailing: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text(
                    AppLocalizations.of(context)!.menu_item_delete_account,
                  ),
                  onTap: () => onDeleteAccountItemPressed(),
                ),
                buildDivider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(AppLocalizations.of(context)!.menu_item_sign_out),
                  //trailing: Icon(Icons.navigate_next),
                  onTap: () => onLogoutItemPressed(),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              sprintf(
                AppLocalizations.of(context)!.version,
                [_packageInfo.version],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final user = FirebaseAuth.instance.currentUser;
    bool isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    String? photoUrl = null;
    String? displayName = null;
    String? email = null;
    if (isAnonymous) {
      photoUrl = null;
      displayName = user?.uid;
      email = "You are currently on guess mode";
    } else {
      photoUrl = user?.photoURL;
      displayName = user?.displayName;

      if (photoUrl == null && user?.providerData.isNotEmpty == true) {
        photoUrl = user!.providerData.first.photoURL;
      }

      if (displayName == null ||
          displayName.isEmpty && user?.providerData.isNotEmpty == true) {
        displayName = user!.providerData.first.displayName;
      }
      email = user?.email ?? "";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        photoUrl != null
            ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(photoUrl),
              )
            : CircleAvatar(
                radius: 30,
                child: Image(
                  image: AssetImage('assets/images/user.png'),
                ),
              ),
        SizedBox(height: 8),
        Text(
          displayName ?? "",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Text(email),
        if (_isPro)
          Column(
            children: [
              SizedBox(height: 8),
              _buildStockPremiumBadge(),
            ],
          ),
      ],
    );
  }

  void onUpgradeAccountItemPressed() {
    Navigator.of(context).pushNamed(Pages.upgrade_account);
  }

  void onDeleteAccountItemPressed() {
    showCustomAlertDialog(
      context,
      message: AppLocalizations.of(context)!.message_confirm_delete_account,
      onPositivePressed: () {
        Navigator.of(context).pop();
        FirebaseAuth.instance.currentUser?.delete();
        FirebaseAuth.instance.signOut();
        ToastUtils.showInfoToast(
          AppLocalizations.of(context)!.delete_account_successful,
        );
      },
    );
  }

  void onStoresItemPressed(BuildContext context) {
    Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": false});
  }

  void onChangeTrackingStoreItemPressed(BuildContext context) async {
    final result = await Navigator.of(context)
        .pushNamed(Pages.store_list, arguments: {"isSelection": true});
    if (result != null) {
      Store store = result as Store;

      AppSettings.setSelectedStoreId(store.id!);
      AppSettings.setSelectedStoreName(store.name);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
  }

  void onSettingsItemPressed(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.settings);
  }

  void onSubscriptionItemPressed(BuildContext context) async {
    await RevenueCatUI.presentPaywall();
    //Navigator.of(context).pushNamed(Pages.subscriptions);
  }

  void onInviteFriend(BuildContext context) {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
      query: encodeQueryParameters(<String, String>{
        'subject':
            AppLocalizations.of(context)!.send_mail_invite_friend_subject,
        'body': AppLocalizations.of(context)!.send_mail_invite_friend_content,
      }),
    );

    NavigatorUtils.openUri(emailLaunchUri);
  }

  void onSelectMessageType(BuildContext context) async {
    var type = await showSelectMessageType(context);
    if (type != null) {
      switch (type) {
        case MessageType.BUG_REPORT:
          onBugReport(context);
          break;
        case MessageType.FEEDBACK:
          onFeedback(context);
          break;
        case MessageType.SUGGESTION:
          onSuggestion(context);
          break;
        case MessageType.QUESTION:
          onQuestion(context);
          break;
      }
    }
  }

  Future<MessageType?> showSelectMessageType(BuildContext context) async {
    return await showModalBottomSheet<MessageType>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.select_message_type,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Column(
              children: MessageType.values
                  .map(
                    (type) => ListTile(
                      title: Text(type.getText(context)),
                      onTap: () => Navigator.pop(context, type),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  final platformInfo = Platform.operatingSystem;

  void onBugReport(BuildContext context) {
    String subject =
        AppLocalizations.of(context)!.send_mail_bug_report_subject +
            " $platformInfo";
    onSendMail(subject);
  }

  void onSuggestion(BuildContext context) {
    String subject =
        AppLocalizations.of(context)!.send_mail_suggestion_subject +
            " $platformInfo";
    onSendMail(subject);
  }

  void onQuestion(BuildContext context) {
    String subject = AppLocalizations.of(context)!.send_mail_question_subject +
        " $platformInfo";
    onSendMail(subject);
  }

  void onFeedback(BuildContext context) {
    String subject = AppLocalizations.of(context)!.send_mail_feedback_subject +
        " $platformInfo";
    onSendMail(subject);
  }

  void onSendMail(String subject) {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: encodeQueryParameters(
        <String, String>{'subject': subject, 'body': ""},
      ),
    );
    NavigatorUtils.openUri(emailLaunchUri);
  }

  void onWhatsNew(BuildContext context) async {
    Navigator.of(context).pushNamed(
      Pages.help,
      arguments: {
        "title": AppLocalizations.of(context)!.menu_item_whats_new_header,
        "content": MDProviderFactory.get().getWhatNews(),
      },
    );
  }

  void onTermsOfUse() async {
    var eulaLink =
        "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/";
    NavigatorUtils.openUrl(eulaLink);
  }

  void onPrivacyPolicy() async {
    var link =
        "https://www.freeprivacypolicy.com/live/441fa2be-af36-49e4-8dd2-880a7d5f19c0";
    NavigatorUtils.openUrl(link);
  }

  void onHelp(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.helps, arguments: {});
  }

  void onDonation(BuildContext context) {
    Navigator.of(context).pushNamed(
      Pages.help,
      arguments: {
        "title": AppLocalizations.of(context)!.menu_item_donation,
        "content": MDProviderFactory.get().getDonationText(),
      },
    );
  }

  void onLogoutItemPressed() {
    showCustomAlertDialog(
      context,
      message: AppLocalizations.of(context)!.signout_message,
      onPositivePressed: () async {
        Navigator.of(context).pop();
        showCustomAlertDialog(
          context,
          message: AppLocalizations.of(context)!.question_push_data,
          onPositivePressed: () async {
            String dbPath = await PathUtils().getDatabasePath();
            File file = File(dbPath);
            final storageRef = FirebaseStorage.instance.ref();
            //String? email = FirebaseAuth.instance.currentUser?.email;
            String? uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid != null) {
              try {
                final ref = storageRef.child("$uid/database.db");
                await ref.putFile(file);
              } on FirebaseException {
              } catch (e) {}
            }
            //clear db
            Navigator.of(context).pop();
            DBHelper dbHelper = DBHelper();
            await dbHelper.reset();
            FirebaseAuth.instance.signOut();
          },
          onNegativePressed: () async {
            Navigator.of(context).pop();
            DBHelper dbHelper = DBHelper();
            await dbHelper.reset();
            FirebaseAuth.instance.signOut();
          },
        );
      },
    );
  }
}
