import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/stores/save_store_presenter.dart';
import 'package:good_manager/domain/entities/Store.dart';


class SaveStorePageWidget extends StatefulWidget {
  SaveStorePageWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SaveStorePageWidgetState();
  }


}
class SaveStorePageArguments{
  final bool isAdd;
  final Store store;
  SaveStorePageArguments(this.isAdd, this.store);
}

class _SaveStorePageWidgetState extends State<SaveStorePageWidget> implements SaveStoreContract {
  SaveStorePresenter presenter;
  Store store;

  SaveStorePageArguments args;
  final teName = TextEditingController();
  final teDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = SaveStorePresenter(this);
  }
  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments;

    store = args.store;
    teName.text = store.name;
    teDescription.text = store.description;
    super.didChangeDependencies();
  }
  void _onSaveStore(){
    setState(() {
      if (teName.text.isEmpty){
        _validate = false;
      }else{
        _validate = true;
      }
    });

    if (_validate){
      //Store store = new Store(teName.text, teDescription.text);
      store.name = teName.text;
      store.description = teDescription.text;
      if (args.isAdd){
        presenter.insert(store);
      }else{
        presenter.update(store);
      }
      Navigator.of(context).pop(true);
    }else{

    }
  }
  final _textKey = GlobalKey<FormState>();
  bool _validate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).save_store_title),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: _onSaveStore,
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
                key: _textKey,
                controller: teName,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).field_name, errorText: _validate ? null : 'Name can not be blank'),
                onChanged: (text){
                  setState(() {
                    if (text.isEmpty){
                      _validate = false;
                    }else{
                      _validate = true;
                    }
                  });
                },
              ),
              TextFormField(
                controller: teDescription,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).field_desc),
              ),
            ],
          ),
        ));
  }
}
