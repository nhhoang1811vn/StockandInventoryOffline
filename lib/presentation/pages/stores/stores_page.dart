import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart';
import 'package:good_manager/util/toast_utils.dart';
import 'package:sprintf/sprintf.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../domain/free_limits.dart';
import '../../dialog/dialog.dart';
import '../../widget/widget.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'components/filter_store_widget.dart';
import 'components/store_item_row.dart';

class StoresPage extends StatefulWidget {
  final bool isSelection;

  StoresPage({
    Key? key,
    required this.isSelection,
  });

  @override
  StoresPageState createState() => StoresPageState();
}

class StoresPageState extends State<StoresPage> {
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<StoresCubit>().initState(widget.isSelection);
  }

  @override
  void dispose() {
    searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<StoresCubit, StoresState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
      listener: (context, state) async {
        if (state.state is OpenSaveStorePageState) {
          final currentState = state.state as OpenSaveStorePageState;
          final result = await Navigator.of(context).pushNamed(
            Pages.save_store,
            arguments: {"item": currentState.item},
          );
          if (result != null) {
            context.read<StoresCubit>().loadItems();
          }
        } else if (state.state is OpenHelpPageState) {
          Navigator.of(context).pushNamed(
            Pages.help,
            arguments: {
              "title": context.tr("stores"),
              "content": MDProviderFactory.get().getHelpText(HelpType.STORE),
            },
          );
        } else if (state.state is DeleteItemError) {
          ToastUtils.showErrorToast(context.tr("delete_store_error"));
        } else if (state.state is OpenBuySubscriptionDialogState) {
          showBuySubscriptionDialog(
            context,
            message: sprintf(
              context.tr("buy_subscription_to_add_more_entity"),
              [FreeLimits.storeLimit],
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: SafeArea(child: _buildBody(state)),
      ),
    );
  }

  AppBar _buildAppBar(StoresState data) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        widget.isSelection ? context.tr("select_store") : context.tr("stores"),
        style: TextStyle(
            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        IconButton(
          tooltip: context.tr('a11y_add'),
          icon: const Icon(Icons.add),
          onPressed: () => context.read<StoresCubit>().onAddButtonClicked(),
        ),
        IconButton(
          tooltip: context.tr('action_help'),
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () => context.read<StoresCubit>().onHelpMenuClick(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(StoresState data) {
    final state = data.state;
    if (state is LoadingState) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildContent(data);
  }

  Widget _buildContent(StoresState data) {
    bool showWarning = data.settings.sortByName != SortByText.no_sort;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  onTextChanged: (newValue) {
                    context.read<StoresCubit>().searchTextChanged(newValue);
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
                  onPressed: () => showFilterBottomSheet(data),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Visibility(
                child: emptyView,
                visible: data.items.isEmpty,
              ),
              Visibility(
                child: _buildListView(data),
                visible: data.items.isNotEmpty,
              ),
            ],
          ),
        ),
        SummaryLine([
          SummaryLine.item(context.tr("stores"), data.items.length.toString()),
        ]),
      ],
    );
  }

  Widget get emptyView => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              UIConstants.storeIconData,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr("no_stores"),
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

  Widget _buildListView(StoresState data) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (BuildContext context, index) {
        Store item = data.items[index];
        return StoreItemRow(
            item,
            context.read<StoresCubit>().getSelectedStoreId(),
            widget.isSelection, (item) {
          onPressed(item);
        }, (item) {
          onLongPressed(item);
        });
      },
      itemCount: data.items.length,
    );
  }

  void onPressed(Store item) async {
    if (widget.isSelection) {
      Navigator.of(context).pop(item);
    } else {
      context.read<StoresCubit>().onAddItem(item);
    }
  }

  void onLongPressed(Store item) {
    var items = [
      context.tr("delete"),
    ];
    showSelectOptionDialog(
      context,
      items: items,
      onItemSelected: (index) async {
        if (items[index] == context.tr("delete")) {
          showDeleteConfirmPopup(item);
        }
      },
    );
  }

  void showDeleteConfirmPopup(Store item) async {
    showCustomAlertDialog(
      context,
      message: sprintf(
        context.tr("message_confirm_delete"),
        [item.name],
      ),
      onPositivePressed: () async {
        hideDialog(context);
        await context.read<StoresCubit>().delete(item.id!);
      },
    );
  }

  void showFilterBottomSheet(StoresState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext mContext) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (mContext, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: FilterStoreWidget(
                onReset: () {
                  context.read<StoresCubit>().resetAllFilter();
                  Navigator.of(context).pop();
                },
                onApply: (setting) {
                  context.read<StoresCubit>().applyFilter(setting);
                  Navigator.of(context).pop();
                },
                settings: state.settings,
              ),
            );
          },
        );
      },
    );
  }
}
