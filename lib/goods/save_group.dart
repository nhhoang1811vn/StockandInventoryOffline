import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:good_manager/goods/save_group_presenter.dart';
import 'package:good_manager/model/Group.dart';

class SaveGroupPageWidget extends StatefulWidget {
  SaveGroupPageWidget({Key key}) : super(key: key);

  static const routeName  = '/saveGroup';

  @override
  State<StatefulWidget> createState() {
    return _SaveGroupPageWidgetState();
  }
}
class SaveGroupPageArguments{
  final bool isAdd;
  final Group group;
  SaveGroupPageArguments(this.isAdd, this.group);
}

class _SaveGroupPageWidgetState extends State<SaveGroupPageWidget> implements SaveGroupContract {
  SaveGroupPresenter presenter;
  SaveGroupPageArguments args;
  Group item;
  bool _validate = true;
  void _onSaveGroup(){
    setState(() {
      if (teName.text.isEmpty){
        _validate = false;
      }else{
        _validate = true;
      }
    });

    if (_validate){
      item.name = teName.text;
      item.description = teDescription.text;
      if (args.isAdd){
        presenter.insert(item);
      }else{
        presenter.update(item);
      }
      Navigator.of(context).pop(true);
    }
  }
  @override
  void initState() {
    super.initState();
    presenter = SaveGroupPresenter(this);
  }
  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments;

    item = args.group;
    teName.text = item.name;
    teDescription.text = item.description;
    teBarCode.text = item.barCode;
    super.didChangeDependencies();
  }
  Future<void> _onAddBarCode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      teBarCode.text = barcodeScanRes;

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
  final teName = TextEditingController();
  final teDescription  = TextEditingController();
  final teBarCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thêm nhóm'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: _onSaveGroup,
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
                decoration: InputDecoration(labelText: 'Tên', errorText: _validate ? null : 'Tên không thể bỏ trống'),
                controller: teName,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mô tả'),
                controller: teDescription,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(labelText: 'Mã vạch'),
                        controller: teBarCode,

                  )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(icon: Icon(Icons.qr_code_rounded, size: 28), onPressed: _onAddBarCode)
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
