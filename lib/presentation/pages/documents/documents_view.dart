import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/documents/components/filter_document_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/util.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/documents_cubit.dart';
import 'components/document_item_row.dart';

class DocumentsPage extends StatefulWidget {
  final bool isSelection;
  final DocumentType? documentType;
  final DocumentsSetting? setting;

  const DocumentsPage({
    this.documentType,
    this.isSelection = false,
    this.setting,
  }) : super();

  @override
  DocumentPageState createState() => DocumentPageState();
}

class DocumentPageState extends State<DocumentsPage>
    with SingleTickerProviderStateMixin {
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
            child: Stack(
              children: [
                Visibility(
                  child: _buildEmptyView(state),
                  visible: state.documents.isEmpty,
                ),
                Visibility(
                  child: _buildStickyListView(state.documents, state),
                  visible: state.documents.isNotEmpty,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildIncomingDocumentView(
    BuildContext context,
    DocumentsState state,
  ) =>
      Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  child: _buildEmptyView(state),
                  visible: state.incomingDocuments.isEmpty,
                ),
                Visibility(
                  child: _buildStickyListView(state.incomingDocuments, state),
                  visible: state.incomingDocuments.isNotEmpty,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildOutgoingDocumentView(
    BuildContext context,
    DocumentsState state,
  ) =>
      Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  child: _buildEmptyView(state),
                  visible: state.outgoingDocuments.isEmpty,
                ),
                Visibility(
                  child: _buildStickyListView(state.outgoingDocuments, state),
                  visible: state.outgoingDocuments.isNotEmpty,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildBody(DocumentsState state) {
    return Column(
      children: [
        SelectedStoreView(),
        Visibility(
          visible: state.showSearchBar,
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
        if (!widget.isSelection)
          Expanded(
            child: Column(
              children: [
                _buildTabBar(),
                Expanded(child: _buildTabBarView(state)),
              ],
            ),
          )
        else if (widget.documentType == DocumentType.incoming)
          Expanded(child: _buildIncomingDocumentView(context, state))
        else
          Expanded(child: _buildOutgoingDocumentView(context, state)),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: [
        Tab(
          text:
              AppLocalizations.of(context)!.document_list_tab_all.toUpperCase(),
        ),
        Tab(
          text: AppLocalizations.of(context)!
              .incoming_document_text
              .toUpperCase(),
        ),
        Tab(
          text: AppLocalizations.of(context)!
              .outgoing_document_text
              .toUpperCase(),
        ),
      ],
    );
  }

  Widget _buildTabBarView(DocumentsState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllDocumentView(state),
        _buildIncomingDocumentView(context, state),
        _buildOutgoingDocumentView(context, state),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
      builder: (context, state) => Scaffold(
        appBar: _buildAppBar(state),
        body: _buildBody(state),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            DocumentType? type = await showAddDocumentBottomSheet(context);
            if (type != null) {
              _onAddDocumentWithType(type);
            }
          },
          child: Icon(Icons.add),
        ),
      ),
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": AppLocalizations.of(context)!.documents_title,
              "content":
                  MDProviderFactory.get().getHelpText(HelpType.DOCUMENTS),
            },
          );
        } else if (state.state is OpenSavePaymentPageState) {
          final currentState = state.state as OpenSavePaymentPageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_payment,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<DocumentsCubit>().loadItems();
          }
        } else if (state.state is OpenPaymentHistoryPageState) {
          final currentState = state.state as OpenPaymentHistoryPageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.payment_history,
            arguments: {"documentId": currentState.documentId},
          );
          context.read<DocumentsCubit>().loadItems();
        }
      },
    );
  }

  void _onAddDocumentWithType(DocumentType type) async {
    int storeId = context.read<DocumentsCubit>().getSelectedStoreId();
    String autoDocumentNo = context.read<DocumentsCubit>().getAutoDocumentNo();
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = AppLocalizations.of(context)!.document_name_no + autoDocumentNo;
    await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: {'item': item});
    context.read<DocumentsCubit>().loadItems();
  }

  Future<DocumentType?> showAddDocumentBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<DocumentType>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.select_document_type,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.incoming_document_text),
              onTap: () => Navigator.pop(context, DocumentType.incoming),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.outgoing_document_text),
              onTap: () => Navigator.pop(context, DocumentType.outgoing),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(DocumentsState state) {
    return AppBar(
      title: widget.isSelection
          ? Text(AppLocalizations.of(context)!.title_select_document)
          : Text(AppLocalizations.of(context)!.documents_title),
      actions: [
        _buildSearchMenu(state),
        _buildFilterMenu(state),
        _buildHelpMenu(),
      ],
    );
  }

  Widget _buildEmptyView(DocumentsState state) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            UIConstants.documentIconData,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.empty_document,
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _buildStickyListView(List<Document> documents, DocumentsState state) {
    final groupedElements = List.of(documents);
    return StickyGroupedListView<Document, DateTime>(
      elements: List.of(documents),
      groupBy: (Document payment) => DateTime(
        payment.date.year,
        payment.date.month,
        payment.date.day,
      ),
      groupSeparatorBuilder: (Document document) => DateItemRow(document.date),
      itemBuilder: (context, Document document) {
        final index = groupedElements.indexOf(document);
        return DocumentItemRow(
          item: document,
          bgColor: index.isEven
              ? ColorUtils.getItemBgColor1(context)
              : ColorUtils.getItemBgColor2(context),
          incomingColor: state.incomingColor,
          outgoingColor: state.outgoingColor,
          onDocumentTapped: (item) {
            onPressedDocument(item);
          },
          onDocumentLongPressed: (item) {
            onLongPressedDocument(item);
          },
        );
      },
      itemComparator: (a, b) => b.date.compareTo(a.date),
      order: state.setting!.sortByDateNewestFirst
          ? StickyGroupedListOrder.DESC
          : StickyGroupedListOrder.ASC,
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
      icon: Icon(
        Icons.search,
        color: state.showSearchBar
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _buildFilterMenu(DocumentsState state) {
    bool showWarning = (state.setting!.selectedStatus.isNotEmpty ||
        !state.setting!.sortByDateNewestFirst);
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            showFilterBottomSheet(state);
          },
          icon: Icon(Icons.filter_alt),
        ),
        if (showWarning)
          Positioned(
            right: 4,
            top: 4,
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: 16,
            ),
          ),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHelpMenu() {
    return IconButton(
      onPressed: () {
        context.read<DocumentsCubit>().onMenuHelpClicked();
      },
      icon: Icon(Icons.help),
    );
  }

  void onPressedDocument(Document item) async {
    if (widget.isSelection) {
      Navigator.of(context).pop(item);
    } else {
      await Navigator.of(context)
          .pushNamed(Pages.save_document, arguments: {'item': item});
      context.read<DocumentsCubit>().loadItems();
    }
  }

  void onLongPressedDocument(Document item) {
    var status = Utils.getStatus(item);
    var showCreatePaymentOption = false;
    var showViewPaymentOption = false;
    if (status == DocumentPaidStatus.partial ||
        status == DocumentPaidStatus.unpaid) {
      showCreatePaymentOption = true;
    }
    if (status == DocumentPaidStatus.partial ||
        status == DocumentPaidStatus.paid) {
      showViewPaymentOption = true;
    }

    var items = [
      if (showViewPaymentOption)
        AppLocalizations.of(context)!.action_view_payments,
      if (showCreatePaymentOption)
        AppLocalizations.of(context)!.action_create_payment,
      AppLocalizations.of(context)!.action_delete,
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] ==
            AppLocalizations.of(context)!.action_view_payments) {
          context.read<DocumentsCubit>().onViewLinkedPayments(item);
        } else if (items[index] ==
            AppLocalizations.of(context)!.action_create_payment) {
          await context.read<DocumentsCubit>().onCreateAPayment(item);
        } else if (items[index] ==
            AppLocalizations.of(context)!.action_delete) {
          showDeleteDocumentConfirm(item);
        }
      },
    );
  }

  void showDeleteDocumentConfirm(Document document) {
    showCustomAlertDialog(
      context,
      message: sprintf(
        AppLocalizations.of(context)!.message_confirm_delete,
        [document.name],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        context.read<DocumentsCubit>().delete(document.id!);
      },
    );
  }
}
