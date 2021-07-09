import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/goods/good_item_row.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/custom_action_row.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/domain/entities/document.dart';

import 'save_document_controller.dart';

class SaveDocumentPage extends View {
  final Document item;

  SaveDocumentPage(this.item) : super();

  @override
  SaveDocumentPageView createState() => SaveDocumentPageView(this.item);
}

class SaveDocumentPageView
    extends ViewState<SaveDocumentPage, SaveDocumentController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Document item;

  SaveDocumentPageView(this.item)
      : super(SaveDocumentController(DataDocumentRepository(),
            DataDocumentTransactionRepository(), item));

  Widget get body => Column(children: <Widget>[
        Form(
            key: _formKey,
            child: Padding(
              child: Column(children: <Widget>[
                Row(
                  children: [
                    Expanded(child: name),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(child: date)
                  ],
                ),
                ControlledWidgetBuilder<SaveDocumentController>(
                    builder: (context, controller) {
                  return Visibility(
                      child: supplier,
                      visible: controller.item.type == DocumentType.incoming);
                }),
                ControlledWidgetBuilder<SaveDocumentController>(
                    builder: (context, controller) {
                  return Visibility(
                      child: customer,
                      visible: controller.item.type == DocumentType.outgoing);
                }),
                description,
              ]),
              padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.screenSpace,
                  vertical: UIConstants.screenSpace),
            )),
        goodHeader,
        Expanded(
            child: Stack(
          children: [emptyGoodsView, transactionsView],
        ))
      ]);

  @override
  Widget get view => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return WillPopScope(
            key: globalKey,
            child: Scaffold(
              appBar: appBar,
              body: body,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: controller.onAddGood,
                label: const Text('Thêm sản phẩm'),
                icon: const Icon(Icons.add_photo_alternate),
                backgroundColor: Colors.blue,
              ),
            ),
            onWillPop: controller.onWillPop);
      });

  Widget get appBar => AppBar(
          title: ControlledWidgetBuilder<SaveDocumentController>(
              builder: (context, controller) {
            return Text(controller.getTitleText());
          }),
          actions: <Widget>[
            ControlledWidgetBuilder<SaveDocumentController>(
                builder: (context, controller) {
              return CustomActionsRow(
                  availableWidth: MediaQuery.of(context).size.width /
                      2, // half the screen width
                  actionWidth: 48, // default for IconButtons
                  actions: [
                    CustomAction(
                      visibleWidget: IconButton(
                        onPressed: () => controller.onSaveDocumentTapped({
                          'context': context,
                          'formKey': _formKey,
                          'globalKey': globalKey
                        }),
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
          dateLabelText: AppLocalizations.of(context).field_created,
        );
      });

  Widget get supplier => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return TextFormField(
          readOnly: true,
          onTap: controller.onSupplierTapped,
          controller: controller.supplierTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_supplier),
        );
      });

  Widget get customer => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return TextFormField(
          readOnly: true,
          onTap: controller.onCustomerTapped,
          controller: controller.customerTextController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).field_customer),
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

  Widget get goodHeader =>
      Text(AppLocalizations.of(context).save_document_list_goods_title,
          style: TextStyle(
              color: UIConstants.primaryColor, fontWeight: FontWeight.bold));

  Widget get emptyGoodsView => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return Visibility(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      UIConstants.goodIconPath,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('No transactions', textAlign: TextAlign.center))
              ]),
          visible: controller.transactions.isEmpty,
        );
      });

  Widget get transactionsView {
    return ControlledWidgetBuilder<SaveDocumentController>(
        builder: (context, controller) {
      return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            var transaction = controller.transactions[index];
            return GoodItemRow(
                transaction.good,
                transaction.quantity,
                (item) => controller.onTransactionTapped(index),
                (item) => controller.onTransactionLongPress(index));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: controller.transactions.length);
    });
  }
}
