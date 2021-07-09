import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';

class AddQuantityGoodDialog extends StatefulWidget {
  final String title;
  final void Function(int quantity) onQuantityAdded;

  AddQuantityGoodDialog(this.title, this.onQuantityAdded);

  @override
  State<StatefulWidget> createState() => AddQuantityGoodDialogState();
}

class AddQuantityGoodDialogState extends State<AddQuantityGoodDialog> {
  TextEditingController quantityTextController;

  AddQuantityGoodDialogState() {
    quantityTextController = TextEditingController();
  }

  void _showCalculatorDialog(BuildContext context) async {
    final result = await showCalculator(context: context) ?? 0;
    quantityTextController.text = result.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).field_quantity,
                      ),
                      controller: quantityTextController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(UIConstants.calculatorIconData),
                        onPressed: () => _showCalculatorDialog(context),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            widget.onQuantityAdded(int.parse(quantityTextController.text));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
