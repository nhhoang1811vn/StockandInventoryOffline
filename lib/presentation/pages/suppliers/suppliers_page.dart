import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/suppliers/components/supplier_item_row.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/sort_by_text.dart';
import '../../../domain/free_limits.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/views.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/bloc.dart';
import 'components/filter_supplier_widget.dart';
class SuppliersPage extends StatefulWidget {
  final bool isSelection;

  SuppliersPage({Key? key, required this.isSelection});

  @override
  SuppliersPageState createState() => SuppliersPageState();
}

class SuppliersPageState extends State<SuppliersPage> {
  final FocusNode searchTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SuppliersCubit>().initState(widget.isSelection);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuppliersCubit, SuppliersState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async {
          if (state.state is OpenSaveSupplierPageState) {
            final currentState = state.state as OpenSaveSupplierPageState;
            final result =
                await Navigator.of(context).pushNamed(Pages.save_supplier, arguments: {"item": currentState.item});
            if (result != null) {
              context.read<SuppliersCubit>().loadItems();
            }
          } else if (state.state is OpenHelpPageState) {
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.suppliers_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.SUPPLIER_AND_CUSTOMER)
            });
          } else if (state.state is OpenBuySubscriptionDialogState) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.notification_dialog_title),
                    content: Text(sprintf(
                        AppLocalizations.of(context)!.buy_subscription_to_add_more_entity, [FreeLimits.supplierLimit])),
                    actions: [
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.action_no),
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                        },
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.action_yes),
                        onPressed: () async{
                          Navigator.of(context).pop();
                          await RevenueCatUI.presentPaywall();
                          //Navigator.of(context).pushNamed(Pages.subscriptions);
                        },
                      ),
                    ],
                  );
                });
          }
        },
        builder: (context, state) => Scaffold(

            //drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 5, storeName: storage.getSelectedStoreName(),),
            appBar: _buildAppBar(state),
            body: _buildBody(state),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<SuppliersCubit>().onAddButtonClicked(),
              child: Icon(Icons.add),
            )));
  }

  PreferredSize _buildAppBar(SuppliersState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
          title: new Text(widget.isSelection
              ? AppLocalizations.of(context)!.suppliers_select_title
              : AppLocalizations.of(context)!.suppliers_title),
          actions: [_buildSearchMenu(state), _buildFilterMenu(state), _buildHelpMenu()]),
    );
  }

  Widget _buildBody(SuppliersState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(SuppliersState data) {
    List<Widget> children = [
      SelectedStoreView(),
      Visibility(
        visible: data.showSearchBar,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<SuppliersCubit>().searchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
          ),
        ),
      ),

      // Visibility(child: _buildSearchBar(data), visible: data.showSearchBar),
      Expanded(
          child: Stack(children: [
        Visibility(
          child: emptyView,
          visible: data.items.isEmpty,
        ),
        Visibility(
          child: _buildListView(data),
          visible: data.items.isNotEmpty,
        )
      ]))
    ];
    return Column(children: children);
  }

  Widget get emptyView =>
      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(UIConstants.supplierIconData, size: 60, color: Theme.of(context).colorScheme.primary),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(AppLocalizations.of(context)!.empty_suppliers, textAlign: TextAlign.center))
      ]);

  Widget _buildListView(SuppliersState data) {
    return ListView.separated(
        separatorBuilder: (context, index) => buildDivider(),
        itemBuilder: (BuildContext context, index) {
          Supplier item = data.items[index];
          return SupplierItemRow(item, (item) {
            onPressed(item);
          }, (item) {
            onLongPressed(item);
          }, (item) {
            _launchUrl("mailto:${item.email}");
          }, (item) {
            _launchUrl("sms:${item.phone}");
          }, (item) {
            _launchUrl("tel:${item.phone}");
          });
        },
        //separatorBuilder: (context, index) {
        //  return Divider(color: Colors.grey[500]);
        //},
        itemCount: data.items.length);
  }

  void onPressed(Supplier item) async {
    if (widget.isSelection) {
      Navigator.of(context).pop(item);
    } else {
      context.read<SuppliersCubit>().onAddItem(item);
    }
  }

  void onLongPressed(Supplier item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteConfirmPopup(item);
                },
                child: Text(AppLocalizations.of(context)!.action_delete),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () async{
                  Navigator.pop(context);
                  await Navigator.of(context).pushNamed(Pages.documents_history, arguments: {
                  'supplierId': item.id,
                  });
                },
                child: Text(AppLocalizations.of(context)!.action_view_document),
              ),


            ],
          );
        },
        barrierDismissible: true);
  }

  void showDeleteConfirmPopup(Supplier item) async {
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(AppLocalizations.of(context)!.message_confirm_delete, [item.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () async {
                  await context.read<SuppliersCubit>().delete(item.id!);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }

  Widget _buildSearchMenu(SuppliersState state) {
    return IconButton(
        onPressed: () {
          if (!state.showSearchBar) {
            searchTextFocusNode.requestFocus();
          }
          context.read<SuppliersCubit>().onShowSearchBarMenuClicked();
        },
        icon: Icon(Icons.search,
            color: state.showSearchBar ? Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color));
  }

  Widget _buildFilterMenu(SuppliersState state) {
    bool showWarning = state.settings.sortByName != SortByText.no_sort;
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
  void showFilterBottomSheet(SuppliersState state) {
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
                    child: FilterSupplierWidget(
                      onResetAllPressed: () {
                        context.read<SuppliersCubit>().resetAllFilter();
                        Navigator.of(context).pop();
                      },
                      onApplyPressed: (setting) {
                        context.read<SuppliersCubit>().applyFilter(setting);
                        Navigator.of(context).pop();
                      },
                      setting: state.settings,
                    ));
              });
        });
  }

  Widget _buildHelpMenu() {
    return IconButton(
        onPressed: () {
          context.read<SuppliersCubit>().onHelpMenuClick();
        },
        icon: Icon(Icons.help));
  }

  Future<void> _launchUrl(String value) async {
    Uri url = Uri.parse(value);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
