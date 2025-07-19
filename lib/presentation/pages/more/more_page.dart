import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/main/main_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/path_utils.dart';
import '../../../db/db_helper.dart';
import '../../../domain/entities/store.dart';
import '../../../main.dart';
import '../../../revenuecat_purchase_manager.dart';
import '../../constants.dart';
import '../../dialog_utils.dart';
import '../../markdown/md_provider_factory.dart';
import '../../widgets/logo_app_bar.dart';
import '../../widgets/select_message_type_dialog.dart';
import '../../widgets/views.dart';
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
  void _loadIsPro() async{
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
          borderRadius: BorderRadius.circular(8.0)),
      child: Text(
        "Stock Premium Active",
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
  Widget _buildAnonymousWidget(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Image(
          image: AssetImage('assets/images/user.png'),
          width: 80,
        ),
        SizedBox(height: 8,),
        InkWell(onTap: (){
          onUpgradeAccountItemPressed();
        },child: Column(children: [
          Row(mainAxisSize: MainAxisSize.min,children: [
            Text("Upgrade account", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(width: 8),
            Icon(Icons.navigate_next)
          ],),
          SizedBox(height: 8,),
          Text("You are currently on guess mode")
        ],),)

      ],),
    );
  }
  @override
  Widget build(BuildContext context) {
    String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
    if (displayName.isEmpty) {
      displayName = FirebaseAuth.instance.currentUser?.uid ?? "";
    }
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    bool isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
    return Scaffold(
      appBar: LogoAppBar(),
      body: ListView(children: [
        Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              if (isAnonymous)
                _buildAnonymousWidget()
              else
              Column(
                children: [
                  ListTile(
                    onTap: () => {},
                    title: Text(displayName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(email, style: Theme.of(context).textTheme.bodyMedium),
                        if (_isPro)
                          _buildStockPremiumBadge(),
                      ],
                    ),
                  ),
                  buildDivider(),
                ],
              ),

              ListTile(
                leading: Icon(Icons.close),
                title: Text(
                    AppLocalizations.of(context)!.menu_item_delete_account),
                onTap: () => onDeleteAccountItemPressed(),
              ),
              buildDivider(),
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
                subtitle: Text("${storage.getSelectedStoreName()}"),
                trailing: Icon(Icons.navigate_next),
                onTap: () => onChangeTrackingStoreItemPressed(context),
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
                title: Text(AppLocalizations.of(context)!.subscriptions_title),
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
                leading: Icon(Icons.mail_outline),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_invite_friend_header),
                onTap: () => onInviteFriend(context),
              ),
              buildDivider(),
              ListTile(
                leading: Icon(Icons.question_answer_outlined),
                title: Text(
                    AppLocalizations.of(context)!.question_or_suggestion_title),
                onTap: () => onSelectMessageType(context),
              ),
              buildDivider(),
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
                title: Text(AppLocalizations.of(context)!.privacy_policy_title),
                onTap: () => onPrivacyPolicy(),
                trailing: Icon(Icons.navigate_next),
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
            child: Text(sprintf(AppLocalizations.of(context)!.version,
                [_packageInfo.version]))),
        SizedBox(height: 16),
      ]),
    );
  }

  void onUpgradeAccountItemPressed() {
    Navigator.of(context).pushNamed(Pages.upgrade_account);
  }

  void onDeleteAccountItemPressed() {
    DialogUtils.showCustomDialog(context,
        title: AppLocalizations.of(context)!.notification_dialog_title,
        message: AppLocalizations.of(context)!.message_confirm_delete_account,
        cancelBtnText: AppLocalizations.of(context)!.action_cancel,
        okBtnText: AppLocalizations.of(context)!.action_ok,
        cancelBtnFunction: () {
      Navigator.of(context).pop();
    }, okBtnFunction: () {
      Navigator.of(context).pop();
      FirebaseAuth.instance.currentUser?.delete();
      FirebaseAuth.instance.signOut();
      showInfoToast(AppLocalizations.of(context)!.delete_account_successful);
      //
      //Navigator.of(context).pushNamedAndRemoveUntil(
      //  Pages.signIn,
      //  (route) => false,
      //);
    });
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

      storage.setSelectedStoreId(store.id!);
      storage.setSelectedStoreName(store.name);

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
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
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

    launchUrl(emailLaunchUri);
  }

  void onSelectMessageType(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SelectMessageTypeDialog((messageType) {
              switch (messageType) {
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
            }),
        barrierDismissible: true);
  }

  void onBugReport(BuildContext context) {
    String subject = AppLocalizations.of(context)!.send_mail_bug_report_subject;
    onSendMail(subject);
  }

  void onSuggestion(BuildContext context) {
    String subject = AppLocalizations.of(context)!.send_mail_suggestion_subject;
    onSendMail(subject);
  }

  void onQuestion(BuildContext context) {
    String subject = AppLocalizations.of(context)!.send_mail_question_subject;
    onSendMail(subject);
  }

  void onFeedback(BuildContext context) {
    String subject = AppLocalizations.of(context)!.send_mail_feedback_subject;
    onSendMail(subject);
  }

  void onSendMail(String subject) {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: encodeQueryParameters(
          <String, String>{'subject': subject, 'body': ""}),
    );
    launchUrl(emailLaunchUri);
  }

  void onWhatsNew(BuildContext context) async {
    Navigator.of(context).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(context)!.menu_item_whats_new_header,
      "content": MDProviderFactory.get().getWhatNews()
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void onTermsOfUse() async {
    var eulaLink =
        "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/";
    _launchUrl(Uri.parse(eulaLink));
  }

  void onPrivacyPolicy() async {
    var link =
        "https://www.freeprivacypolicy.com/live/441fa2be-af36-49e4-8dd2-880a7d5f19c0";
    _launchUrl(Uri.parse(link));
  }

  void onHelp(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.helps, arguments: {});
  }

  void onDonation(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(context)!.menu_item_donation,
      "content": MDProviderFactory.get().getDonationText()
    });
  }

  void onLogoutItemPressed() {
    DialogUtils.showCustomDialog(
      context,
      title: AppLocalizations.of(context)!.notification_dialog_title,
      message: AppLocalizations.of(context)!.signout_message,
      okBtnFunction: () async {
        Navigator.of(context).pop();
        DialogUtils.showCustomDialog(context,
            title: AppLocalizations.of(context)!.notification_dialog_title,
            message: AppLocalizations.of(context)!.question_push_data,
            okBtnFunction: () async {
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
        }, cancelBtnFunction: () async {
          Navigator.of(context).pop();
          DBHelper dbHelper = DBHelper();
          await dbHelper.reset();
          FirebaseAuth.instance.signOut();
        },
            okBtnText: AppLocalizations.of(context)!.action_ok,
            cancelBtnText: AppLocalizations.of(context)!.action_cancel);
      },
      cancelBtnText: AppLocalizations.of(context)!.action_cancel,
    );
  }
}
