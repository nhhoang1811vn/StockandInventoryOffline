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
  final bool isSelection;
  final DocumentType? selectionType;

  const DocumentsPage({required this.isSelection, this.selectionType, required Key? key}) : super(key: key);

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends BaseStateWidget<DocumentsPage> {
  final _key = GlobalKey<ExpandableFabState>();
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    context.read<DocumentsCubit>().initState(widget.isSelection);
    super.initState();
  }

  @override
  bool hasDrawer() {
    return true;
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

  int getInitialIndex() {
    if (widget.isSelection) {
      if (widget.selectionType == DocumentType.incoming) {
        return 1;
      } else {
        return 2;
      }
    }
    return 0;
  }

  Widget getFloatingActionButton(int index) {
    if (index == 0) {
      return ExpandableFab(
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
            icon: Image(image: AssetImage('assets/images/document.png'), width: 24),
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
              icon: Image(image: AssetImage('assets/images/document.png'), width: 24),
              label: Text(AppLocalizations.of(context)!.outgoing_document_text),
              onPressed: () {
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
                _onAddDocumentWithType(DocumentType.outgoing);
              }),
        ],
      );
    } else if (index == 1) {
      return FloatingActionButton(
        onPressed: () {
          _onAddDocumentWithType(DocumentType.incoming);
        },
        child: Icon(Icons.add),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
          _onAddDocumentWithType(DocumentType.outgoing);
        },
        child: Icon(Icons.add),
      );
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
        builder: (context, state) => DefaultTabController(
            initialIndex: getInitialIndex(),
            length: 3,
            child: Builder(builder: (BuildContext context) {
              return Scaffold(
                key: ScaffoldKey,
                appBar: _buildAppBar(state),
                body: TabBarView(children: [
                  _buildAllDocumentView(state),
                  _buildIncomingDocumentView(context, state),
                  _buildOutgoingDocumentView(context, state),
                ]),
                floatingActionButtonLocation: ExpandableFab.location,
                floatingActionButton: getFloatingActionButton(0),
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
                context: context, builder: (_) => SortDocumentsDialog(state.settings), barrierDismissible: true);
            if (settings != null) {
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

  Widget _buildEmptyView(DocumentsState state) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/document.png'), width: 60),
          SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.empty_document,
              textAlign: TextAlign.center, style: AppStyle.getEmptyTextStyle())
        ],
      );
  Widget _buildListView(List<DocumentUI> items) => ListView.builder(
      itemBuilder: (BuildContext context, index) {
        DocumentUI item = items[index];
        if (item.type == DocumentUIType.data) {
          return DocumentItemRow2(
              false, item.document!, (item) => onPressedDocument(item), (item) => onLongPressedDocument(item));
        } else {
          return DocumentDateRow(item.dateText);
        }
      },
      itemCount: items.length);

  Widget _buildSearchMenu(DocumentsState state) {
    return IconButton(
        onPressed: () {
          searchTextController.text = "";
          context.read<DocumentsCubit>().onSearchMenuClicked();
        },
        icon: Icon(Icons.search,
            color: state.showSearchBar ? UIConstants.highlightMenuColor : UIConstants.normalMenuColor));
  }

  Widget _buildSortMenu() {
    return IconButton(
        onPressed: () {
          context.read<DocumentsCubit>().onMenuSortClicked();
        },
        icon: Icon(Icons.sort,
            color: context.read<DocumentsCubit>().hasSortOptions()
                ? UIConstants.highlightMenuColor
                : UIConstants.normalMenuColor));
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          context.read<DocumentsCubit>().onMenuHelpClicked();
        },
        icon: Icon(Icons.help));
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
    if (widget.isSelection) {
      Navigator.of(context).pop(item);
    } else {
      await Navigator.of(context).pushNamed(Pages.save_document, arguments: {'item': item});
      context.read<DocumentsCubit>().loadItems();
    }
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
