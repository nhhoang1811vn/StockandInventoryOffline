import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SaveGoodPageWidget extends StatefulWidget {
  SaveGoodPageWidget({Key key}) : super(key: key);

  static const routeName  = '/saveGood';

  @override
  State<StatefulWidget> createState() {
    return _SaveGoodPageWidgetState();
  }
}

class _SaveGoodPageWidgetState extends State<SaveGoodPageWidget> {
  void _onSaveGood(){
    //Fluttertoast.showToast(msg: "save good");
  }
  Future<void> _onAddBarCode() async {
    /*String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }*/

  }
  void _onAddQuantity(){
    //Fluttertoast.showToast(msg: "add quality");
  }
  void _onRemoveQuantity(){
    //Fluttertoast.showToast(msg: "remove quality");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Good 1'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: _onSaveGood,
                  child: Icon(Icons.check, size: 26)
                ) ,

            )
          ]
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Barcode'),
                  )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(icon: Icon(Icons.qr_code_scanner_sharp, size: 40), onPressed: _onAddBarCode)
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Quanlity'),
                  )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.add_circle, size: 40), onPressed: _onAddQuantity),
                          IconButton(icon: Icon(Icons.remove_circle, size: 40), onPressed: _onRemoveQuantity),
                        ],
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
