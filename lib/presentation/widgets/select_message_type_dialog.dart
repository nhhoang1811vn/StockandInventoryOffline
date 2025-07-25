import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
enum MessageType{
  BUG_REPORT,
  FEEDBACK,
  SUGGESTION,
  QUESTION
}

extension MessageTypeExtension on MessageType{
  String getText(BuildContext context){
    switch(this){
      case MessageType.BUG_REPORT:
        return AppLocalizations.of(context)!.message_type_bug_report;
      case MessageType.FEEDBACK:
        return AppLocalizations.of(context)!.message_type_feedback;
      case MessageType.SUGGESTION:
        return AppLocalizations.of(context)!.message_type_suggestion;
      case MessageType.QUESTION:
        return AppLocalizations.of(context)!.message_type_question;

    }
  }
}
