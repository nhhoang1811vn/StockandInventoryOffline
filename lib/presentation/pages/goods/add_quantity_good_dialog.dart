import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/presentation/widgets/circle_button_widget.dart';
import 'package:sprintf/sprintf.dart';

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

  void showCalculatorPopup(BuildContext context) async {
    var calc = SimpleCalculator(
      value: double.parse(quantityTextController.text),
      onChanged: (key, value, expression) {
        quantityTextController.text = value!.toInt().toString();
        //context.read<SaveGoodCubit>().quantityChanged(quantityTextController.text);
      },
      theme: const CalculatorThemeData(
        displayColor: Colors.white,
        displayStyle: const TextStyle(fontSize: 20, color: Colors.blue),
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: calc);
        });
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
                widget.good.description.isNotEmpty ? Text(widget.good.description) : Container(),
                widget.good.barCode != null ? Text(widget.good.barCode!) : Container(),
                Text(sprintf(AppLocalizations.of(context)!.in_stock_text, [widget.good.quantity])),
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
                      child: CircleButton(UIConstants.calculatorIconData, () => showCalculatorPopup(context))
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
