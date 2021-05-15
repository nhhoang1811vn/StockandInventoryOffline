import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_group/save_group_controller.dart';
import 'package:good_manager/data/repositories/data_group_repository.dart';
import 'package:good_manager/domain/entities/Group.dart';

class SaveGroupPage extends View {
  final bool isInsert;
  final Group item;

  SaveGroupPage(this.isInsert, this.item) : super();

  @override
  SaveGroupPageView createState() => SaveGroupPageView(isInsert, item);
}

class SaveGroupPageView extends ViewState<SaveGroupPage, SaveGroupController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SaveGroupPageView(isInsert, item)
      : super(SaveGroupController(DataGroupRepository(), isInsert, item));

  @override
  Widget get view => Scaffold(
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
      ));

  Widget get appBar => AppBar(title: Text('Thêm nhóm'), actions: <Widget>[
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
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).field_name),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return "error";
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
              decoration: InputDecoration(labelText: 'Mã vạch'),
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
}
