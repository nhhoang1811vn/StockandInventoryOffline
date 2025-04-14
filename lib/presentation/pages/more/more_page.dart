import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/presentation/pages/main/main_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/path_utils.dart';
import '../../../db/db_helper.dart';
import '../../../domain/entities/store.dart';
import '../../../main.dart';
import '../../constants.dart';
import '../../dialog_utils.dart';
import '../../markdown/md_provider_factory.dart';
import '../../widgets/logo_app_bar.dart';
import '../../widgets/select_message_type_dialog.dart';
import '../pages.dart';
import '../settings/components/change_languages_dialog.dart';

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

  //var _storeName = "";

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    //_storeName = widget.storeName;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
    if (displayName.isEmpty) {
      displayName = FirebaseAuth.instance.currentUser?.uid ?? "";
    }
    String email = FirebaseAuth.instance.currentUser?.email ?? "";

    return Scaffold(
      appBar: LogoAppBar(),
      backgroundColor: Colors.grey[100],
      body: ListView(children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 4),
              ListTile(
                tileColor: Colors.white,
                title: Text(displayName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                subtitle:
                    Text(email, style: Theme.of(context).textTheme.bodyMedium),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(Icons.close, size: UIConstants.drawerMenuSize),
                title: Text(
                    AppLocalizations.of(context)!.menu_item_delete_account),
                onTap: () => onDeleteAccountItemPressed(),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(UIConstants.storeIconData,
                    size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!.stores_title),
                trailing: Icon(Icons.navigate_next),
                onTap: () => onStoresItemPressed(context),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading:
                    Icon(Icons.change_circle, size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!.change_tracking_store),
                subtitle:
                    Text("${storage.getSelectedStoreName()}"),
                trailing: Icon(Icons.navigate_next),
                onTap: () => onChangeTrackingStoreItemPressed(context),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(UIConstants.settingIconData,
                    size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!.settings_title),
                trailing: Icon(Icons.navigate_next),
                onTap: () => onSettingsItemPressed(context),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(FontAwesomeIcons.language),
                title:
                Text(AppLocalizations.of(context)!.menu_item_language_title),
                subtitle:
                Text(AppLocalizations.of(context)!.menu_item_language_desc),
                onTap: (){ showSelectLanguageDialog(context);},
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 4),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(FontAwesomeIcons.paperPlane,
                    size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!
                    .menu_item_invite_friend_header),
                onTap: () => onInviteFriend(context),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(FontAwesomeIcons.circleQuestion,
                    size: UIConstants.drawerMenuSize),
                title: Text(
                    AppLocalizations.of(context)!.question_or_suggestion_title),
                onTap: () => onSelectMessageType(context),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(FontAwesomeIcons.question,
                    size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!.help_title),
                trailing: Icon(Icons.navigate_next),
                onTap: () => onHelp(context),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(FontAwesomeIcons.flag,
                    size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!.whats_new_title),
                onTap: () => onWhatsNew(context),
                trailing: Icon(Icons.navigate_next),
              ),
              Divider(height: 1,),
              ListTile(
                tileColor: Colors.white,
                leading: Icon(Icons.logout, size: UIConstants.drawerMenuSize),
                title: Text(AppLocalizations.of(context)!.menu_item_sign_out),
                trailing: Icon(Icons.navigate_next),
                onTap: () => onLogoutItemPressed(),
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
        Center(child: Text(sprintf(AppLocalizations.of(context)!.version, [_packageInfo.version]))),
        SizedBox(height: 16),
      ]),
    );
  }

  void onDeleteAccountItemPressed() {
    DialogUtils.showCustomDialog(context,
        title: AppLocalizations.of(context)!.notification_dialog_title,
        message: AppLocalizations.of(context)!.message_confirm_delete_account,
        cancelBtnText: AppLocalizations.of(context)!.action_cancel,
        okBtnText: AppLocalizations.of(context)!.action_ok, cancelBtnFunction: () {
      Navigator.of(context).pop();
    }, okBtnFunction: () {
      FirebaseAuth.instance.currentUser?.delete();
      FirebaseAuth.instance.signOut();
      showInfoToast(AppLocalizations.of(context)!.delete_account_successful);
      //Navigator.of(context).pop();
      Navigator.of(context).pushNamedAndRemoveUntil(
        Pages.signIn, (route) => false,
      );
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

  void onHelp(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.helps, arguments: {});
  }

  void onDonation(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(context)!.menu_item_donation,
      "content": MDProviderFactory.get().getDonationText()
    });
  }
  void showSelectLanguageDialog(BuildContext context) async {
    String currentCode = storage.getLanguageCode();
    showDialog(
        context: context,
        builder: (_) => ChangeLanguagesDialog(currentCode, (code) {
          storage.setLanguageCode(code);
          MyApp.setLocale(context, code);
    }), barrierDismissible: true);
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

            } catch (e){

            }
          }
          //clear db
          DBHelper dbHelper = DBHelper();
          await dbHelper.reset();
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            Pages.signIn, (route) => false,
          );
        }, cancelBtnFunction: () async {
          //clear db
          DBHelper dbHelper = DBHelper();
          await dbHelper.reset();

          FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            Pages.signIn, (route) => false,
          );
        },
            okBtnText: AppLocalizations.of(context)!.action_ok,
            cancelBtnText: AppLocalizations.of(context)!.action_cancel);
      },
      cancelBtnText: AppLocalizations.of(context)!.action_cancel,
    );
  }
}
