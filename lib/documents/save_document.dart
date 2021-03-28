import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/documents/documents_presenter.dart';
import 'package:good_manager/goods/list.dart';
import 'package:good_manager/goods/save_good.dart';
import 'package:good_manager/model/Document.dart';
import 'package:good_manager/model/Good.dart';
import 'package:good_manager/suppliers/suppliers_page.dart';
import 'package:good_manager/utils/AppUtils.dart';
import 'package:intl/intl.dart';

class SaveDocumentPageWidget extends StatefulWidget {
  static const routeName = '/saveDocument';

  @override
  State<StatefulWidget> createState() {
    return SaveDocumentPageWidgetState();
  }
}

class SaveDocumentPageArguments {
  Document document;
  SaveDocumentPageArguments();
}

class SaveDocumentPageWidgetState extends State<SaveDocumentPageWidget> {
  bool _validate = true;
  DocumentsPresenter presenter;
  SaveDocumentPageArguments args;
  final teName = TextEditingController();
  final teDescription = TextEditingController();
  final teSupplier = TextEditingController();
  final teDate = TextEditingController();
  int supplierId = -1;
  String supplierName = "";
  String date;

  Document document;
  int documentId;

  @override
  void initState() {
    presenter = DocumentsPresenter();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments;

    document = args.document;
    documentId = document.id;
    teDate.text = document.date.toString();
    teName.text = document.name;
    teDescription.text = document.description;
    super.didChangeDependencies();
  }

  Future<bool> _onBackPressed() async {
    saveDocument();
    if (_validate){
      Navigator.of(context).pop(true);
    }else{
      Navigator.of(context).pop(false);
    }
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
          appBar: AppBar(
            title: Text(getTitle()),
          ),
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
                              decoration: InputDecoration(labelText: 'Tên'),
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
                    child: new FutureBuilder<List<Good>>(
                        future: presenter.getGoodByDocumentId(documentId),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? new GoodList(
                                  snapshot.data,
                                  (it) => onGoodTapped(it),
                                  (it) => onGoodLongPressed(it))
                              : new Center(
                                  child: new CircularProgressIndicator());
                        }))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: onSelectGood,
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

    ///TODO NCC mapping
  }
  Future<void> saveDocument() async{
    setState(() {
      if (teName.text.isEmpty){
        _validate = false;
      }else{
        _validate = true;
      }
    });
    if (_validate) {
      updateDocument();
      if (documentId == null) {
        documentId = await presenter.insert(document);
      } else {
        await presenter.update(document);
      }
    }
  }
  void onSelectGood() async {
    await saveDocument();
    if (_validate){
      SaveGoodPageArguments arguments = SaveGoodPageArguments();
      arguments.isSelection = true;
      arguments.documentId = documentId;
      Good good = Good();
      good.storeId = await AppUtils.getSelectedStoreId();
      arguments.good = good;
      var result = await Navigator.of(context)
          .pushNamed(SaveGoodPageWidget.routeName, arguments: arguments);
      if (result){
        setState(() {

        });
      }
    }


  }

  void onSupplierTapped() async {
    final supplier = await Navigator.of(context).pushNamed(
        SuppliersPageWidget.routeName,
        arguments: SuppliersPageArgument(true));
    Map data = (supplier as Map<String, dynamic>);
    print(data);
    if (supplier != null) {
      teSupplier.text = data["name"];
      supplierId = data["id"];
    }
  }

  void onGoodTapped(Good good) async {}

  void onGoodLongPressed(Good good) async {}
}
