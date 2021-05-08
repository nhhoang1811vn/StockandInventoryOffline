import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_supplier/save_supplier_controller.dart';
import 'package:good_manager/data/repositories/data_supplier_repository.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

class SaveSupplierPage extends View {
  final bool isInsert;
  final Supplier item;
  SaveSupplierPage({Key key, @required this.isInsert, this.item}) : super(key: key);

  @override
  _SaveSupplierPageView createState() => _SaveSupplierPageView(isInsert, item);
}

class _SaveSupplierPageView extends ViewState<SaveSupplierPage, SaveSupplierController>{
  _SaveSupplierPageView(isInsert, item) : super(SaveSupplierController(DataSupplierRepository(), isInsert,item))



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

  @override
  // TODO: implement view
  Widget get view => throw UnimplementedError();
}
