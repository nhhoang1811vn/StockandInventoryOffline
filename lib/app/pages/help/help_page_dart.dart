import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HelpPage extends View {
  final String content;
  HelpPage({Key key, @required this.content}) : super(key: key);
  @override
  HelpPageView createState() => HelpPageView(content);
}

class HelpPageView extends ViewState<HelpPage, HelpController> {
  final String content;
  HelpPageView(this.content) : super(HelpController());
  @override
  Widget get view =>
      Scaffold(appBar: AppBar(title: Text('Trợ giúp')),
          key: globalKey
          , body: Padding(padding: EdgeInsets.all(16),
              child: Text(content, style: TextStyle(fontSize: 16),))
      );
}

class HelpController extends Controller {
  @override
  void initListeners() {
  }

}