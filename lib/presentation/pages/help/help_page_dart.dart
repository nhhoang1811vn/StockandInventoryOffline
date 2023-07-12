import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:good_manager/presentation/pages/base/base_page.dart';
import 'package:good_manager/presentation/pages/help/bloc/help_cubit.dart';
import 'package:good_manager/presentation/pages/help/bloc/help_data.dart';

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
