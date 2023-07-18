import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/pages/save_supplier/components/save_supplier_form.dart';

import 'bloc/save_supplier_cubit.dart';

class SaveSupplierPage extends StatelessWidget {
  final Supplier item;
  SaveSupplierPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SaveSupplierCubit>().init(item);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        SelectedStoreView(),
        Expanded(child: SaveSupplierForm(item: item))
      ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
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
