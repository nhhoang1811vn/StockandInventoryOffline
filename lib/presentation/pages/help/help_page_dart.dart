import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../util/util.dart';

class HelpPage extends StatefulWidget {
  final String title;
  final String content;

  HelpPage({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HelpPageState();
  }
}

class HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Markdown(
        data: widget.content,
        onTapLink: (text, url, title) {
          NavigatorUtils.openUrl(url!);
        },
      ),
    );
  }
}
