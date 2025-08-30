import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/save_customer/components/save_customer_form.dart';
import 'package:good_manager/presentation/widget/widget.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import 'bloc/save_customer_cubit.dart';

class SaveCustomerPage extends StatefulWidget {
  final Customer item;

  SaveCustomerPage({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaveCustomerPageState();
  }
}

class SaveCustomerPageState extends State<SaveCustomerPage> {
  @override
  Widget build(BuildContext context) {
    context.read<SaveCustomerCubit>().init(widget.item);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          SelectedStoreView(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                children: [SaveCustomerForm(item: widget.item)],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: PrimaryButton(AppLocalizations.of(context)!.action_save, () {
              context.read<SaveCustomerCubit>().onSaveClicked();
            }),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: Text(AppLocalizations.of(context)!.save_customer_title),
      ),
    );
  }
}
