import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';
import 'bloc/save_good_cubit.dart';
import 'components/save_good_form.dart';

class SaveGoodPage extends StatefulWidget {
  final Good item;
  final Document? document;
  final DocumentTransaction? transaction;

  SaveGoodPage({
    required this.item,
    this.document,
    this.transaction,
  });

  @override
  State<StatefulWidget> createState() {
    return SaveGoodPageState(
      item: item,
      document: document,
      transaction: transaction,
    );
  }
}

class SaveGoodPageState extends State<SaveGoodPage> {
  final Good item;
  final Document? document;
  final DocumentTransaction? transaction;

  SaveGoodPageState({
    required this.item,
    this.document,
    this.transaction,
  });

  @override
  void initState() {
    super.initState();
    context.read<SaveGoodCubit>().initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<SaveGoodCubit>().init(item, document, transaction);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          SelectedStoreView(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(UIConstants.screenSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SaveGoodForm(),
                  SizedBox(
                    height: 16,
                  ),
                  // Card(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: BlocBuilder<SaveGoodCubit, SaveGoodState>(
                  //       builder: (context, state) => ImagesPreviewView(
                  //         state.files,
                  //         true,
                  //         context.read<SaveGoodCubit>().onImagesChanged,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          //Expanded(child: ),
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.all(16),
            child: PrimaryButton(context.tr("action_save"), () {
              context.read<SaveGoodCubit>().onSaveClicked();
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
        title: Text(context.tr("save_good")),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.read<SaveGoodCubit>().onHistoryClicked();
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
    );
  }

}
