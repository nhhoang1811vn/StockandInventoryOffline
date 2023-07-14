import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpPage extends StatelessWidget {
  final String title;
  final String content;

  HelpPage({Key? key, required this.title, required this.content})
      : super(key: key);

 @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(title: Text(title)),
       body: Padding(
           padding: EdgeInsets.all(0),
           child: Markdown(
             data: content,
           )));
  }
}
