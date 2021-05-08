import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/app/pages/documents/save_document_presenter.dart';
import 'package:good_manager/app/pages/goods/list.dart';
import 'package:good_manager/app/pages/goods/save_good.dart';
import 'package:good_manager/app/widgets/custom_action_row.dart';
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/domain/entities/Document.dart';
import 'package:good_manager/domain/entities/DocumentTransaction.dart';
import 'package:good_manager/domain/entities/Good.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

import '../pages.dart';


class SaveDocumentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SaveDocumentPageState();
  }
}

class SaveDocumentPageArguments {
  Document document;
  SaveDocumentPageArguments();
}

class SaveDocumentPageState extends State<SaveDocumentPage> {
  bool _validate = true;
  SaveDocumentsPresenter presenter;
  SaveDocumentPageArguments args;
  final teName = TextEditingController();
  final teDescription = TextEditingController();
  final teSupplier = TextEditingController();
  final teDate = TextEditingController();
  String date;

  Document document;
  Supplier supplier;
  List<Good> goods = [];

  bool initData = true;

  @override
  void initState() {
    presenter = SaveDocumentsPresenter();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    args = ModalRoute.of(context).settings.arguments;

    document = args.document;
    teDate.text = document.date.toString();
    teName.text = document.name;
    teDescription.text = document.description;

    if (initData) {
      if (document.supplierId != null) {
        supplier = await presenter.getSupplier(document.supplierId);
        teSupplier.text = supplier.name;
      }
      if (document.id != null) {
        goods = await presenter.getGoodByDocumentId(document.id);
      }
      initData = false;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop(false);
  }

  String getTitle() {
    switch (document.type) {
      case DocumentType.incoming:
        return "Giao Dịch Nhập";
      case DocumentType.outgoing:
        return "Giao Dịch Xuất";
      case DocumentType.stock_taking:
        return "Giao Dịch Kiểm Kê";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text(getTitle()), actions: <Widget>[
            CustomActionsRow(
                availableWidth: MediaQuery.of(context).size.width /
                    2, // half the screen width
                actionWidth: 48, // default for IconButtons
                actions: [
                  CustomAction(
                    visibleWidget: IconButton(
                      onPressed: onSaveDocument,
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
                ])
          ]),
          body: Container(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: teName,
                              decoration: InputDecoration(
                                  labelText: 'Tên',
                                  errorText: _validate
                                      ? null
                                      : 'Tên không thể bỏ trống'),
                            ),
                          ),
                          Expanded(
                            child: DateTimePicker(
                              type: DateTimePickerType.date,
                              controller: teDate,
                              dateMask: 'dd/MM/yyyy',
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              dateLabelText: 'Ngày Tạo',
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        onTap: onSupplierTapped,
                        controller: teSupplier,
                        decoration: InputDecoration(labelText: 'Nhà Cung Cấp'),
                      ),
                      TextFormField(
                        controller: teDescription,
                        decoration: InputDecoration(labelText: 'Mô Tả'),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                ),
                Container(
                    color: Colors.blue[800],
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text('Danh Sách Sản Phẩm',
                            style: TextStyle(color: Colors.white)))),
                Expanded(
                    child: GoodList(goods, (it) => onGoodTapped(it),
                        (it) => onGoodLongPressed(it)))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: onAddGood,
            label: const Text('Thêm sản phẩm'),
            icon: const Icon(Icons.add_photo_alternate),
            backgroundColor: Colors.blue,
          ),
        ),
        onWillPop: _onBackPressed);
  }

  void updateDocument() {
    document.name = teName.text;
    document.date = DateTime.parse(teDate.text);
    document.description = teDescription.text;
    if (supplier != null){
      document.supplierId = supplier.id;
    }

  }

  Future<void> onSaveDocument() async {
    setState(() {
      _validate = teName.text.isNotEmpty;
    });
    if (_validate) {
      updateDocument();
      if (document.id == null) {
        document.id = await presenter.insertDocument(document);
        insertDocumentTransaction(document.id, goods);
      } else {
        await presenter.updateDocument(document);
        //await presenter.deleteDocumentTransaction(document.id);
        //insertDocumentTransaction(document.id, goods);
      }
      Navigator.of(context).pop(true);
    }
  }

  void insertDocumentTransaction(int documentId, List<Good> goods) {
    goods.forEach((good) {
      DocumentTransaction transaction = DocumentTransaction();
      transaction.goodId = good.id;
      transaction.documentId = document.id;
      transaction.quantity = good.quantity;
      presenter.insertDocumentTransaction(transaction);
    });
  }

  void onAddGood() async {
    SaveGoodPageArguments arguments = SaveGoodPageArguments();
    Good good = Good();
    good.storeId = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    good.quantity = 1;

    arguments.isSelection = true;
    arguments.good = good;
    var result = await Navigator.of(context)
        .pushNamed(Pages.save_good, arguments: arguments);
    if (result != null) {
      var resultGood = Good.map(result);
      goods.add(resultGood);
      setState(() {});
    }
  }

  void onSupplierTapped() async {
    /*final data = await Navigator.of(context)
        .pushNamed(Pages.supplier_list, arguments: SuppliersPageArgument(true));
    if (data != null) {
      supplier = Supplier.map(data);
      teSupplier.text = supplier.supplierName;
    }*/
  }

  void onGoodTapped(Good good) async {

  }

  void onGoodLongPressed(Good good) async {}
}
