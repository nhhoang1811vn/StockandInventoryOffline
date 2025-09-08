import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum MessageType { BUG_REPORT, FEEDBACK, SUGGESTION, QUESTION }

extension MessageTypeExtension on MessageType {
  String getText(BuildContext context) {
    switch (this) {
      case MessageType.BUG_REPORT:
        return context.tr("message_type_bug_report");
      case MessageType.FEEDBACK:
        return context.tr("message_type_feedback");
      case MessageType.SUGGESTION:
        return context.tr("message_type_suggestion");
      case MessageType.QUESTION:
        return context.tr("message_type_question");
    }
  }
}
