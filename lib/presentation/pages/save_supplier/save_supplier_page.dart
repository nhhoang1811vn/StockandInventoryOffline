import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/save_supplier/components/save_supplier_form.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';

import '../../widgets/primary_button.dart';
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
        backgroundColor: Colors.grey[200],
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            SelectedStoreView(),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.surface,
                    child: SaveSupplierForm(item: widget.item),
                  )
                ],
              ),
            )),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surface,
              child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
                context.read<SaveSupplierCubit>().onSaveClicked();
              }),
            )
          ],
        ));
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(UIConstants.appBarHeight),
        child: AppBar(title: Text(AppLocalizations.of(context)!.save_supplier_title)));
  }
}
