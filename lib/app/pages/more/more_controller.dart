import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../help_content.dart';
import '../pages.dart';

class MoreController extends Controller {
  @override
  void initListeners() {}

  void openSuppliersPage() {
    Navigator.of(getContext())
        .pushNamed(Pages.supplier_list, arguments: {'isSelection': false});
  }

  void openCustomersPage() {
    Navigator.of(getContext())
        .pushNamed(Pages.customer_list, arguments: {'isSelection': false});
  }

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

  void onFeedback() {
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
        'subject': AppLocalizations.of(getContext()).send_mail_feedback_subject,
        'body': AppLocalizations.of(getContext()).send_mail_feedback_content
      }),
    );

    launch(emailLaunchUri.toString());
  }

  void onWhatsNew() {
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": AppLocalizations.of(getContext()).menu_item_whats_new_header,
      "content": HelpUtils.getMarkdownDataWhatsNew()
    });
  }
}