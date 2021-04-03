import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_manager/assets/constants.dart' as Constants;


enum SortBy{ no_sort, sort_a_z, sort_z_a}

class SortByStoreDialogWidget extends StatefulWidget{
  final void Function() onValueChange;
  SortByStoreDialogWidget(this.onValueChange,{Key key}) : super(key: key);
  @override
  State createState() => SortByStoreDialogWidgetState();
}
class SortByStoreDialogWidgetState extends State<SortByStoreDialogWidget>{
  SortBy _sortByName;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSortByName();
    });
    super.initState();
  }
  void initSortByName() async{
    final prefs = await SharedPreferences.getInstance();
    SortBy value = EnumToString.fromString(SortBy.values, prefs.getString(Constants.keySortByStore));
    if (value == null){
      _sortByName = SortBy.no_sort;
    }else{
      _sortByName = value;
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sắp xếp'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                Text('Theo Tên'),
                Divider(
                    color: Colors.grey
                ),
                getRadioListTile("Không sắp xếp", SortBy.no_sort),
                getRadioListTile("Sắp xếp A-Z", SortBy.sort_a_z),
                getRadioListTile("Sắp xếp Z-A", SortBy.sort_z_a)
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(Constants.keySortByStore, EnumToString.convertToString(_sortByName));
            widget.onValueChange();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  RadioListTile<SortBy> getRadioListTile(String text, SortBy value){
    return RadioListTile<SortBy>(
      title: Text(text),
      value: value,
      groupValue: _sortByName,
      onChanged: (SortBy value){
        setState((){
          _sortByName = value;
        });
      },
    );
  }
  
}