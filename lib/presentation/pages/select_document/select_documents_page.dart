import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/documents/components/document_date_row.dart';
import 'package:good_manager/presentation/pages/documents/document_ui.dart';
import 'package:good_manager/presentation/pages/documents/sort_documents_dialog.dart';
import 'package:good_manager/presentation/pages/select_document/bloc/select_document_cubit.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/search_bar_widget.dart';
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
  //final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();
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
    //int storeId = storage.getSelectedStoreId();
    int storeId = context.read<SelectDocumentCubit>().getSelectedStoreId();
    int autoDocumentNo = context.read<SelectDocumentCubit>().getAutoDocumentNo(storeId);
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = AppLocalizations.of(context)!.document_name_no + autoDocumentNo.toString();
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
              Visibility(
                visible: state.showSearchBar,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top : 16),
                  child: SearchBarWidget(
                    onTextChanged: (newValue) {
                      context.read<SelectDocumentCubit>().onSearchTextChanged(newValue);
                    },
                    focusNode: searchTextFocusNode,
                  ),
                ),
              ),
              //Visibility(child: _buildSearchBar(context, state), visible: state.showSearchBar),
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
              textAlign: TextAlign.center)
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
          if (!state.showSearchBar) {
            searchTextFocusNode.requestFocus();
          }
         context.read<SelectDocumentCubit>().onSearchMenuClicked();
        },
        icon: Icon(Icons.search,
            color: state.showSearchBar ? Theme.of(context).colorScheme.primary: Theme.of(context).iconTheme.color));
  }

  Widget _buildSortMenu() {
    return IconButton(
        onPressed: () {
          context.read<SelectDocumentCubit>().onMenuSortClicked();
        },
        icon: Icon(Icons.sort,
            color: context.read<SelectDocumentCubit>().hasSortOptions()
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color));
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          context.read<SelectDocumentCubit>().onMenuHelpClicked();
        },
        icon: Icon(Icons.help));
  }
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
