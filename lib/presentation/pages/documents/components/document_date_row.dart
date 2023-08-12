import 'package:flutter/material.dart';
import 'package:good_manager/presentation/constants.dart';

class DocumentDateRow extends StatelessWidget {
  final String text;

  DocumentDateRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),), color: AppColors.greyColor, padding: EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),);
  }
}
