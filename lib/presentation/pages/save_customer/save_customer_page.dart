import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/save_customer/components/save_customer_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../widgets/primary_button.dart';
import 'bloc/save_customer_cubit.dart';
class SaveCustomerPage extends StatefulWidget{
  final Customer item;
  SaveCustomerPage({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SaveCustomerPageState();
  }
}
class SaveCustomerPageState extends BaseStateWidget<SaveCustomerPage> {
  @override
  Widget buildWidget(BuildContext context) {
    context.read<SaveCustomerCubit>().init(widget.item);
    return Scaffold(
        backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(context),
      body: Column(children: [
        SelectedStoreView(),
        Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.surface,
                    child: SaveCustomerForm(item: widget.item),
                  )
                ],
              ),
            )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surface,
          child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
            context.read<SaveCustomerCubit>().onSaveClicked();
          }),
        )
      ],)
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_customer_title),
        ));
  }
}
