import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/app_data_manager.dart';

class StoreView extends StatefulWidget {
  @override
  StoreViewState createState() {
    return StoreViewState();
  }
}

class StoreViewState extends State<StoreView> {
  String _name = "";

  Future<Null> getSharedPrefs() async {
    int id = await appDataManager.sharedPrefsHelper.getSelectedStoreId();
    if (id == -1) {
      _name = AppLocalizations.of(context).all_stores;
    } else {
      _name = await appDataManager.sharedPrefsHelper.getSelectedStoreName();
    }
    setState(() {});
  }

  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        color: UIConstants.primaryDarkColor,
        width: double.infinity,
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: Text(_name, style: TextStyle(color: Colors.white))));
  }
}
