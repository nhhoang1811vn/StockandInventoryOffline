import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_customer/components/save_customer_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import 'bloc/save_customer_cubit.dart';

class SaveCustomerPage extends StatelessWidget {
  final Customer item;
  SaveCustomerPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SaveCustomerCubit>().init(item);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        SelectedStoreView(),
        Expanded(child: SaveCustomerForm(item: item))
      ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_customer_title),
        actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SaveCustomerCubit>().onSaveClicked();
          }, icon: Icon(Icons.check))
        ]));
  }
}
