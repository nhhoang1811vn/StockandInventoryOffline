import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/more/select_message_type_dialog.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../help_content.dart';
import '../pages.dart';

class MoreController extends Controller {
  @override
  void initListeners() {}

  void openStoresPage() {
    Navigator.of(getContext()).pushNamed(Pages.store_list);
  }

  void openSettingsPage() {
    Navigator.of(getContext()).pushNamed(Pages.settings);
  }

  void onInviteFriend() {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nhhoang1811vn@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject':
            AppLocalizations.of(getContext()).send_mail_invite_friend_subject,
        'body':
            AppLocalizations.of(getContext()).send_mail_invite_friend_content,
      }),
    );

    launch(emailLaunchUri.toString());
  }

  void onSelectMessageType() {
    showDialog(
        context: getContext(),
        builder: (_) => SelectMessageTypeDialog((messageType) {
          switch(messageType){
            case MessageType.BUG_REPORT:
              onBugReport();
              break;
            case MessageType.FEEDBACK:
              onFeedback();
              break;
            case MessageType.SUGGESTION:
              onSuggestion();
              break;
            case MessageType.QUESTION:
              onQuestion();
              break;
          }
        }),
        barrierDismissible: true);
  }
  void onBugReport(){
    String subject = AppLocalizations.of(getContext()).send_mail_bug_report_subject;
    onSendMail(subject);
  }
  void onSuggestion(){
    String subject = AppLocalizations.of(getContext()).send_mail_suggestion_subject;
    onSendMail(subject);
  }
  void onQuestion(){
    String subject = AppLocalizations.of(getContext()).send_mail_question_subject;
    onSendMail(subject);
  }
  void onFeedback(){
    String subject = AppLocalizations.of(getContext()).send_mail_feedback_subject;
    onSendMail(subject);
  }
  void onSendMail(String subject){
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    //TODO body empty
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nhhoang1811vn@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': ""
      }),
    );

    launch(emailLaunchUri.toString());
  }

  void onWhatsNew() async{
    String code = await appDataManager.sharedPrefsHelper.getLanguageCode();
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(getContext()).menu_item_whats_new_header,
      "content": HelpUtils.getMarkdownData(code, HelpType.WHATSNEW)
    });
  }
  void launchSocial(String url, String fallbackUrl) async {
    // Don't use canLaunch because of fbProtocolUrl (fb://)
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