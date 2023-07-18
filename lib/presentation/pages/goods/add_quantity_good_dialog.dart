import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/good.dart';

class InputQuantityGoodDialog extends StatefulWidget {
  final Good good;
  InputQuantityGoodDialog(this.good);

  @override
  State<StatefulWidget> createState() => InputQuantityGoodDialogState();
}

class InputQuantityGoodDialogState extends State<InputQuantityGoodDialog> {
  late TextEditingController quantityTextController;

  InputQuantityGoodDialogState() {
    quantityTextController = TextEditingController();
    quantityTextController.text = "1";
  }

  void _showCalculatorDialog(BuildContext context) async {
    /*final result = await showCalculator(context: context) ?? 0;
    quantityTextController.text = result.toInt().toString();*/
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.input_quantity_dialog_title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.good.name),
                Text(widget.good.description),
                Text(widget.good.barCode),
                //Text(sprintf(AppLocalizations.of(context)!.in_stock_text, [widget.good.quantity])),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.field_quantity,
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
                        icon: Image.asset(
                          UIConstants.calculatorIconPath,
                          width: 24,
                        ),
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
          child: Text(AppLocalizations.of(context)!.action_cancel),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            Navigator.of(context).pop(int.parse(quantityTextController.text));
          },
        ),
      ],
    );
  }
}
