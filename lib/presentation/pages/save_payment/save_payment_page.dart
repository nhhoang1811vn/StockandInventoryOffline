import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/save_payment/components/save_payment_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import 'bloc/save_payment_cubit.dart';



class SavePaymentPage extends StatelessWidget {
  final Payment item;
  SavePaymentPage(this.item);
  @override
  Widget build(BuildContext context) {
    context.read<SavePaymentCubit>().init(item);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(child: SavePaymentForm(item: item))
        ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_payment_title),
        actions: <Widget>[
          IconButton(onPressed: (){
            context.read<SavePaymentCubit>().onSaveClicked();
          }, icon: Icon(Icons.check))
        ]));
  }
}

