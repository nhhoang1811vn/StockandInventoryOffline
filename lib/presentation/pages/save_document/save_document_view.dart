import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/app/widgets/selected_store_view.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/presentation/pages/save_document/bloc/save_document_cubit.dart';

import 'components/save_document_form.dart';
enum OverflowItemMenu { batchscan, sortby, help }

class SaveDocumentPage extends StatelessWidget {
  final Document item;

  SaveDocumentPage(this.item) : super();
  @override
  Widget build(BuildContext context) {
    context.read<SaveDocumentCubit>().init(item);
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(children: [
          SelectedStoreView(),
          Expanded(child: SaveDocumentForm(item: item))
        ],),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<SaveDocumentCubit>().onAddGoodClicked(),
        label: Text(AppLocalizations.of(context)!.save_document_add_goods),
        backgroundColor: Colors.blue,
      ),
    );
  }
  PreferredSize _buildAppBar(BuildContext context){
    return PreferredSize(preferredSize : Size.fromHeight(UIConstants.appBarHeight), child: AppBar(
        title: Text(item.type == DocumentType.incoming? AppLocalizations.of(context)!.save_document_incoming_title :AppLocalizations.of(context)!.save_document_outgoing_title),
        actions: <Widget>[
          _buildSearchMenu(context),
          _buildBarcodeScannerMenu(context),
          _buildSaveMenu(context),

        ]));
  }
  Widget _buildSearchMenu(BuildContext context){
    return InkWell(
      onTap: () => context.read<SaveDocumentCubit>().onSearchMenuClicked(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(UIConstants.searchMenuIconData),
      ),
    );
  }
  Widget _buildBarcodeScannerMenu(BuildContext context){
    return InkWell(
      onTap: () => context.read<SaveDocumentCubit>().onSearchMenuClicked(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(UIConstants.barcodeScannerMenuIconData),
      ),
    );
  }
  Widget _buildSaveMenu(BuildContext context){
    return InkWell(
      onTap: () => context.read<SaveDocumentCubit>().onSaveMenuClicked(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.check),
      ),
    );
  }
}
