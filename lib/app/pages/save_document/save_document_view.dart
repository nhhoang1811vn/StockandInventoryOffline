import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/widgets/custom_action_row.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/domain/entities/document.dart';

import 'save_document_controller.dart';

class SaveDocumentPage extends View {
  final bool isInsert;
  final Document item;

  SaveDocumentPage(this.isInsert, this.item) : super();

  @override
  SaveDocumentPageView createState() =>
      SaveDocumentPageView(this.isInsert, this.item);
}

class SaveDocumentPageView
    extends ViewState<SaveDocumentPage, SaveDocumentController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Document item;

  SaveDocumentPageView(isInsert, this.item)
      : super(SaveDocumentController(DataDocumentRepository(),
            DataDocumentTransactionRepository(), isInsert, item));

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop(false);
  }

  String getTitle() {
    switch (item.type) {
      case DocumentType.incoming:
        return "Giao Dịch Nhập";
      case DocumentType.outgoing:
        return "Giao Dịch Xuất";
      case DocumentType.stock_taking:
        return "Giao Dịch Kiểm Kê";
    }
  }

  Widget get body => ListView(children: <Widget>[
        Form(
            key: _formKey,
            child: Padding(
              child: Column(children: <Widget>[
                name,
                date,
                supplier,
                description,
                goodHeader
              ]),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            ))
      ]);

  @override
  Widget get view => WillPopScope(
      key: globalKey,
      child: Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: ControlledWidgetBuilder<SaveDocumentController>(
            builder: (context, controller) {
          return FloatingActionButton.extended(
            onPressed: controller.onAddGood,
            label: const Text('Thêm sản phẩm'),
            icon: const Icon(Icons.add_photo_alternate),
            backgroundColor: Colors.blue,
          );
        }),
      ),
      onWillPop: _onBackPressed);

  Widget get appBar => AppBar(title: Text(getTitle()), actions: <Widget>[
        ControlledWidgetBuilder<SaveDocumentController>(
            builder: (context, controller) {
          return CustomActionsRow(
              availableWidth: MediaQuery.of(context).size.width /
                  2, // half the screen width
              actionWidth: 48, // default for IconButtons
              actions: [
                CustomAction(
                  visibleWidget: IconButton(
                    onPressed: controller.onSaveDocumentTapped,
                    icon: Icon(Icons.check),
                  ),
                  showAsAction: ShowAsAction.ALWAYS,
                ),
                CustomAction(
                  overflowWidget: GestureDetector(
                    onTap: () {},
                    child: const Text("Sắp xếp"),
                  ),
                  showAsAction: ShowAsAction.NEVER,
                ),
                CustomAction(
                  overflowWidget: GestureDetector(
                    onTap: () {},
                    child: const Text("Trợ giúp"),
                  ),
                  showAsAction: ShowAsAction.NEVER,
                ),
              ]);
        })
      ]);

  Widget get name => ControlledWidgetBuilder<SaveDocumentController>(
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

  Widget get date => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return DateTimePicker(
          type: DateTimePickerType.date,
          controller: controller.dateTextController,
          dateMask: 'dd/MM/yyyy',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          dateLabelText: 'Ngày Tạo',
        );
      });

  Widget get supplier => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return TextFormField(
          onTap: controller.onSupplierTapped,
          controller: controller.supplierTextController,
          decoration: InputDecoration(labelText: 'Nhà Cung Cấp'),
        );
      });

  Widget get description => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return TextFormField(
          controller: controller.descriptionTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_desc),
        );
      });

  Widget get goodHeader => Container(
      color: Colors.blue[800],
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Danh Sách Sản Phẩm',
              style: TextStyle(color: Colors.white))));
}
