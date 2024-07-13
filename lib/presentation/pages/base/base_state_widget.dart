import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseStateWidget<T extends StatefulWidget> extends State<T>{
  FocusNode _focusNode = FocusNode();
  final GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey(); // Create a key
  @override
  void initState() {
    super.initState();
  }
  Widget buildWidget(BuildContext context);
  bool hasDrawer(){
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKeyEvent: (input) {
          if (input is KeyDownEvent){
            if (input.logicalKey == LogicalKeyboardKey.escape){
              if (hasDrawer()){
                if (ScaffoldKey.currentState!.isDrawerOpen){
                  ScaffoldKey.currentState!.closeDrawer();
                }else{
                  ScaffoldKey.currentState!.openDrawer();
                }
              }else{
                Navigator.of(context).pop();
              }
            }
          }
        },
        child: buildWidget(context));
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}