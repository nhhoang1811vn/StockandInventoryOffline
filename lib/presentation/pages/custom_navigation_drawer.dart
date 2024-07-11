import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/dialog_utils.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/widgets/select_message_type_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/path_utils.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({Key? key, required this.selectedIndex, required this.storeName}) : super(key: key);
  final int selectedIndex;
  final String storeName;

  @override
  CustomNavigationDrawerState createState() {
    return CustomNavigationDrawerState();
  }
}

class CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  var _storeName = "";

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _storeName = widget.storeName;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.only(top: 48),
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                              "${FirebaseAuth.instance.currentUser?.displayName}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${FirebaseAuth.instance.currentUser?.email}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],),
                          Spacer(),
                          IconButton(onPressed: (){
                            DialogUtils.showCustomDialog(context,
                                title: AppLocalizations.of(context)!.notification_dialog_title,
                                message: AppLocalizations.of(context)!.signout_message,
                                okBtnFunction: () async{
                                  String dbPath = await PathUtils().getDatabasePath();
                                  File file = File(dbPath);
                                  final storageRef = FirebaseStorage.instance.ref();
                                  String? email = FirebaseAuth.instance.currentUser?.email;
                                  final ref = storageRef.child("$email/database.db");
                                  try {
                                    await ref.putFile(file);
                                  } on FirebaseException {
                                  }
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushNamedAndRemoveUntil(Pages.signIn, (route) => false);
                                },
                                cancelBtnText: AppLocalizations.of(context)!.action_cancel,

                            );
                            }, icon: Icon(Icons.logout, color: Colors.white))
                        ],),

                        Text(
                          _packageInfo.appName + " (${_packageInfo.version})",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                    Text("Cửa hàng đang chọn", style: TextStyle(fontSize: 12, color: Colors.white))
                      ],
                    )),
                SizedBox(height: 8),
                GestureDetector(
                    child: Container(
                        color: UIConstants.primaryDarkColor,
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              _storeName,
                              style: TextStyle(color: Colors.white),
                            )),
                            Icon(
                              Icons.expand_circle_down_sharp,
                              color: Colors.white,
                            )
                          ],
                        )),
                    onTap: () => onChangeStore(context))
              ],
            ),
          ),
          AppDrawerTile(
              index: 0,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.home_title,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Pages.home);
                //updateState(0);
              }),
          AppDrawerTile(
              index: 1,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.goods_title,
              onTap: () {
                //updateState(1);
                Navigator.of(context).pushReplacementNamed(Pages.good_list, arguments: {'isSelection': false});
              }),
          AppDrawerTile(
              index: 2,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.documents_title,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Pages.document_list);
              }),
          AppDrawerTile(
              index: 3,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.expenses_title,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Pages.expenses);
              }),
          AppDrawerTile(
              index: 4,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.report_title,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Pages.report);
              }),
          Divider(),
          AppDrawerTile(
              index: 5,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.suppliers_title,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Pages.supplier_list);
              }),
          AppDrawerTile(
              index: 6,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.customers_title,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Pages.customer_list);
              }),
          AppDrawerTile(
              index: 7,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.stores_title,
              onTap: () {
                //updateState(5);
                Navigator.of(context).pushReplacementNamed(Pages.store_list, arguments: {"isSelection": false});
              }),
          Divider(),
          AppDrawerTile(
              index: 8,
              selectedIndex: widget.selectedIndex,
              text: AppLocalizations.of(context)!.settings_title,
              onTap: () {
                //updateState(5);
                Navigator.of(context).pushReplacementNamed(Pages.settings);
              }),
          ListTile(
            leading: Icon(FontAwesomeIcons.paperPlane, size: UIConstants.drawerMenuSize),
            title: Text(AppLocalizations.of(context)!.menu_item_invite_friend_header),
            onTap: () => onInviteFriend(context),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.circleQuestion, size: UIConstants.drawerMenuSize),
            title: Text(AppLocalizations.of(context)!.question_or_suggestion_title),
            onTap: () => onSelectMessageType(context),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.circleInfo, size: UIConstants.drawerMenuSize),
            title: Text(AppLocalizations.of(context)!.help_title),
            onTap: () => onHelp(context),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.comments, size: UIConstants.drawerMenuSize),
            title: Text(AppLocalizations.of(context)!.menu_item_community_header),
            onTap: () => onCommunity(context),
          ),
          ListTile(
            leading: Icon(Icons.coffee, size: UIConstants.drawerMenuSize),
            title: Text(AppLocalizations.of(context)!.menu_item_donation),
            onTap: () => onDonation(context),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.flag, size: UIConstants.drawerMenuSize),
            title: Text(AppLocalizations.of(context)!.whats_new_title),
            onTap: () => onWhatsNew(context),
          )
        ],
      ),
    );
  }
  void onChangeStore(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(Pages.store_list, arguments: {"isSelection": true});
    if (result != null) {
      Store store = result as Store;

      storage.setSelectedStoreId(store.id!);
      storage.setSelectedStoreName(store.name);

      if (widget.selectedIndex == 0) {
        Navigator.of(context).pushReplacementNamed(Pages.home);
      } else if (widget.selectedIndex == 1) {
        Navigator.of(context).pushReplacementNamed(Pages.good_list, arguments: {"isSelection": false});
      } else if (widget.selectedIndex == 2) {
        Navigator.of(context).pushReplacementNamed(Pages.document_list);
      } else if (widget.selectedIndex == 3) {
        Navigator.of(context).pushReplacementNamed(Pages.expenses);
      } else if (widget.selectedIndex == 4) {
        Navigator.of(context).pushReplacementNamed(Pages.report);
        //report
      } else if (widget.selectedIndex == 5) {
        //supplier
        Navigator.of(context).pushReplacementNamed(Pages.supplier_list);
      } else if (widget.selectedIndex == 6) {
        //customer
        Navigator.of(context).pushReplacementNamed(Pages.customer_list);
      } else if (widget.selectedIndex == 7) {
        //store
        setState(() {
          _storeName = store.name;
        });
      } else {
        setState(() {
          _storeName = store.name;
        });
      }

    }
  }

  void onInviteFriend(BuildContext context) {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
      query: encodeQueryParameters(<String, String>{
        'subject': AppLocalizations.of(context)!.send_mail_invite_friend_subject,
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
      return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: encodeQueryParameters(<String, String>{'subject': subject, 'body': ""}),
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

  void onCommunity(BuildContext context) async {
    String url = "fb://profile/112596241092855";
    String fallbackUrl = "https://www.facebook.com/AppViet-Qu%E1%BA%A3n-l%C3%BD-kho-112596241092855";
    try {
      bool launched = await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void onDonation(BuildContext context) {
    Navigator.of(context).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(context)!.menu_item_donation,
      "content": MDProviderFactory.get().getDonationText()
    });
  }
}

class AppDrawerTile extends StatelessWidget {
  const AppDrawerTile(
      {Key? key, required this.index, required this.selectedIndex, required this.text, required this.onTap})
      : super(key: key);

  final int index;
  final String text;
  final int selectedIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(left: 8.0, right: 8.0),
      decoration: (selectedIndex == index) ? BoxDecoration(color: Colors.blue.shade100) : null,
      child: ListTile(
        leading: Icon(
          Defaults.drawerItemIcon[index],
          size: UIConstants.drawerMenuSize,
        ),
        // Image.asset(Defaults.drawerItemIcon[index],),
        onTap: onTap,
        selected: selectedIndex == index,
        title: Text(
          text,
          style: TextStyle(),
        ),
      ),
    );
  }
}

class Defaults {
  static final drawerItemIcon = [
    UIConstants.homeIconData,
    UIConstants.goodIconData,
    UIConstants.documentIconData,
    UIConstants.expenseIconData,
    UIConstants.reportIconData,
    UIConstants.supplierIconData,
    UIConstants.customerIconData,
    UIConstants.storeIconData,
    UIConstants.settingIconData
  ];
}
