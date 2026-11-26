import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/base/insufficient_stock_message.dart';
import 'package:good_manager/presentation/pages/documents/components/filter_document_widget.dart';
import 'package:good_manager/presentation/utils.dart';
import 'package:good_manager/util/currency_formatter.dart';
import 'package:good_manager/util/dimen.dart';
import 'package:good_manager/util/string_utils.dart';
import 'package:good_manager/util/toast_utils.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../../../constant/constant.dart';
import '../../../data/app_settings.dart';
import '../../../domain/entity/entity.dart';
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
  int _summaryTabIndex = 0;

  @override
  void initState() {
    context.read<DocumentsCubit>().initState(setting: widget.setting);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    super.initState();
  }

  void _onTabChanged() {
    if (!mounted || _tabController.index == _summaryTabIndex) return;
    setState(() => _summaryTabIndex = _tabController.index);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAllDocumentView(DocumentsState state) => Stack(
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
      );

  Widget _buildIncomingDocumentView(
    BuildContext context,
    DocumentsState state,
  ) =>
      Stack(
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
      );

  Widget _buildOutgoingDocumentView(
    BuildContext context,
    DocumentsState state,
  ) =>
      Stack(
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
      );

  Widget _buildBody(DocumentsState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _buildSearchRow(state),
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
        _buildSummary(state),
      ],
    );
  }

  List<Document> _documentsForSummary(DocumentsState state) {
    if (widget.isSelection) {
      return widget.documentType == DocumentType.incoming
          ? state.incomingDocuments
          : state.outgoingDocuments;
    }
    switch (_summaryTabIndex) {
      case 1:
        return state.incomingDocuments;
      case 2:
        return state.outgoingDocuments;
      default:
        return state.documents;
    }
  }

  Widget _buildSummary(DocumentsState state) {
    final items = _documentsForSummary(state);
    final quantity = items.fold<double>(0, (sum, item) => sum + item.quantity);
    final amount = items.fold<double>(0, (sum, item) => sum + item.amount);
    final showAmount = AppSettings.getGoodPropertiesSettings()
        .showPriceForAll(items.map((item) => item.type));
    return SummaryLine([
      SummaryLine.item(context.tr("documents"), items.length.toString()),
      SummaryLine.item(
        context.tr("quantity"),
        StringUtils.getQuantityText(quantity),
      ),
      if (showAmount)
        SummaryLine.item(
          context.tr("amount"),
          CurrencyFormatter.format(context, amount),
        ),
    ]);
  }

  Widget _buildSearchRow(DocumentsState state) {
    final bool showWarning = state.setting!.selectedStatus.isNotEmpty ||
        !_sortByDateNewestFirst(state);
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<DocumentsCubit>().onSearchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
          ),
        ),
        const SizedBox(width: 12),
        Badge(
          isLabelVisible: showWarning,
          child: IconButton(
            tooltip: context.tr('a11y_filter'),
            icon: const Icon(Icons.tune),
            onPressed: () => showFilterBottomSheet(state),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [
        Tab(text: context.tr("all").toUpperCase()),
        Tab(text: context.tr("incoming").toUpperCase()),
        Tab(text: context.tr("outgoing").toUpperCase()),
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
    final theme = Theme.of(context);
    return BlocConsumer<DocumentsCubit, DocumentsState>(
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: SafeArea(child: _buildBody(state)),
      ),
      listenWhen: (state1, state2) => state1.state != state2.state,
      listener: (context, state) async {
        if (state.state is InsufficientStockError) {
          ToastUtils.showErrorToast(insufficientStockMessage(
            (state.state as InsufficientStockError).error,
            AppSettings.getQuantityDecimals(),
            context.tr,
          ));
        } else if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": context.tr("documents"),
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
          await Navigator.of(context).pushNamed(
            Pages.payment_history,
            arguments: {"documentId": currentState.documentId},
          );
          context.read<DocumentsCubit>().loadItems();
        }
      },
    );
  }

  DocumentType? _typeForActiveTab() {
    switch (_tabController.index) {
      case 1:
        return DocumentType.incoming;
      case 2:
        return DocumentType.outgoing;
      default:
        return null;
    }
  }

  void _onAddDocumentWithType(DocumentType type) async {
    int storeId = context.read<DocumentsCubit>().getSelectedStoreId();
    String autoDocumentNo = context.read<DocumentsCubit>().getAutoDocumentNo();
    Document item = Document();
    item.storeId = storeId;
    item.type = type;
    item.name = context.tr("document_name_no") + autoDocumentNo;
    await Navigator.of(context)
        .pushNamed(Pages.save_document, arguments: {'item': item});
    context.read<DocumentsCubit>().loadItems();
  }

  Future<DocumentType?> showAddDocumentBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<DocumentType>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                context.tr("select_document_type"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: Text(context.tr("incoming")),
              subtitle: Text(context.tr("incoming_description")),
              onTap: () => Navigator.pop(context, DocumentType.incoming),
            ),
            ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              title: Text(context.tr("outgoing")),
              subtitle: Text(context.tr("outgoing_description")),
              onTap: () => Navigator.pop(context, DocumentType.outgoing),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(DocumentsState state) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        widget.isSelection
            ? context.tr("title_select_document")
            : context.tr("documents"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final type = _typeForActiveTab();
            if (type != null) {
              _onAddDocumentWithType(type);
              return;
            }
            final selected = await showAddDocumentBottomSheet(context);
            if (selected != null) {
              _onAddDocumentWithType(selected);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => context.read<DocumentsCubit>().onMenuHelpClicked(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildEmptyView(DocumentsState state) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UIConstants.documentIconData,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.1),
            ),
            SizedBox(height: 16),
            Text(
              context.tr("no_documents"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4)),
            ),
          ],
        ),
      );

  /// The date sort is ignored (newest first) while Date & Time is hidden; the
  /// saved sort setting itself is left untouched.
  bool _sortByDateNewestFirst(DocumentsState state) =>
      !AppSettings.getDocumentPropertiesSettings().showDateTime ||
      state.setting!.sortByDateNewestFirst;

  Widget _buildStickyListView(List<Document> documents, DocumentsState state) {
    final showDate = AppSettings.getDocumentPropertiesSettings().showDateTime;
    return ResetOnShrink(
        itemCount: documents.length,
        child: StickyGroupedListView<Document, DateTime>(
          elements: List.of(documents),
          groupBy: (Document payment) => DateTime(
            payment.date.year,
            payment.date.month,
            payment.date.day,
          ),
          stickyHeaderBackgroundColor:
              Theme.of(context).scaffoldBackgroundColor,
          groupSeparatorBuilder: (Document document) =>
              showDate ? DateItemRow(document.date) : const SizedBox.shrink(),
          itemBuilder: (context, Document document) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Dimens.screenPadding),
              child: DocumentItemRow(
                item: document,
                bgColor: Colors.transparent,
                incomingColor: state.incomingColor ?? Colors.red,
                outgoingColor: state.outgoingColor ?? Colors.green,
                showTimeOnly: true,
                onDocumentTapped: (item) {
                  onPressedDocument(item);
                },
                onDocumentLongPressed: (item) {
                  onLongPressedDocument(item);
                },
              ),
            );
          },
          itemComparator: (a, b) => a.date.compareTo(b.date),
          order: _sortByDateNewestFirst(state)
              ? StickyGroupedListOrder.DESC
              : StickyGroupedListOrder.ASC,
        ));
  }

  void showFilterBottomSheet(DocumentsState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext mContext) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (mContext, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
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
      if (showViewPaymentOption) context.tr("action_view_payments"),
      if (showCreatePaymentOption) context.tr("action_create_payment"),
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("action_view_payments")) {
          context.read<DocumentsCubit>().onViewLinkedPayments(item);
        } else if (items[index] == context.tr("action_create_payment")) {
          await context.read<DocumentsCubit>().onCreateAPayment(item);
        } else if (items[index] == context.tr("delete")) {
          showDeleteDocumentConfirm(item);
        }
      },
    );
  }

  void showDeleteDocumentConfirm(Document document) {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [
          AppSettings.getDocumentPropertiesSettings()
              .displayName(document, context.tr)
        ],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        context.read<DocumentsCubit>().delete(document.id!);
      },
    );
  }
}
