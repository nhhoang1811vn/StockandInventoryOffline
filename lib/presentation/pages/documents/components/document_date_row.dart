import 'package:flutter/material.dart';

class DocumentDateRow extends StatelessWidget {
  final String text;

  DocumentDateRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: Text(text, style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 16.0))),
      ],
    );
  }
}
