import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';

import '../style_size.dart';
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

class SelectMessageTypeDialog extends StatefulWidget {
  final void Function(MessageType messageType) onValueChange;


  SelectMessageTypeDialog(this.onValueChange);

  @override
  SelectMessageTypeDialogState createState() => SelectMessageTypeDialogState();
}

class SelectMessageTypeDialogState extends State<SelectMessageTypeDialog> {
  late MessageType _messageType;

  @override
  void initState() {
    _messageType = MessageType.BUG_REPORT;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.message_type),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var type in MessageType.values)...[
                  getRadioListTile(type)
                ]
                //getRadioListTile(MessageType.BUG_REPORT, AppLocalizations.of(context)!.message_type_bug_report),
                //getRadioListTile(MessageType.FEEDBACK, AppLocalizations.of(context)!.message_type_feedback),
                //getRadioListTile(MessageType.SUGGESTION, AppLocalizations.of(context)!.message_type_suggestion),
                //getRadioListTile(MessageType.QUESTION, AppLocalizations.of(context)!.message_type_question)

              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            widget.onValueChange(_messageType);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<MessageType> getRadioListTile(MessageType value) {
    return RadioListTile<MessageType>(
      title: Text(value.getText(context), style: TextStyle(fontSize: TextSize.medium)),
      value: value,
      groupValue: _messageType,
      onChanged: (MessageType? value) {
        setState(() {
          _messageType = value!;
        });
      },
      dense: true,
    );
  }
}
