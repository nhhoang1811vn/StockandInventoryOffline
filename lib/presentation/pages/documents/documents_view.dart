import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/documents/components/filter_document_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../widgets/date_item_row.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/documents_cubit.dart';
import 'components/add_document_dialog.dart';
import 'components/document_item_row.dart';

class DocumentsPage extends StatefulWidget {
  final bool isSelection;
  final DocumentType? documentType;
  final DocumentsSetting? setting;

  const DocumentsPage({this.documentType, this.isSelection = false, this.setting}) : super();

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    context.read<DocumentsCubit>().initState(setting: widget.setting);
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
              visible: state.documents.isEmpty,
            ),
            Visibility(
              child: _buildStickyListView(state.documents, state),
              visible: state.documents.isNotEmpty,
            )
          ]))
        ],
      );

  Widget _buildIncomingDocumentView(BuildContext context, DocumentsState state) => Column(
        children: [
          Expanded(
            child: Stack(children: [
              Visibility(child: _buildEmptyView(state), visible: state.incomingDocuments.isEmpty),
              Visibility(
                  child: _buildStickyListView(state.incomingDocuments, state),
                  visible: state.incomingDocuments.isNotEmpty)
            ]),
          )
        ],
      );

  Widget _buildOutgoingDocumentView(BuildContext context, DocumentsState state) => Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Visibility(child: _buildEmptyView(state), visible: state.outgoingDocuments.isEmpty),
                Visibility(
                    child: _buildStickyListView(state.outgoingDocuments, state),
                    visible: state.outgoingDocuments.isNotEmpty)
              ],
            ),
          )
        ],
      );

  Widget _buildBody(DocumentsState state) {
    if (widget.isSelection) {
      if (widget.documentType == DocumentType.incoming) {
        return Container(width: double.infinity, child: _buildIncomingDocumentView(context, state));
      } else if (widget.documentType == DocumentType.outgoing) {
        return Container(width: double.infinity, child: _buildOutgoingDocumentView(context, state));
        //return
      }
    }
    return TabBarView(controller: _tabController, children: [
      _buildAllDocumentView(state),
      _buildIncomingDocumentView(context, state),
      _buildOutgoingDocumentView(context, state),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
        builder: (context, state) => Scaffold(
              appBar: _buildAppBar(state),
              body: _buildBody(state),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (_tabController.index == 1) {
                    _onAddDocumentWithType(DocumentType.incoming);
                  } else if (_tabController.index == 2) {
                    _onAddDocumentWithType(DocumentType.outgoing);
                  } else {
                    //show dialog
                    DocumentType? type = await showDialog(
                        context: context, builder: (_) => AddDocumentDialogWidget(), barrierDismissible: true);
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
          }
          // else if (state.state is OpenSortDialogListState) {
          //   DocumentsSetting? settings = await showDialog(
          //       context: context, builder: (_) => SortDocumentsDialog(state.settings), barrierDismissible: true);
          //   if (settings != null) {
          //     context.read<DocumentsCubit>().setSettings(settings);
          //   }
          // }
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
    double topHeight = 58;
    double storeHeight = 30;
    double searchBarHeight = 58 + 16;
    double tabBarHeight = 58;
    return PreferredSize(
      preferredSize: Size.fromHeight(topHeight +
          storeHeight +
          (widget.isSelection ? 0 : tabBarHeight) +
          (state.showSearchBar ? searchBarHeight : 0)),
      child: AppBar(
        actions: [
          _buildSearchMenu(state),
          _buildFilterMenu(state),
          //_buildSortMenu(),
          _buildHelpMenu()
        ],
        title: widget.isSelection
            ? Text(AppLocalizations.of(context)!.title_select_document)
            : Text(AppLocalizations.of(context)!.documents_title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              storeHeight + (widget.isSelection ? 0 : tabBarHeight) + (state.showSearchBar ? searchBarHeight : 0)),
          child: Column(
            children: [
              Container(height: storeHeight, child: SelectedStoreView()),
              Visibility(
                visible: state.showSearchBar,
                child: Container(
                  height: searchBarHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchBarWidget(
                      onTextChanged: (newValue) {
                        context.read<DocumentsCubit>().onSearchTextChanged(newValue);
                      },
                      focusNode: searchTextFocusNode,
                    ),
                  ),
                ),
              ),
              if (!widget.isSelection)
                Container(
                  height: tabBarHeight,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.document_list_tab_all.toUpperCase()),
                      Tab(text: AppLocalizations.of(context)!.incoming_document_text.toUpperCase()),
                      Tab(text: AppLocalizations.of(context)!.outgoing_document_text.toUpperCase()),
                    ],
                  ),
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
          Text(AppLocalizations.of(context)!.empty_document, textAlign: TextAlign.center)
        ],
      );

  // Widget _buildListView(List<ListItem> items) {
  //   var flag = true;
  //   return ListView.builder(
  //       itemBuilder: (BuildContext context, index) {
  //         ListItem item = items[index];
  //         if (item is HeaderItem) {
  //           flag = true;
  //           return DateItemRow(item.date);
  //         } else if (item is DocumentListItem) {
  //           flag = !flag;
  //           return DocumentItemRow(
  //               item.document, flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context), (item) {
  //             onPressedDocument(item);
  //           }, (item) {
  //             onLongPressedDocument(item);
  //           });
  //         } else {
  //           return SizedBox();
  //         }
  //       },
  //       itemCount: items.length);
  // }
  Widget _buildStickyListView(List<Document> documents, DocumentsState state) {
    var flag = true;
    return StickyGroupedListView<Document, DateTime>(
      elements: List.of(documents),
      groupBy: (Document payment) => DateTime(
        payment.date.year,
        payment.date.month,
        payment.date.day,
      ),
      groupSeparatorBuilder: (Document document) => DateItemRow(document.date),
      itemBuilder: (context, Document document) {
        flag = !flag;
        return DocumentItemRow(
            item: document,
            bgColor: flag ? ColorUtils.getItemBgColor1(context) : ColorUtils.getItemBgColor2(context),
            incomingColor: state.incomingColor,
            outgoingColor: state.outgoingColor,
            onDocumentTapped: (item) {
              onPressedDocument(item);
            },
            onDocumentLongPressed: (item) {
              onLongPressedDocument(item);
            });
      },
      itemComparator: (a, b) => b.date.compareTo(a.date),
      order: state.setting!.sortByDateNewestFirst ? StickyGroupedListOrder.DESC :StickyGroupedListOrder.ASC,
    );
  }

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

  // Widget _buildSortMenu() {
  //   return IconButton(
  //       onPressed: () {
  //         context.read<DocumentsCubit>().onMenuSortClicked();
  //       },
  //       icon: Icon(Icons.sort,
  //           color: context.read<DocumentsCubit>().hasSortOptions()
  //               ? Theme.of(context).colorScheme.primary
  //               : Theme.of(context).iconTheme.color));
  // }

  Widget _buildFilterMenu(DocumentsState state) {
    bool showWarning = (state.setting!.selectedStatus.isNotEmpty || !state.setting!.sortByDateNewestFirst);
    return Stack(
      children: [
        IconButton(
            onPressed: () {
              showFilterBottomSheet(state);
            },
            icon: Icon(Icons.filter_alt)),
        if (showWarning)
          Positioned(
            right: 4,
            top: 4,
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 16,
            ),
          )
      ],
    );
  }

  void showFilterBottomSheet(DocumentsState state) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext mContext) {
          return DraggableScrollableSheet(
              expand: false,
              builder: (mContext, scrollController) {
                return SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.all(16),
                    child: FilterDocumentWidget(
                      onResetAllPressed: () {
                        context.read<DocumentsCubit>().resetAllFilter();
                        Navigator.of(context).pop();
                      },
                      onApplyPressed: (setting) {
                        context.read<DocumentsCubit>().applyFilter(setting);
                        Navigator.of(context).pop();
                      },
                      setting: state.setting!,
                    ));
              });
        });
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          context.read<DocumentsCubit>().onMenuHelpClicked();
        },
        icon: Icon(Icons.help));
  }

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
