import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_expense/save_expense_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_expense_repository.dart';
import 'package:good_manager/domain/entities/expense.dart';

class SaveExpensePage extends View {
  final Expense item;

  SaveExpensePage({Key key, @required this.item}) : super(key: key);

  @override
  _SaveExpensePageView createState() => _SaveExpensePageView(item);
}

class _SaveExpensePageView
    extends ViewState<SaveExpensePage, SaveExpenseController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _SaveExpensePageView(item)
      : super(SaveExpenseController(DataExpenseRepository(), item));

  @override
  Widget get view => ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
        return WillPopScope(
            child: Scaffold(
                key: globalKey,
                appBar: AppBar(
                    title:
                        Text(AppLocalizations.of(context).save_expense_title),
                    actions: <Widget>[save]),
                body: ListView(
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: UIConstants.screenSpace,
                              vertical: UIConstants.screenSpace),
                          child: Column(
                            children: <Widget>[
                              name,
                              description,
                              Row(
                                children: [
                                  Expanded(child: date),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(child: amount),
                                  calculatorButton
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
            onWillPop: controller.onWillPop);
      });

  Widget get name => ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
        return TextFormField(
            controller: controller.nameTextController,
            onChanged: (a) => controller.validate({
                  'context': context,
                  'formKey': _formKey,
                      'globalKey': globalKey
                    }),
                decoration: InputDecoration(labelText: AppLocalizations
                    .of(context)
                    .field_name),
                validator: (String value) {
                  if (value
                      .trim()
                      .isEmpty) {
                    return AppLocalizations
                        .of(context)
                        .message_name_blank;
                  } else {
                    return null;
                  }
                });
          });

  Widget get description =>
      ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
            return TextFormField(
              controller: controller.descriptionTextController,
              decoration: InputDecoration(
                  labelText: AppLocalizations
                      .of(context)
                      .field_desc),
            );
          });

  Widget get date =>
      ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
            return DateTimePicker(
              type: DateTimePickerType.date,
              controller: controller.dateTextController,
              dateMask: 'dd/MM/yyyy',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: AppLocalizations
                  .of(context)
                  .field_date,
            );
          });

  Widget get amount =>
      ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
            return TextFormField(
              keyboardType: TextInputType.number,
              controller: controller.amountTextController,
              decoration: InputDecoration(
                  labelText: AppLocalizations
                      .of(context)
                      .field_amount),
            );
          });

  Widget get calculatorButton =>
      ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
            return IconButton(icon: Image.asset(
              UIConstants.calculatorIconPath,
              width: 24,
            ), onPressed: controller.onOpenCalculator);
          });

  Widget get save =>
      ControlledWidgetBuilder<SaveExpenseController>(
          builder: (context, controller) {
            return Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () =>
                      controller.checkForm({
                        'context': context,
                        'formKey': _formKey,
                        'globalKey': globalKey
                      }),
                  child: Icon(Icons.check, size: 26)),
            );
          });
}
