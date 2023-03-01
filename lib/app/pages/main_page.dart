import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/app/pages/customers/customers_view.dart';
import 'package:good_manager/app/pages/documents/documents_view.dart';
import 'package:good_manager/app/pages/expenses/expenses_view.dart';
import 'package:good_manager/app/pages/home/home_view.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/settings/settings_view.dart';
import 'package:good_manager/app/pages/stores/stores_view.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_view.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/app_data_manager.dart';
import 'goods/goods_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'help_content.dart';
import '../widgets/select_message_type_dialog.dart';


class CustomNavigationDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          buildMenuItems(context)
        ],
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
  );

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      //runSpacing: 4,//vertical spacing
    children: [
      ListTile(
        leading: Image.asset(UIConstants.homeIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).home_title),
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        },
      ),
      Divider(),
      ListTile(
        leading: Image.asset(UIConstants.goodIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).goods_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => GoodsPage(isSelection: false)));
        },
      ),
      ListTile(
        leading: Image.asset(UIConstants.documentIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).documents_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => DocumentsPage()));
        },
      ),
      ListTile(
        leading: Image.asset(UIConstants.expenseIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).expenses_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => ExpensesPage()));
        },
      ),
      ListTile(
        leading: Image.asset(UIConstants.reportIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).report_title),
        onTap: () {
          Navigator.pop(context);
          //Navigator.of(context).push(MaterialPageRoute(builder:(context) => Report()));
        },
      ),
      Divider(),
      ListTile(
        leading: Image.asset(UIConstants.supplierIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).suppliers_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => SuppliersPage(isSelection: false)));
        },
      ),
      ListTile(
        leading: Image.asset(UIConstants.customerIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).customers_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => CustomersPage(isSelection: false)));
        },
      ),
      ListTile(
        leading: Image.asset(UIConstants.storeIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).stores_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => StoresPage(isSelection: false)));
        },
      ),
      Divider(),
      ListTile(
        leading: Image.asset(UIConstants.settingsIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).settings_title),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
        },
      ),
      ListTile(
        leading: Image.asset(UIConstants.invitationIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).menu_item_invite_friend_header),
        //subtitle: Text(AppLocalizations.of(context).menu_item_invite_friend_description),
        onTap: () => onInviteFriend(context),
      ),
      ListTile(
        leading: Image.asset(UIConstants.feedbackIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).question_or_suggestion_title),
        onTap: () => onSelectMessageType(context),
      ),
      ListTile(
        leading: Image.asset(UIConstants.helpIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).help_title),
        onTap: () => onHelp(context),
      ),
      ListTile(
        leading: Image.asset(UIConstants.communityIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).menu_item_community_header),
        onTap: () => onCommunity(context),
      ),
      ListTile(
        leading: Image.asset(UIConstants.whatsnewIconPath, width: UIConstants.drawerMenuSize),
        title: Text(AppLocalizations.of(context).whats_new_title),
        onTap: () => onWhatsNew(context),
      )
    ]),
  );
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
        AppLocalizations.of(context).send_mail_invite_friend_subject,
        'body':
        AppLocalizations.of(context).send_mail_invite_friend_content,
      }),
    );

    launch(emailLaunchUri.toString());
  }
  void onSelectMessageType(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SelectMessageTypeDialog((messageType) {
          switch(messageType){
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
  void onBugReport(BuildContext context){
    String subject = AppLocalizations.of(context).send_mail_bug_report_subject;
    onSendMail(subject);
  }
  void onSuggestion(BuildContext context){
    String subject = AppLocalizations.of(context).send_mail_suggestion_subject;
    onSendMail(subject);
  }
  void onQuestion(BuildContext context){
    String subject = AppLocalizations.of(context).send_mail_question_subject;
    onSendMail(subject);
  }
  void onFeedback(BuildContext context){
    String subject = AppLocalizations.of(context).send_mail_feedback_subject;
    onSendMail(subject);
  }
  void onSendMail(String subject){
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': ""
      }),
    );
    launchUrl(emailLaunchUri);
    //launch(emailLaunchUri.toString());
  }

  void onWhatsNew(BuildContext context) async{
    String code = await appDataManager.sharedPrefsHelper.getLanguageCode();
    Navigator.of(context).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(context).menu_item_whats_new_header,
      "content": HelpUtils.getMarkdownData(code, HelpType.WHATSNEW)
    });
  }
  void onHelp(BuildContext context){

  }
  void onCommunity(BuildContext context) async{
    String url = "fb://profile/112596241092855";
    String fallbackUrl = "https://www.facebook.com/AppViet-Qu%E1%BA%A3n-l%C3%BD-kho-112596241092855";
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
