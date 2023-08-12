import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_cubit.dart';
import 'package:good_manager/presentation/pages/stores/components/sort_store_dialog.dart';
import 'package:sprintf/sprintf.dart';

import '../../../domain/entities/stores_setting.dart';
import '../../app_style.dart';
import '../../main.dart';
import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';
import '../help_content.dart';
import '../pages.dart';
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
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    //if (widget.isSelection){
    //  searchTextFocusNode.requestFocus();
    //}
    context.read<StoresCubit>().initState(widget.isSelection);
  }
  @override
  Widget build(BuildContext context){
    return BlocConsumer<StoresCubit, StoresState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
          if (state.state is OpenSortDialogListState){
            StoresSetting? settings = await showDialog(
                context: context,
                builder: (_) => SortStoreDialog(state.settings),
                barrierDismissible: true);
            if (settings != null){
              context.read<StoresCubit>().setSettings(settings);
            }
          }
          else if (state.state is OpenSaveStorePageState){
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
          }
        },
        builder: (context, state) =>  Scaffold(
            drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 7, storeName: storage.getSelectedStoreName()),
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
        actions: [_buildSearchMenu(data), sortMenu, helpMenu]),
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
      Visibility(child: _buildSearchBar(data), visible: data.showSearchBar),
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

  Widget _buildSearchBar(StoresState data) => Card(
    child: ListTile(
      title: TextField(
        focusNode: searchTextFocusNode,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.search_by_name, border: InputBorder.none),
        onChanged: context.read<StoresCubit>().searchTextChanged,
        controller: searchTextController,
      ),
      trailing: Visibility(
        child: IconButton(
            icon: Icon(UIConstants.cancelIconData),
            onPressed: (){
              searchTextController.text = "";
              context.read<StoresCubit>().resetSearchText();
            }
        ),
        visible: data.textSearch.isNotEmpty,
      ),
    ),
  );


  Widget get emptyView => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(UIConstants.storeIconData, size: 60,color: AppColors.primaryColor),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(AppLocalizations.of(context)!.empty_stores,
                textAlign: TextAlign.center,
                style: AppStyle.getEmptyTextStyle()))
      ]);

  Widget _buildListView(StoresState data) {
    return  ListView.separated(
        itemBuilder: (BuildContext context, index) {
          Store item = data.items[index];
          return StoreItemRow(item, (item) {
            onPressed(item);
          }, (item) {
            onLongPressed(item);
          });
        },
        separatorBuilder: (context, index) {
          return Divider();
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


  Widget _buildSearchMenu(StoresState state) => Padding(
    padding: EdgeInsets.only(right: 20.0),
    child: GestureDetector(
      child: Icon(
        UIConstants.searchMenuIconData,
        size: 26,
        color: state.showSearchBar
            ? UIConstants.highlightMenuColor
            : UIConstants.normalMenuColor,
      ),
      onTap: (){
        searchTextController.text = "";
        if (!state.showSearchBar){
          searchTextFocusNode.requestFocus();
        }
        context.read<StoresCubit>().onShowSearchBarMenuClicked();
      } ,
    ),
  );


  Widget get sortMenu => Padding(
    padding: EdgeInsets.only(right: 20.0),
    child: GestureDetector(
      child: Icon(
        UIConstants.sortMenuIconData,
        size: 26,
        color: context.read<StoresCubit>().hasSortOptions()
            ? UIConstants.highlightMenuColor
            : UIConstants.normalMenuColor,
      ),
      onTap: context.read<StoresCubit>().onSortMenuClicked,
    ),
  );


  Widget get helpMenu => Padding(
    padding: EdgeInsets.only(right: 20.0),
    child: GestureDetector(
      child: Icon(
        UIConstants.helpMenuIconData,
        size: 26,
      ),
      onTap: context.read<StoresCubit>().onHelpMenuClick,
    ),
  );
}
