import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/documents/components/document_date_row.dart';
import 'package:good_manager/presentation/pages/documents/document_ui.dart';
import 'package:good_manager/presentation/pages/documents/sort_documents_dialog.dart';
import 'package:sprintf/sprintf.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/documents_cubit.dart';
import 'components/add_document_dialog.dart';
import 'components/document_item_row.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({required Key? key}) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    context.read<DocumentsCubit>().initState();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAllDocumentView(DocumentsState state) => Column(
        children: [
          Expanded(
              child: Stack(children: [
            Visibility(
              child: _buildEmptyView(state),
              visible: state.items.isEmpty,
            ),
            Visibility(
              child: _buildListView(state.items),
              visible: state.items.isNotEmpty,
            )
          ]))
        ],
      );

  Widget _buildIncomingDocumentView(BuildContext context, DocumentsState state) => Column(
        children: [
          Expanded(
            child: Stack(children: [
              Visibility(child: _buildEmptyView(state), visible: state.incomingItems.isEmpty),
              Visibility(child: _buildListView(state.incomingItems), visible: state.incomingItems.isNotEmpty)
            ]),
          )
        ],
      );

  Widget _buildOutgoingDocumentView(BuildContext context, DocumentsState state) => Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Visibility(child: _buildEmptyView(state), visible: state.outgoingItems.isEmpty),
                Visibility(child: _buildListView(state.outgoingItems), visible: state.outgoingItems.isNotEmpty)
              ],
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
        builder: (context, state) => Scaffold(
          
              appBar: _buildAppBar(state),
              body: TabBarView(controller: _tabController, children: [
                _buildAllDocumentView(state),
                _buildIncomingDocumentView(context, state),
                _buildOutgoingDocumentView(context, state),
              ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () async{
                  if (_tabController.index == 1){
                    _onAddDocumentWithType(DocumentType.incoming);
                  }else if (_tabController.index == 2){
                    _onAddDocumentWithType(DocumentType.outgoing);
                  }else{
                    //show dialog
                    DocumentType? type =
                        await showDialog(context: context, builder: (_) => AddDocumentDialogWidget(), barrierDismissible: true);
                    if (type != null) {
                      _onAddDocumentWithType(type);
                    }

                  }

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
              context.read<DocumentsCubit>().setSettings(settings);
            }
          }
        });
  }

  void _onAddDocumentWithType(DocumentType type) async {
    int storeId = context.read<DocumentsCubit>().getSelectedStoreId();
    String autoDocumentNo = context.read<DocumentsCubit>().getAutoDocumentNo();
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = AppLocalizations.of(context)!.document_name_no + autoDocumentNo;
    await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
    context.read<DocumentsCubit>().loadItems();
  }

  PreferredSize _buildAppBar(DocumentsState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(58.0 + 20 + 58.0 + (state.showSearchBar ? 65 : 0)),
      child: AppBar(
        actions: [_buildSearchMenu(state), _buildSortMenu(), _buildHelpMenu()],
        title: Text(AppLocalizations.of(context)!.documents_title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20 + 58 + (state.showSearchBar ? 65 : 0)),
          child: Column(
            children: [
              SelectedStoreView(),
              Visibility(
                visible: state.showSearchBar,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, top : 16),
                  child: SearchBarWidget(
                    onTextChanged: (newValue) {
                      context.read<DocumentsCubit>().onSearchTextChanged(newValue);
                    },
                    focusNode: searchTextFocusNode,
                  ),
                ),
              ),
              //Visibility(child: _buildSearchBar(context, state), visible: state.showSearchBar),
              TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.document_list_tab_all.toUpperCase()),
                  Tab(text: AppLocalizations.of(context)!.incoming_document_text.toUpperCase()),
                  Tab(text: AppLocalizations.of(context)!.outgoing_document_text.toUpperCase()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(DocumentsState state) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(UIConstants.documentIconData, size: 64, color: Theme.of(context).colorScheme.primary),
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

  Widget _buildSearchMenu(DocumentsState state) {
    return IconButton(
        onPressed: () {
          if (!state.showSearchBar) {
            searchTextFocusNode.requestFocus();
          }
          //searchTextController.text = "";
          context.read<DocumentsCubit>().onSearchMenuClicked();
        },
        icon: Icon(Icons.search,
            color: state.showSearchBar ? Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color));
  }

  Widget _buildSortMenu() {
    return IconButton(
        onPressed: () {
          context.read<DocumentsCubit>().onMenuSortClicked();
        },
        icon: Icon(Icons.sort,
            color: context.read<DocumentsCubit>().hasSortOptions()
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color));
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          context.read<DocumentsCubit>().onMenuHelpClicked();
        },
        icon: Icon(Icons.help));
  }

  void onPressedDocument(Document item) async {
    await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
    context.read<DocumentsCubit>().loadItems();
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
                  context.read<DocumentsCubit>().delete(document.id!);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }
}
