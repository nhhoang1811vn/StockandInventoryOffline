import 'package:flutter/material.dart';

import '../../constant/constant.dart';
import '../../util/util.dart';

class DateItemRow extends StatelessWidget {
  final DateTime date;

  DateItemRow(this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: ColorUtils.getHeaderBgColor(context),
      child: Text(
        DateFormatFactory.getDateFormat().format(date),
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
