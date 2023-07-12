import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/save_supplier/components/save_supplier_form.dart';
import 'package:good_manager/domain/entities/supplier.dart';

import 'bloc/save_supplier_cubit.dart';

class SaveSupplierPage extends StatelessWidget {
  final Supplier item;
  SaveSupplierPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.blueGrey[100],
      body: SaveSupplierForm(item: item)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(58), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_supplier_title),
        actions: <Widget>[
          InkWell(
            onTap: () => context.read<SaveSupplierCubit>().onSaveClicked(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ]));
  }
}
