import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpPageWidget extends StatefulWidget{
  HelpPageWidget({Key key}) : super(key: key);

  static const routeName  = '/app.pages.help';

  @override
  State<HelpPageWidget> createState() {
    return HelpPageWidgetState();
  }
}
class HelpPageArguments{
  final String content;
  HelpPageArguments(this.content);
}
class HelpPageWidgetState extends State<HelpPageWidget>{
  @override
  Widget build(BuildContext context) {
    final HelpPageArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(appBar: AppBar(title: Text('Trợ giúp'),)
      ,body: Padding(padding: EdgeInsets.all(16),child: Text(args.content,style: TextStyle(fontSize: 16),))
    );
  }

}