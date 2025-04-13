import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/documents/components/document_date_row.dart';
import 'package:good_manager/presentation/pages/documents/document_ui.dart';
import 'package:good_manager/presentation/pages/documents/sort_documents_dialog.dart';
import 'package:good_manager/presentation/pages/select_document/bloc/select_document_cubit.dart';
import 'package:sprintf/sprintf.dart';

import '../../app_style.dart';
import '../../widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../documents/components/document_item_row.dart';
import '../help_content.dart';
import '../pages.dart';

class SelectDocumentsPage extends StatefulWidget {
  final DocumentType documentType;

  const SelectDocumentsPage({required this.documentType}) : super();

  @override
  State<StatefulWidget> createState() {
    return SelectDocumentsPageState();
  }
}

class SelectDocumentsPageState extends State<SelectDocumentsPage> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    context.read<SelectDocumentCubit>().initState(widget.documentType);
    super.initState();
  }

  Widget _buildDocumentView(SelectDocumentState state) => Stack(children: [
        Visibility(
          child: Center(child: _buildEmptyView()),
          visible: state.items.isEmpty,
        ),
        Visibility(
          child: _buildListView(state.items),
          visible: state.items.isNotEmpty,
        )
      ]);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectDocumentCubit, SelectDocumentState>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.grey.shade200,
              appBar: _buildAppBar(state),
              body: _buildDocumentView(state),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _onAddDocumentWithType(widget.documentType);
                },
                child: Icon(Icons.add),
              ),
            ),
        listenWhen: (state1, state2) => state1.state != state2.state,
        listener: (context, state) async {
          if (state.state is OpenHelpPageState) {
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)!.documents_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.DOCUMENTS)
            });
          } else if (state.state is OpenSortDialogListState) {
            DocumentsSetting? settings = await showDialog(
                context: context, builder: (_) => SortDocumentsDialog(state.settings), barrierDismissible: true);
            if (settings != null) {
              context.read<SelectDocumentCubit>().setSettings(settings);
            }
          }
        });
  }

  void _onAddDocumentWithType(DocumentType type) async {
    int storeId = storage.getSelectedStoreId();
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = AppLocalizations.of(context)!.document_name_no + storage.getAutoDocumentNo(storeId).toString();
    await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
    context.read<SelectDocumentCubit>().loadItems();
  }

  PreferredSize _buildAppBar(SelectDocumentState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(58.0 + 20 + (state.showSearchBar ? 65 : 0)),
      child: AppBar(
        actions: [_buildSearchMenu(state), _buildSortMenu(), _buildHelpMenu()],
        title: Text(AppLocalizations.of(context)!.title_select_document),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58 + 20 + (state.showSearchBar ? 65 : 0)),
          child: Column(
            children: [
              SelectedStoreView(),
              Visibility(child: _buildSearchBar(context, state), visible: state.showSearchBar),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(UIConstants.documentIconData, size: 64, color: Colors.orange.shade700),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.empty_document,
              textAlign: TextAlign.center, style: AppStyle.getEmptyTextStyle())
        ],
      );

  Widget _buildListView(List<DocumentUI> items) => ListView.builder(
      itemBuilder: (BuildContext context, index) {
        DocumentUI item = items[index];
        if (item.type == DocumentUIType.data) {
          return DocumentItemRow(
              false, item.document!, (item) => onPressedDocument(item), (item) => onLongPressedDocument(item));
        } else {
          return DocumentDateRow(item.dateText);
        }
      },
      itemCount: items.length);

  Widget _buildSearchMenu(SelectDocumentState state) {
    return IconButton(
        onPressed: () {
          searchTextController.text = "";
          context.read<SelectDocumentCubit>().onSearchMenuClicked();
        },
        icon: Icon(Icons.search,
            color: state.showSearchBar ? UIConstants.highlightMenuColor : UIConstants.normalMenuColor));
  }

  Widget _buildSortMenu() {
    return IconButton(
        onPressed: () {
          context.read<SelectDocumentCubit>().onMenuSortClicked();
        },
        icon: Icon(Icons.sort,
            color: context.read<SelectDocumentCubit>().hasSortOptions()
                ? UIConstants.highlightMenuColor
                : UIConstants.normalMenuColor));
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          context.read<SelectDocumentCubit>().onMenuHelpClicked();
        },
        icon: Icon(Icons.help));
  }

  Widget _buildSearchBar(BuildContext context, SelectDocumentState state) => Row(children: [
        Expanded(
            child: Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: state.settings.searchDocumentsType.getText(context), border: InputBorder.none),
              onChanged: context.read<SelectDocumentCubit>().onSearchTextChanged,
              controller: searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                  icon: Icon(UIConstants.cancelIconData),
                  onPressed: () {
                    searchTextController.text = "";
                    context.read<SelectDocumentCubit>().resetSearchText();
                  }),
              visible: state.textSearch.isNotEmpty,
            ),
          ),
        )),
        PopupMenuButton<SearchDocumentsType>(
          itemBuilder: (BuildContext a) => <PopupMenuEntry<SearchDocumentsType>>[
            PopupMenuItem<SearchDocumentsType>(
                value: SearchDocumentsType.byName, child: Text(AppLocalizations.of(context)!.search_by_name)),
            PopupMenuItem<SearchDocumentsType>(
                value: SearchDocumentsType.byDescription,
                child: Text(AppLocalizations.of(context)!.search_by_description)),
            PopupMenuItem<SearchDocumentsType>(
                value: SearchDocumentsType.byCustomerSupplier,
                child: Text(AppLocalizations.of(context)!.search_by_customer_supplier)),
          ],
          onSelected: context.read<SelectDocumentCubit>().setSearchDocumentsType,
        )
      ]);

  void onPressedDocument(Document item) async {
    Navigator.of(context).pop(item);
  }

  void onLongPressedDocument(Document item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteDocumentConfirm(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
            ],
          );
        },
        barrierDismissible: true);
  }

  void showDeleteDocumentConfirm(Document document) {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(AppLocalizations.of(context)!.message_confirm_delete, [document.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<SelectDocumentCubit>().delete(document.id!);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }
}
