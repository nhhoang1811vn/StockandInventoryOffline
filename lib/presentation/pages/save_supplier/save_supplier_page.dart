import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/save_supplier/components/save_supplier_form.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';
import 'bloc/save_supplier_cubit.dart';

class SaveSupplierPage extends StatefulWidget {
  final Supplier item;

  SaveSupplierPage({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaveSupplierPageState();
  }
}

class SaveSupplierPageState extends State<SaveSupplierPage> {
  @override
  Widget build(BuildContext context) {
    context.read<SaveSupplierCubit>().init(widget.item);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SaveObjectAppBar(title: context.tr("save_supplier")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(UIConstants.screenSpace),
                child: Column(
                  children: [SaveSupplierForm(item: widget.item)],
                ),
              ),
            ),
            Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: PrimaryButton(context.tr("action_save"), () {
              context.read<SaveSupplierCubit>().onSaveClicked();
            }),
          ),
        ],
        ),
      ),
    );
  }
}
