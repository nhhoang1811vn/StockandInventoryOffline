import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/main.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/select_message_type_dialog.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/pages/settings/settings_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({Key? key, required this.selectedIndex, required this.storeName})
      : super(key: key);
  final int selectedIndex;
  final String storeName;

  @override
  CustomNavigationDrawerState createState() {
    return CustomNavigationDrawerState();
  }
}

class CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Wrap(
                    children: [
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
                          onTap: (){
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
                            //updateState(5);
                            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => Report()));
                          }),
                      Divider(),
                      AppDrawerTile(
                          index: 5,
                          selectedIndex: widget.selectedIndex,
                          text: AppLocalizations.of(context)!.suppliers_title,
                          onTap: () {
                            //updateState(5);
                            Navigator.of(context).pushReplacementNamed(Pages.supplier_list, arguments: {"isSelection": false});
                          }),
                      AppDrawerTile(
                          index: 6,
                          selectedIndex: widget.selectedIndex,
                          text: AppLocalizations.of(context)!.customers_title,
                          onTap: () {
                            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => CustomersPage(isSelection: false)));
                          }),
                      AppDrawerTile(
                          index: 7,
                          selectedIndex: widget.selectedIndex,
                          text: AppLocalizations.of(context)!.stores_title,
                          onTap: () {
                            //updateState(5);
                            Navigator.of(context).pushReplacementNamed(Pages.store_list, arguments: {"isSelection" : false});
                          }),
                      Divider(),
                      AppDrawerTile(
                          index: 8,
                          selectedIndex: widget.selectedIndex,
                          text: AppLocalizations.of(context)!.settings_title,
                          onTap: () {
                            //updateState(5);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => SettingsPage()));
                          }),
                      ListTile(
                        leading: Image.asset(UIConstants.invitationIconPath,
                            width: UIConstants.drawerMenuSize),
                        title: Text(AppLocalizations.of(context)!
                            .menu_item_invite_friend_header),
                        //subtitle: Text(AppLocalizations.of(context)!.menu_item_invite_friend_description),
                        onTap: () => onInviteFriend(context),
                      ),
                      ListTile(
                        leading: Image.asset(UIConstants.helpIconPath,
                            width: UIConstants.drawerMenuSize),
                        title: Text(AppLocalizations.of(context)!
                            .question_or_suggestion_title),
                        onTap: () => onSelectMessageType(context),
                      ),
                      ListTile(
                        leading: Image.asset(UIConstants.helpIconPath,
                            width: UIConstants.drawerMenuSize),
                        title: Text(AppLocalizations.of(context)!.help_title),
                        onTap: () => onHelp(context),
                      ),
                      ListTile(
                        leading: Image.asset(UIConstants.communityIconPath,
                            width: UIConstants.drawerMenuSize),
                        title: Text(AppLocalizations.of(context)!
                            .menu_item_community_header),
                        onTap: () => onCommunity(context),
                      ),
                      ListTile(
                        leading: Image.asset(UIConstants.whatsnewIconPath,
                            width: UIConstants.drawerMenuSize),
                        title:
                            Text(AppLocalizations.of(context)!.whats_new_title),
                        onTap: () => onWhatsNew(context),
                      )
                    ]),
              )
              //buildMenuItems(context)
            ],
          ),
        ),
      );


  Widget buildHeader(BuildContext context) => Container(
        color: UIConstants.primaryColor,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top),
        child: Column(children: [
          Container(color: UIConstants.primaryColor, padding: EdgeInsets.all(16.0), child: Row(
            children: [
              Image.asset(UIConstants.appIconPath, width: 40),
              SizedBox(width: 8.0),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AppViet Quản Lý Kho",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Text("Ver 1.0.0",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ],
                  ))
            ],
          )),
          GestureDetector(child: Container(color: UIConstants.primaryDarkColor, padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),  child: Row(children: [Expanded(child: Text(widget.storeName, style: TextStyle(color: Colors.white),)), Icon(Icons.expand_circle_down_sharp, color: UIConstants.highlightMenuColor,)],)), onTap: () => onChangeStore())
        ],)
      );

  void onChangeStore() async{
    final result = await Navigator.of(context).pushNamed(Pages.store_list, arguments: {"isSelection" : true});
    if (result != null){
      Store store = result as Store;

      storage.setSelectedStoreId(store.id!);
      storage.setSelectedStoreName(store.name);

      if (widget.selectedIndex == 0){
        Navigator.of(context).pushReplacementNamed(Pages.home);
      }else if (widget.selectedIndex == 1){
        Navigator.of(context).pushReplacementNamed(Pages.good_list, arguments: {"isSelection" : false});
      }else if (widget.selectedIndex == 2){
        Navigator.of(context).pushReplacementNamed(Pages.document_list);
      }else if (widget.selectedIndex == 3){
        Navigator.of(context).pushReplacementNamed(Pages.expenses);
      }else if (widget.selectedIndex == 4){
        //report
      }else if (widget.selectedIndex == 5){
        //supplier
        Navigator.of(context).pushReplacementNamed(Pages.supplier_list, arguments: {"isSelection" : false});
      }else if (widget.selectedIndex == 6){
        //customer
      }else if (widget.selectedIndex == 7){
        //store
      }
    }
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
    //launch(emailLaunchUri.toString());
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
    String fallbackUrl =
        "https://www.facebook.com/AppViet-Qu%E1%BA%A3n-l%C3%BD-kho-112596241092855";
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
}

class AppDrawerTile extends StatelessWidget {
  const AppDrawerTile(
      {Key? key,
      required this.index,
      required this.selectedIndex,
      required this.text,
      required this.onTap})
      : super(key: key);

  final int index;
  final String text;
  final int selectedIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(Defaults.drawerItemIcon[index],
          width: UIConstants.drawerMenuSize),
      onTap: onTap,
      selected: selectedIndex == index,
      title: Text(
        text,
        style: TextStyle(),
      ),
    );
  }
}

class Defaults {
  static final drawerItemIcon = [
    UIConstants.homeIconPath,
    UIConstants.goodIconPath,
    UIConstants.documentIconPath,
    UIConstants.expenseIconPath,
    UIConstants.reportIconPath,
    UIConstants.supplierIconPath,
    UIConstants.customerIconPath,
    UIConstants.storeIconPath,
    UIConstants.settingsIconPath,
  ];
}
