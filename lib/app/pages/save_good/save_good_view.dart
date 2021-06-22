import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_good/save_good_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/domain/entities/good.dart';

class SaveGoodPage extends View {
  final Good item;
  final int quantity;

  SaveGoodPage(this.item, [this.quantity]) : super();

  @override
  SaveGroupPageView createState() => SaveGroupPageView(item, quantity);
}

class SaveGroupPageView extends ViewState<SaveGoodPage, SaveGoodController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SaveGroupPageView(item, quantity)
      : super(SaveGoodController(DataGoodRepository(),
            DataDocumentTransactionRepository(), item, quantity));

  @override
  Widget get view => Scaffold(
      key: globalKey,
      appBar: appBar,
      body: ListView(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[
                    name,
                    description,
                    barCode,
                    ControlledWidgetBuilder<SaveGoodController>(
                        builder: (context, controller) {
                      return Visibility(
                        child: quantity,
                        visible: controller.quantity != null,
                      );
                    })
                  ],
                ),
              ))
        ],
      ));

  Widget get appBar => AppBar(
          title: Text(AppLocalizations.of(context).title_save_goods),
          actions: <Widget>[
            ControlledWidgetBuilder<SaveGoodController>(
                builder: (context, controller) {
              return Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () => controller.checkForm({
                            'context': context,
                            'formKey': _formKey,
                            'globalKey': globalKey
                          }),
                      child: Icon(Icons.check, size: 26)));
            })
          ]);

  Widget get name => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return TextFormField(
            controller: controller.nameTextController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).field_name),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return AppLocalizations.of(context).message_name_blank;
              } else {
                return null;
              }
            });
      });

  Widget get description => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get barCode => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Row(
          children: [
            Expanded(
                child: TextFormField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).field_bar_code),
              controller: controller.barCodeTextController,
            )),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(Icons.qr_code_rounded, size: 28),
                    onPressed: controller.onInputBarCodePressed))
          ],
        );
      });

  Widget get quantity => ControlledWidgetBuilder<SaveGoodController>(
          builder: (context, controller) {
        return Row(
          children: [
            Expanded(
                child: TextFormField(
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).field_quantity),
              controller: controller.quantityTextController,
            )),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(UIConstants.calculatorIconData, size: 28),
                    onPressed: controller.onInputQuantityPressed))
          ],
        );
      });
}
