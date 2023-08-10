import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:intl/intl.dart';

class DocumentDateRow extends StatelessWidget {
  final String text;

  DocumentDateRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),), color: AppColors.greyColor, padding: EdgeInsets.fromLTRB(16.0, 4.0, 0.0, 4.0),);
  }
}
