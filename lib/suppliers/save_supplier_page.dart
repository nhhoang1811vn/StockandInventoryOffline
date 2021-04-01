import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/model/Supplier.dart';
import 'package:good_manager/suppliers/save_supplier_presenter.dart';

class SaveSupplierPageWidget extends StatefulWidget {
  SaveSupplierPageWidget({Key key}) : super(key: key);

  static const routeName = '/saveSupplier';

  @override
  State<StatefulWidget> createState() {
    return _SaveSupplierPageWidgetState();
  }
}

class SaveSupplierPageArguments {
  final bool isAdd;
  final Supplier item;

  SaveSupplierPageArguments(this.isAdd, this.item);
}

class _SaveSupplierPageWidgetState extends State<SaveSupplierPageWidget>
    implements SaveSupplierContract {
  SaveSupplierPresenter presenter;
  Supplier item;

  SaveSupplierPageArguments args;
  final teName = TextEditingController();
  final teDescription = TextEditingController();
  final teAddress = TextEditingController();
  final teEmail = TextEditingController();
  final tePhone = TextEditingController();
  final teTaxID = TextEditingController();
  final teBankDetails= TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = SaveSupplierPresenter(this);
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments;

    item = args.item;
    teName.text = item.supplierName;
    teDescription.text = item.description;
    teAddress.text = item.address;
    teEmail.text = item.email;
    tePhone.text = item.phone;
    teTaxID.text = item.taxID;
    teBankDetails.text = item.bankDetail;
    super.didChangeDependencies();
  }

  void _onSaveStore() {
    setState(() {
      if (teName.text.isEmpty) {
        _validate = false;
      } else {
        _validate = true;
      }
    });

    if (_validate) {
      //Store store = new Store(teName.text, teDescription.text);
      item.supplierName = teName.text;
      item.description = teDescription.text;
      item.address = teAddress.text;
      item.email = teEmail.text;
      item.phone = tePhone.text;
      item.taxID = teTaxID.text;
      item.bankDetail = teBankDetails.text;
      if (args.isAdd) {
        presenter.insert(item);
      } else {
        presenter.update(item);
      }
      Navigator.of(context).pop(true);
    } else {}
  }

  final _textKey = GlobalKey<FormState>();
  bool _validate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).save_supplier_title),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                    onTap: _onSaveStore, child: Icon(Icons.check, size: 26)),
              )
            ]),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                key: _textKey,
                controller: teName,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).field_name,
                    errorText: _validate ? null : 'Name can not be blank'),
                onChanged: (text) {
                  setState(() {
                    if (text.isEmpty) {
                      _validate = false;
                    } else {
                      _validate = true;
                    }
                  });
                },
              ),
              getTextFormField(teDescription, AppLocalizations.of(context).field_desc),
              getTextFormField(teAddress, AppLocalizations.of(context).field_address),
              getTextFormField(teEmail, AppLocalizations.of(context).field_email),
              getTextFormField(tePhone, AppLocalizations.of(context).field_phone),
              getTextFormField(teTaxID, AppLocalizations.of(context).field_tax_ID),
              getTextFormField(teBankDetails, AppLocalizations.of(context).field_bank_details),
            ],
          ),
        ));
  }
  TextFormField getTextFormField(TextEditingController controller, String labelText){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText),
    );
  }
}
