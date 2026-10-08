import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/documents/components/document_item_row.dart';
import 'package:good_manager/presentation/pages/goods/good_item_row.dart';
import 'package:good_manager/presentation/widget/search_bar_widget.dart';

import '../../../../domain/entity/entity.dart';
import '../pages.dart';
import 'bloc/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    context.read<SearchCubit>().init();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SearchBarWidget(
                focusNode: _focusNode,
                onTextChanged: (text) {
                  context.read<SearchCubit>().onSearchTextChanged(text);
                },
              ),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state.query.isEmpty) {
      return Center(
        child: Text(context.tr("type_to_search")),
      );
    }

    final hasResults = state.goods.isNotEmpty ||
        state.documents.isNotEmpty ||
        state.payments.isNotEmpty ||
        state.groups.isNotEmpty ||
        state.wallets.isNotEmpty;

    if (!hasResults) {
      return Center(
        child: Text(context.tr("no_results_found")),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.goods.isNotEmpty) ...[
          _buildSectionHeader(context, context.tr("goods")),
          ...state.goods.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GoodItemRow(
                  item: item,
                  quantity: item.quantity,
                  showBarcode: true,
                  showDescription: true,
                  showMinQuantity: true,
                  minQuantityColor: Colors.red,
                  onGoodTapped: (good) {
                    Navigator.of(context).pushNamed(
                      Pages.save_good,
                      arguments: {'item': good},
                    );
                  },
                  onGoodLongPressed: (good) {},
                  isSelection: false,
                ),
              )),
        ],
        if (state.documents.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("documents")),
          ...state.documents.map((item) => DocumentItemRow(
                item: item,
                bgColor: Theme.of(context).colorScheme.surface,
                incomingColor: state.incomingColor ?? Colors.red,
                outgoingColor: state.outgoingColor ?? Colors.green,
                onDocumentTapped: (doc) {
                  Navigator.of(context).pushNamed(
                    Pages.save_document,
                    arguments: {'item': doc},
                  );
                },
                onDocumentLongPressed: (doc) {},
              )),
        ],
        if (state.groups.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("groups")),
          ...state.groups.map((item) => Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Pages.save_group,
                      arguments: {'item': item},
                    );
                  },
                ),
              )),
        ],
        if (state.wallets.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("wallets")),
          ...state.wallets.map((item) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(item.color),
                  ),
                  title: Text(item.name),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Pages.save_wallet,
                      arguments: {'item': item},
                    );
                  },
                ),
              )),
        ],
        if (state.payments.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSectionHeader(context, context.tr("payments")),
          ...state.payments.map((item) => Card(
                child: ListTile(
                  title: Text(item.name.isEmpty
                      ? (item.category?.name ?? "")
                      : item.name),
                  subtitle: Text(item.description),
                  trailing: Text(
                    "${item.type == PaymentType.inbound ? "+" : "-"}${item.amount ?? 0}",
                    style: TextStyle(
                      color: item.type == PaymentType.inbound
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Pages.save_payment,
                      arguments: {'item': item},
                    );
                  },
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
