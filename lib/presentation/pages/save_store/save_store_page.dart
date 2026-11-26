import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/save_store/bloc/save_store_cubit.dart';
import 'package:good_manager/presentation/pages/save_store/components/save_store_form.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';

class SaveStorePage extends StatefulWidget {
  final Store item;

  SaveStorePage({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SaveStorePageState();
  }
}

class SaveStorePageState extends State<SaveStorePage> {
  @override
  Widget build(BuildContext context) {
    context.read<SaveStoreCubit>().init(widget.item);
    return UnsavedChangesGuard(
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SaveObjectAppBar(title: context.tr("save_store")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                children: [SaveStoreForm(item: widget.item)],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: PrimaryButton(context.tr("action_save"), () {
              context.read<SaveStoreCubit>().onSaveClicked();
            }),
          ),
        ],
      ), //SaveStoreForm(item: widget.item)
    ));
  }
}
