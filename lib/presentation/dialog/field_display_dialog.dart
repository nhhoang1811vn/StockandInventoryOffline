import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/report_detail/bloc/report_detail_cubit.dart';

class ColumnDisplayDialog extends StatefulWidget {
  final List<ColumnReport> columns;

  const ColumnDisplayDialog({super.key, required this.columns});

  @override
  State createState() => ColumnDisplayDialogState();
}

class ColumnDisplayDialogState extends State<ColumnDisplayDialog> {
  late List<bool> visibilityStates;

  @override
  void initState() {
    super.initState();
    visibilityStates = widget.columns.map((field) => field.isVisible).toList();
  }

  Widget _buildCheckbox(ColumnReport column) {
    return Column(
      children: column.values.map((value) {
        return CheckboxListTile(
          dense: true,
          value: column.selectedValues.contains(value),
          onChanged: (isChecked) {
            // This will require setState to trigger UI update if used in a StatefulWidget
            if (isChecked == true) {
              column.selectedValues.add(value);
            } else {
              column.selectedValues.remove(value);
            }
            setState(() {});
            // Call setState if you're in a StatefulWidget to refresh UI
          },
          title: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr("settings")),
      content: SingleChildScrollView(
        child: Column(
          children: List.generate(widget.columns.length, (index) {
            return Column(
              children: [
                SwitchListTile(
                  dense: true,
                  title: Text(widget.columns[index].title),
                  value: visibilityStates[index],
                  onChanged: (bool? value) {
                    setState(() {
                      visibilityStates[index] = value ?? false;
                    });
                  },
                ),
                if (visibilityStates[index])
                  _buildCheckbox(widget.columns[index]),
              ],
            );
          }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(context.tr("ok")),
          onPressed: () async {
            for (int i = 0; i < widget.columns.length; i++) {
              widget.columns[i].isVisible = visibilityStates[i];
            }
            Navigator.of(context).pop(widget.columns);
          },
        ),
      ],
    );
  }
}
