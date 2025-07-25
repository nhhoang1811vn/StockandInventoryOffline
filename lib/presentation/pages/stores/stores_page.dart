import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart';
import 'package:good_manager/presentation/widgets/snackbar_widgets.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:sprintf/sprintf.dart';

import '../../../domain/entities/sort_by_text.dart';
import '../../../domain/free_limits.dart';
import '../../widgets/search_bar_widget.dart';
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
  Widget build(BuildContext context){
    return BlocConsumer<StoresCubit, StoresState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
         if (state.state is OpenSaveStorePageState){
            final currentState = state.state as OpenSaveStorePageState;
            final result = await Navigator.of(context).pushNamed(Pages.save_store, arguments: {"item" : currentState.item});
            if (result != null){
              context.read<StoresCubit>().loadItems();
            }
          }
          else if (state.state is OpenHelpPageState){
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.stores_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.STORE)
            });
          }else if(state.state is DeleteItemError){
            ScaffoldMessenger.of(context).showSnackBar(snackBarWhenFailureWithText(AppLocalizations.of(context)!.delete_store_error));
          }else if (state.state is OpenBuySubscriptionDialogState){
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.notification_dialog_title),
                content: Text(sprintf(AppLocalizations.of(context)!.buy_subscription_to_add_more_entity, [FreeLimits.storeLimit])),
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
        builder: (context, state) =>  Scaffold(
            
            //drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 7, storeName: storage.getSelectedStoreName()),
            appBar: _buildAppBar(state),
            body: _buildBody(state),
            floatingActionButton:  FloatingActionButton(
              onPressed: () => context.read<StoresCubit>().onAddButtonClicked(),
              child: Icon(Icons.add),
            )
        ));
  }
  PreferredSize _buildAppBar(StoresState data){
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight), child:  AppBar(
        title: new Text(widget.isSelection?AppLocalizations.of(context)!.stores_select_title:AppLocalizations.of(context)!.stores_title),
        actions: [_buildSearchMenu(data), _buildFilterMenu(data), _buildHelpMenu()]),
    );
  }



  Widget _buildBody(StoresState data) {
    final state = data.state;
    if (state is LoadingState) {
      return _buildLoading();
    }
    return _buildContent(data);
  }
  Widget _buildLoading(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildContent(StoresState data){
    List<Widget> children = [
      Visibility(
        visible: data.showSearchBar,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SearchBarWidget(
            onTextChanged: (newValue) {
              context.read<StoresCubit>().searchTextChanged(newValue);
            },
            focusNode: searchTextFocusNode,
          ),
        ),
      ),
      //Visibility(child: _buildSearchBar(data), visible: data.showSearchBar),
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




  Widget get emptyView => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(UIConstants.storeIconData, size: 60,color: Theme.of(context).colorScheme.primary),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(AppLocalizations.of(context)!.empty_stores,
                textAlign: TextAlign.center,
                ))
      ]);

  Widget _buildListView(StoresState data) {
    return  ListView.builder(
        itemBuilder: (BuildContext context, index) {
          Store item = data.items[index];
          return StoreItemRow(item,
              context.read<StoresCubit>().getSelectedStoreId(),
              widget.isSelection,

                  (item) {
            onPressed(item);
          }, (item) {
            onLongPressed(item);
          });
        },
        itemCount: data.items.length);
  }
  void onPressed(Store item) async {
    if (widget.isSelection){
      Navigator.of(context).pop(item);
    }else{
      context.read<StoresCubit>().onAddItem(item);
    }
  }
  void onLongPressed(Store item){
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
            ],
          );
        },
        barrierDismissible: true);
  }
  void showDeleteConfirmPopup(Store item) async{
    showDialog(
        context: context,
        builder: (BuildContext mContext) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(context)!.message_confirm_delete,
                [item.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.action_cancel)),
              TextButton(
                onPressed: () async{
                  await context.read<StoresCubit>().delete(item.id!);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }
  Widget _buildSearchMenu(StoresState state) {
    return IconButton(onPressed: () {
      if (!state.showSearchBar) {
        searchTextFocusNode.requestFocus();
      }
      context.read<StoresCubit>().onShowSearchBarMenuClicked();
    }, icon: Icon(Icons.search, color: state.showSearchBar ? Theme.of(context).colorScheme.primary: Theme.of(context).iconTheme.color));
  }
  Widget _buildFilterMenu(StoresState state) {
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
  void showFilterBottomSheet(StoresState state) {
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
                    child: FilterStoreWidget(
                      onResetAllPressed: () {
                        context.read<StoresCubit>().resetAllFilter();
                        Navigator.of(context).pop();
                      },
                      onApplyPressed: (setting) {
                        context.read<StoresCubit>().applyFilter(setting);
                        Navigator.of(context).pop();
                      },
                      setting: state.settings,
                    ));
              });
        });
  }
  Widget _buildHelpMenu(){
    return IconButton(onPressed: (){
      context.read<StoresCubit>().onHelpMenuClick();
    }, icon: Icon(Icons.help));
  }
}
