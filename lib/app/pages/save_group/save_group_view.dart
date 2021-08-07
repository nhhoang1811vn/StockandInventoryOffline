import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_group/save_group_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_group_repository.dart';
import 'package:good_manager/domain/entities/group.dart';

class SaveGroupPage extends View {
  final Group item;

  SaveGroupPage(this.item) : super();

  @override
  SaveGroupPageView createState() => SaveGroupPageView(item);
}

class SaveGroupPageView extends ViewState<SaveGroupPage, SaveGroupController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SaveGroupPageView(item)
      : super(SaveGroupController(DataGroupRepository(), item));

  @override
  Widget get view => ControlledWidgetBuilder<SaveGroupController>(
          builder: (context, controller) {
        return WillPopScope(
          key: globalKey,
          child: Scaffold(
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
                          children: <Widget>[name, description, barCode],
                        ),
                      ))
                ],
              )),
          onWillPop: controller.onWillPop,
        );
      });

  Widget get appBar => AppBar(
          title: Text(AppLocalizations.of(context).save_group_title),
          actions: <Widget>[
            ControlledWidgetBuilder<SaveGroupController>(
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

  Widget get name => ControlledWidgetBuilder<SaveGroupController>(
          builder: (context, controller) {
        return TextFormField(
            controller: controller.nameTextController,
            onChanged: (a) => controller.validate({
              'context': context,
              'formKey': _formKey,
              'globalKey': globalKey
            }),
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

  Widget get description => ControlledWidgetBuilder<SaveGroupController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get barCode => ControlledWidgetBuilder<SaveGroupController>(
          builder: (context, controller) {
        return Row(
          children: [
            Expanded(
                child: TextFormField(
        keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).field_bar_code),
              controller: controller.barCodeTextController,
            )),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Image.asset(
                      UIConstants.barcodeIconPath,
                      width: 24,
                    ),
                    onPressed: controller.onInputBarCodePressed))
          ],
        );
      });
}
