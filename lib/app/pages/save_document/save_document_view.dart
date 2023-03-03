import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/goods/good_item_row.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/data/repositories/data_app_repository.dart';
import 'package:good_manager/data/repositories/data_document_repository.dart';
import 'package:good_manager/data/repositories/data_document_transaction_repository.dart';
import 'package:good_manager/data/repositories/data_good_repository.dart';
import 'package:good_manager/domain/entities/document.dart';

import 'save_document_controller.dart';

enum OverflowItemMenu { batchscan, sortby, help }

class SaveDocumentPage extends View {
  final Document item;

  SaveDocumentPage(this.item) : super();

  @override
  SaveDocumentPageView createState() => SaveDocumentPageView(item);
}

class SaveDocumentPageView
    extends ViewState<SaveDocumentPage, SaveDocumentController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Document item;

  SaveDocumentPageView(this.item)
      : super(SaveDocumentController(
            DataAppRepository(),
            DataDocumentRepository(),
            DataDocumentTransactionRepository(),
            DataGoodRepository(),
            item));

  Widget get body => Column(children: <Widget>[
        SelectedStoreView(),
        ExpansionTile(
          title: Text("Document Information"),
          initiallyExpanded: true,
          children: [
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
                          visible:
                              controller.item.type == DocumentType.incoming);
                    }),
                    ControlledWidgetBuilder<SaveDocumentController>(
                        builder: (context, controller) {
                      return Visibility(
                          child: customer,
                          visible:
                              controller.item.type == DocumentType.outgoing);
                    }),
                    description,
                  ]),
                  padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.screenSpace),
                )),
          ],
        ),
        ControlledWidgetBuilder<SaveDocumentController>(
            builder: (context, controller) {
          return Visibility(
              child: searchBar, visible: controller.showSearchBar);
        }),
        Expanded(child: transactionsView)
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
                label:
                    Text(AppLocalizations.of(context).save_document_add_goods),
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
              return IconButton(
                  onPressed: () => controller.toggleSearchBar(),
                  icon: Icon(
                    UIConstants.searchMenuIconData,
                    color: controller.showSearchBar
                        ? UIConstants.highlightMenuColor
                        : UIConstants.normalMenuColor,
                  ));
            }),
            ControlledWidgetBuilder<SaveDocumentController>(
                builder: (context, controller) {
              return IconButton(
                  onPressed: () => controller.onSaveDocumentTapped({
                        'context': context,
                        'formKey': _formKey,
                        'globalKey': globalKey
                      }),
                  icon: Icon(Icons.check));
            }),
            ControlledWidgetBuilder<SaveDocumentController>(
                builder: (context, controller) {
              return PopupMenuButton<OverflowItemMenu>(
                onSelected: (OverflowItemMenu result) {
                  switch (result) {
                    case OverflowItemMenu.batchscan:
                      controller.onBatchScanPressed();
                      break;
                    case OverflowItemMenu.sortby:
                      break;
                    case OverflowItemMenu.help:
                      controller.openHelpPage();
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext a) =>
                    <PopupMenuEntry<OverflowItemMenu>>[
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.batchscan,
                      child: Text(AppLocalizations.of(context)
                          .save_document_batch_scan)),
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.sortby,
                      child: Text(
                          AppLocalizations.of(context).save_document_sort_by)),
                  PopupMenuItem<OverflowItemMenu>(
                      value: OverflowItemMenu.help,
                      child: Text(
                          AppLocalizations.of(context).save_document_help)),
                ],
              );
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
          dateLabelText: AppLocalizations.of(context).field_date,
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

  Widget get searchBar => ControlledWidgetBuilder<SaveDocumentController>(
          builder: (context, controller) {
        return Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "Search...", border: InputBorder.none),
              onChanged: controller.onSearchChanged,
              controller: controller.searchTextController,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  child: IconButton(
                    icon: Icon(UIConstants.cancelIconData),
                    onPressed: controller.resetSearchText,
                  ),
                  visible: controller.textSearch.isNotEmpty,
                ),
                IconButton(
                  icon: Image.asset(
                    UIConstants.searchBarcodeIconPath,
                    width: 24,
                  ),
                  onPressed: controller.onSearchBarCode,
                )
              ],
            ),
          ),
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
