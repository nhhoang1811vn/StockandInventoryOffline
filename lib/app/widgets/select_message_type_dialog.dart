import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum MessageType{
  BUG_REPORT,
  FEEDBACK,
  SUGGESTION,
  QUESTION
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
                getRadioListTile(MessageType.BUG_REPORT, AppLocalizations.of(context)!.message_type_bug_report),
                getRadioListTile(MessageType.FEEDBACK, AppLocalizations.of(context)!.message_type_feedback),
                getRadioListTile(MessageType.SUGGESTION, AppLocalizations.of(context)!.message_type_suggestion),
                getRadioListTile(MessageType.QUESTION, AppLocalizations.of(context)!.message_type_question)

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

  RadioListTile<MessageType> getRadioListTile(MessageType value, String text) {
    return RadioListTile<MessageType>(
      title: Text(text),
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
