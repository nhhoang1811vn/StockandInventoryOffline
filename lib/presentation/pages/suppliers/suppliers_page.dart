import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/suppliers_setting.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/suppliers/widgets/supplier_item_row.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/bloc.dart';
import 'widgets/sort_supplier_dialog.dart';

class SuppliersPage extends StatefulWidget {
  final bool isSelection;
  SuppliersPage({Key? key, required this.isSelection});

  @override
  SuppliersPageState createState() => SuppliersPageState();
}

class SuppliersPageState extends State<SuppliersPage> {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    //if (widget.isSelection){
    //  searchTextFocusNode.requestFocus();
    //}
    context.read<SuppliersCubit>().initState(widget.isSelection);
  }
  
  @override
  Widget build(BuildContext context){
    return BlocConsumer<SuppliersCubit, SuppliersState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
          if (state.state is OpenSortDialogListState){
            SuppliersSetting? settings = await showDialog(
                context: context,
                builder: (_) => SortSupplierDialog(state.settings),
                barrierDismissible: true);
            if (settings != null){
              context.read<SuppliersCubit>().setSettings(settings);
            }

          }
          else if (state.state is OpenSaveSupplierPageState){
            final currentState = state.state as OpenSaveSupplierPageState;
            final result = await Navigator.of(context).pushNamed(Pages.save_supplier, arguments: {"item" : currentState.item});
            if (result != null){
              context.read<SuppliersCubit>().loadItems();
            }
          }
          else if (state.state is OpenHelpPageState){
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.suppliers_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.SUPPLIER_AND_CUSTOMER)
            });
          }

        },

        builder: (context, state) =>  Scaffold(
        
        //drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 5, storeName: storage.getSelectedStoreName(),),
        appBar: _buildAppBar(state),
        body: _buildBody(state),
        floatingActionButton:  FloatingActionButton(
                onPressed: () => context.read<SuppliersCubit>().onAddButtonClicked(),
                child: Icon(Icons.add),
              )
            ));
  }
  PreferredSize _buildAppBar(SuppliersState data){
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight), child:  AppBar(
        title: new Text(widget.isSelection?AppLocalizations.of(context)!.suppliers_select_title:AppLocalizations.of(context)!.suppliers_title),
        actions: [_buildSearchMenu(data), _buildSortMenu(), _buildHelpMenu()]),
    );
  }



  Widget _buildBody(SuppliersState data) {
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
  Widget _buildContent(SuppliersState data){
    List<Widget> children = [
      SelectedStoreView(),
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

  Widget _buildSearchBar(SuppliersState data) => Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
    child: Container(
      decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
      child: ListTile(
        title: TextField(
          focusNode: searchTextFocusNode,
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.hint_search_by, border: InputBorder.none),
          onChanged: context.read<SuppliersCubit>().searchTextChanged,
          controller: searchTextController,
        ),
        trailing: Visibility(
          child: IconButton(
            icon: Icon(UIConstants.cancelIconData),
            onPressed: (){
              searchTextController.text = "";
              context.read<SuppliersCubit>().resetSearchText();
            }
          ),
          visible: data.textSearch.isNotEmpty,
        ),
      ),
    ),
  );


  Widget get emptyView => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(UIConstants.supplierIconData, size: 60,color: Theme.of(context).colorScheme.primary),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.empty_suppliers,
                    textAlign: TextAlign.center))
          ]);

  Widget _buildListView(SuppliersState data) {
    return  ListView.builder(
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
    if (widget.isSelection){
      Navigator.of(context).pop(item);
    }else{
      context.read<SuppliersCubit>().onAddItem(item);
    }
  }
  void onLongPressed(Supplier item){
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
  void showDeleteConfirmPopup(Supplier item) async{
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
    return IconButton(onPressed: () {
      searchTextController.text = "";
      if (!state.showSearchBar) {
        searchTextFocusNode.requestFocus();
      }
      context.read<SuppliersCubit>().onShowSearchBarMenuClicked();
    }, icon: Icon(Icons.search, color: state.showSearchBar ?Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color));
  }
  Widget _buildSortMenu() {
    return IconButton(onPressed: (){
      context.read<SuppliersCubit>().onSortMenuClicked();
    }, icon: Icon(Icons.sort, color: context.read<SuppliersCubit>().hasSortOptions() ?Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color ));
  }
  Widget _buildHelpMenu(){
    return IconButton(onPressed: (){
      context.read<SuppliersCubit>().onHelpMenuClick();
    }, icon: Icon(Icons.help));
  }
  Future<void> _launchUrl(String value) async {
    Uri url = Uri.parse(value);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
