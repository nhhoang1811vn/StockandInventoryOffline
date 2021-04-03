import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:good_manager/app/pages/goods/save_good_presenter.dart';
import 'package:good_manager/app/widgets/ReceiveGoodDialogWidget.dart';
import 'package:good_manager/domain/entities/Document.dart';
import 'package:good_manager/domain/entities/Good.dart';



class SaveGoodPage extends StatefulWidget {
  SaveGoodPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SaveGoodPageState();
  }
}
class SaveGoodPageArguments{
  bool isSelection = false;
  Good good;
  SaveGoodPageArguments();
}

class _SaveGoodPageState extends State<SaveGoodPage> implements SaveGoodContract {
  SaveGoodPageArguments args;
  SaveGoodPresenter presenter;
  Good good;
  int goodId;
  bool _validateName = true;
  bool _validateQuantity = true;
  final teName = TextEditingController();
  final teDescription = TextEditingController();
  final teBarCode = TextEditingController();
  final teQuantity = TextEditingController();

  @override
  void initState() {
    presenter = SaveGoodPresenter(this);
    super.initState();
  }

  bool getValidateName(String text) {
    return text.isNotEmpty;
  }

  bool getValidateQuantity(String text) {
    return (text.isNotEmpty && int.parse(text) > 0);
  }

  void _onSaveGood() async {
    setState(() {
      _validateName = getValidateName(teName.text);
      _validateQuantity = getValidateQuantity(teQuantity.text);
    });

    if (_validateName && _validateQuantity) {
      good.name = teName.text;
      good.description = teDescription.text;
      good.barCode = teBarCode.text;
      good.quantity = int.parse(teQuantity.text);
      if (good.id == null) {
        good.id = await presenter.insertGood(good);
      } else {
        await presenter.updateGood(good);
      }
      Map<String, dynamic> map = good.toMap();
      map["quantity"] = good.quantity;
      Navigator.pop(context, map);
    }
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
  void _onAddQuantity() async{
    await showDialog(context: context, builder: (_) => ReceiveGoodDialog(onRetrieveADocument), barrierDismissible: false);
  }
  void _onRemoveQuantity(){

  }
  void onRetrieveADocument(Document document){

  }
  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments;
    good = args.good;

    teName.text = good.name;
    teDescription.text = good.description;
    teBarCode.text = good.barCode;
    teQuantity.text = good.quantity.toString();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thêm sản phẩm'),
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
              Row(children: [
                Expanded(child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          _validateName = getValidateName(text);
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Tên',
                          errorText:
                              _validateName ? null : 'Tên không thể bỏ trống'),
                      controller: teName,
                    ),),
                Visibility(child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: Icon(Icons.search, size: 32, color: Colors.grey,), onPressed: _onAddBarCode)
                ),
                visible: args.isSelection,)
              ],),

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
                      child: IconButton(icon: Icon(Icons.qr_code_scanner_sharp, size: 36,color: Colors.grey,), onPressed: _onAddBarCode)
                  )
                ],
              ),

              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    onChanged: (text) {
                      setState(() {
                        _validateQuantity = getValidateQuantity(text);
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Số lương',
                        errorText:
                            _validateQuantity ? null : 'Số lượng không hợp lệ'),
                    controller: teQuantity,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  )),
                  Visibility(visible: !args.isSelection,child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          IconButton(icon: Icon(Icons.add_circle, size: 36,color: Colors.blue,), onPressed: _onAddQuantity),
                          IconButton(icon: Icon(Icons.remove_circle, size: 36,color: Colors.blue,), onPressed: _onRemoveQuantity),
                        ],
                      )),),
                  Visibility(visible: args.isSelection,child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: Icon(Icons.calculate), onPressed:() => _showCalculatorDialog(context),),
                  ))

                ],
              )
            ],
          ),
        ));
  }
  void _showCalculatorDialog(BuildContext context) async {
    final result = await showCalculator(context: this.context) ?? 0;
    teQuantity.text = result.toInt().toString();
  }
}
