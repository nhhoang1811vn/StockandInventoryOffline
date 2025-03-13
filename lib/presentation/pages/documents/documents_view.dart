import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/documents/components/document_date_row.dart';
import 'package:good_manager/presentation/pages/documents/document_ui.dart';
import 'package:good_manager/presentation/pages/documents/sort_documents_dialog.dart';
import 'package:sprintf/sprintf.dart';

import '../../app_style.dart';
import '../../widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/documents_cubit.dart';
import 'document_item_row2.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({required Key? key}) : super(key: key);
  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends BaseStateWidget<DocumentsPage> {
  final _key = GlobalKey<ExpandableFabState>();
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    context.read<DocumentsCubit>().initState();
    super.initState();
  }
  @override
  bool hasDrawer() {
    return true;
  }
  Widget _buildAllDocumentView(DocumentsState state) {
    return getAllBody(state);
  }

  Widget getAllBody(DocumentsState state) {
    List<Widget> children = [
      Expanded(
          child: Stack(children: [
        Visibility(
          child: _buildAllEmptyView(state),
          visible: state.items.isEmpty,
        ),
        Visibility(
          child: _buildAllListView(state),
          visible: state.items.isNotEmpty,
        )
      ]))
    ];
    return Column(children: children);
  }

  Widget _buildIncomingDocumentView(BuildContext context, DocumentsState state) => Column(
    children: [Expanded(
      child: Stack(
            children: [_buildIncomingEmptyView(context, state), _buildIncomingListView(state)],
          ),
    )],
  );

  Widget _buildOutgoingDocumentView(BuildContext context, DocumentsState state) => Column(
    children: [Expanded(
      child: Stack(
            children: [_buildOutgoingEmptyView(context, state), _buildOutgoingListView(state)],
          ),
    )],
  );

  @override
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
        builder: (context, state) => DefaultTabController(
            length: 3,
            child: Builder(builder: (BuildContext context) {
              return Scaffold(
                  key: ScaffoldKey,
                  //drawer: CustomNavigationDrawer(selectedIndex: 2, storeName: storage.getSelectedStoreName()),
                  appBar: _buildAppBar(state),
                  body: TabBarView(children: [
                    _buildAllDocumentView(state),
                    _buildIncomingDocumentView(context, state),
                    _buildOutgoingDocumentView(context, state),
                  ]),
                  floatingActionButtonLocation: ExpandableFab.location,
                  floatingActionButton: ExpandableFab(
                    key: _key,
                    openButtonBuilder: RotateFloatingActionButtonBuilder(
                      child: const Icon(Icons.add),
                    ),
                    type: ExpandableFabType.up,
                    //childrenAnimation: ExpandableFabAnimation.none,
                    distance: 70,
                    overlayStyle: ExpandableFabOverlayStyle(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    children: [
                      FloatingActionButton.extended(
                        icon:  Image(image: AssetImage('assets/images/document.png'), width: 24),
                        label: Text(AppLocalizations.of(context)!.incoming_document_text),
                        heroTag: null,
                        onPressed: () {
                          final state = _key.currentState;
                          if (state != null) {
                            state.toggle();
                          }
                          _onAddDocumentWithType(DocumentType.incoming);
                        },
                      ),
                      FloatingActionButton.extended(
                          icon:  Image(image: AssetImage('assets/images/document.png'), width: 24),
                          label: Text(AppLocalizations.of(context)!.outgoing_document_text),
                          onPressed: (){
                            final state = _key.currentState;
                            if (state != null) {
                              state.toggle();
                            }
                            _onAddDocumentWithType(DocumentType.outgoing);
                          }
                      ),
                    ],
                  ),
              );
            })),
        listenWhen: (state1, state2) => state1.state != state2.state,
        listener: (context, state) async {
          if (state.state is OpenHelpPageState) {
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)!.documents_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.DOCUMENTS)
            });
          } else if (state.state is OpenSortDialogListState) {
            DocumentsSetting? settings = await showDialog(
                context: context,
                builder: (_) => SortDocumentsDialog(state.settings),
                barrierDismissible: true);
            if (settings != null){
              context.read<DocumentsCubit>().setSettings(settings);
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
              Visibility(child: _buildSearchBar(context, state), visible: state.showSearchBar),
              TabBar(
                indicatorColor: Theme.of(context).colorScheme.onPrimary,
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

  Widget _buildAllEmptyView(DocumentsState state) => Visibility(
      visible: state.items.isEmpty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/document.png'), width: 60),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.empty_document,
              textAlign: TextAlign.center,
              style: AppStyle.getEmptyTextStyle())
        ],
      ));

  Widget _buildIncomingEmptyView(BuildContext context, DocumentsState state) => Visibility(
      visible: state.incomingItems.isEmpty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/document.png'), width: 60),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.empty_incoming_document, textAlign: TextAlign.center,style: AppStyle.getEmptyTextStyle())
        ],
      ));

  Widget _buildOutgoingEmptyView(BuildContext context, DocumentsState state) => Visibility(
      visible: state.outgoingItems.isEmpty,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/document.png'), width: 60),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.empty_outgoing_document, textAlign: TextAlign.center, style: AppStyle.getEmptyTextStyle())
        ],
      ));

  Widget _buildAllListView(DocumentsState state) => Visibility(
      visible: state.items.isNotEmpty,
      child: ListView.builder(
          itemBuilder: (BuildContext context, index) {
            DocumentUI item = state.items[index];
            if (item.type == DocumentUIType.data) {
              return DocumentItemRow2(
                  true, item.document!, (item) => onPressedDocument(item), (item) => onLongPressedDocument(item));
            } else {
              return DocumentDateRow(item.dateText);
            }
          },
          itemCount: state.items.length));

  Widget _buildIncomingListView(DocumentsState state) => Visibility(
      visible: state.incomingItems.isNotEmpty,
      child: ListView.builder(
          itemBuilder: (BuildContext context, index) {
            DocumentUI item = state.incomingItems[index];
            if (item.type == DocumentUIType.data) {
              return DocumentItemRow2(
                  false, item.document!, (item) => onPressedDocument(item), (item) => onLongPressedDocument(item));
            } else {
              return DocumentDateRow(item.dateText);
            }
            },
          itemCount: state.incomingItems.length));

  Widget _buildOutgoingListView(DocumentsState state) => Visibility(
      visible: state.outgoingItems.isNotEmpty,
      child: ListView.builder(
          itemBuilder: (BuildContext context, index) {
            DocumentUI item = state.outgoingItems[index];
            if (item.type == DocumentUIType.data) {
              return DocumentItemRow2(
                  false, item.document!, (item) => onPressedDocument(item), (item) => onLongPressedDocument(item));
            } else {
              return DocumentDateRow(item.dateText);
            }
            },
          itemCount: state.outgoingItems.length));
  Widget _buildSearchMenu(DocumentsState state){
    return IconButton(onPressed: (){
      searchTextController.text = "";
      context.read<DocumentsCubit>().onSearchMenuClicked();
    }, icon: Icon(Icons.search, color: state.showSearchBar ? UIConstants.highlightMenuColor : UIConstants.normalMenuColor));
  }
  Widget _buildSortMenu(){
    return IconButton(onPressed: (){
      context.read<DocumentsCubit>().onMenuSortClicked();
    }, icon: Icon(Icons.sort, color: context.read<DocumentsCubit>().hasSortOptions() ? UIConstants.highlightMenuColor : UIConstants.normalMenuColor));
  }
  Widget _buildHelpMenu(){
    return IconButton(onPressed: (){
      context.read<DocumentsCubit>().onMenuHelpClicked();
    }, icon: Icon(Icons.help));
  }




  Widget _buildSearchBar(BuildContext context, DocumentsState state) => Row(children: [
        Expanded(
            child: Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: state.settings.searchDocumentsType.getText(context), border: InputBorder.none),
              onChanged: context.read<DocumentsCubit>().onSearchTextChanged,
              controller: searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                  icon: Icon(UIConstants.cancelIconData),
                  onPressed: () {
                    searchTextController.text = "";
                    context.read<DocumentsCubit>().resetSearchText();
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
          onSelected: context.read<DocumentsCubit>().setSearchDocumentsType,
        )
      ]);

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
