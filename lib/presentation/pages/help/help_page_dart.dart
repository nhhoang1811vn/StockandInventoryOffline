import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  final String title;
  final String content;

  HelpPage({Key? key, required this.title, required this.content})
      : super(key: key);

 @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(title: Text(title)),
       body: Markdown(
         data: content,
         onTapLink: (text, url, title){
           launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication,);
          // launchUrl(Uri.parse(url!)); /*For url_launcher 6.1.0 and higher*/
           // launch(url);  /*For url_launcher 6.0.20 and lower*/
         },
       ));
  }
}
