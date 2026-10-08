import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/save_group/bloc/save_group_cubit.dart';
import 'package:good_manager/presentation/pages/save_group/components/save_group_form.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';

class SaveGroupPage extends StatefulWidget {
  final Group item;

  SaveGroupPage({required this.item}) : super();

  @override
  State<StatefulWidget> createState() {
    return SaveGroupPageState();
  }
}

class SaveGroupPageState extends State<SaveGroupPage> {
  @override
  Widget build(BuildContext context) {
    context.read<SaveGroupCubit>().init(widget.item);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SaveObjectAppBar(title: context.tr("save_group")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                children: [
                  SaveGroupForm(item: widget.item),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: PrimaryButton(context.tr("action_save"), () {
              context.read<SaveGroupCubit>().onSaveClicked();
            }),
          ),
        ],
      ),
    );
  }
}
