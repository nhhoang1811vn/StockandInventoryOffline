import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/save_supplier/components/save_supplier_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import 'bloc/save_supplier_cubit.dart';
class SaveSupplierPage extends StatefulWidget {
  final Supplier item;
  SaveSupplierPage({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SaveSupplierPageState();
  }
}
class SaveSupplierPageState extends BaseStateWidget<SaveSupplierPage> {
  @override
  Widget buildWidget(BuildContext context) {
    context.read<SaveSupplierCubit>().init(widget.item);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        SelectedStoreView(),
        Expanded(child: SaveSupplierForm(item: widget.item))
      ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_supplier_title),
        actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SaveSupplierCubit>().onSaveClicked();
          }, icon: Icon(Icons.check))
        ]));
  }
}
