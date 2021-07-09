import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpPage extends View {
  final String title;
  final String content;

  HelpPage({Key key, @required this.title, @required this.content})
      : super(key: key);

  @override
  HelpPageView createState() => HelpPageView(title, content);
}
class HelpPageView extends ViewState<HelpPage, HelpController> {
  final String title;
  final String content;

  HelpPageView(this.title, this.content) : super(HelpController());

  @override
  Widget get view => Scaffold(
      appBar: AppBar(title: Text(title)),
      key: globalKey,
      body: Padding(
          padding: EdgeInsets.all(0),
          child: Markdown(
            data: content,
          )));
}

class HelpController extends Controller {
  @override
  void initListeners() {
  }

}