import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/customers_setting.dart';
import 'package:good_manager/presentation/main.dart';
import 'package:good_manager/presentation/constants.dart';
import 'package:good_manager/presentation/pages/customers/widgets/customer_item_row.dart';
import 'package:good_manager/presentation/pages/customers/widgets/sort_customer_dialog.dart';
import 'package:good_manager/presentation/widgets/selected_store_view.dart';
import 'package:good_manager/presentation/markdown/md_provider_factory.dart';
import 'package:good_manager/presentation/pages/custom_navigation_drawer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_style.dart';
import '../base/base_state.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/bloc.dart';

class CustomersPage extends StatefulWidget {
  final bool isSelection;
  CustomersPage({Key? key, required this.isSelection});

  @override
  CustomersPageState createState() => CustomersPageState();
}

class CustomersPageState extends State<CustomersPage> {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchTextFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    //if (widget.isSelection){
    //  searchTextFocusNode.requestFocus();
    //}
    context.read<CustomersCubit>().initState(widget.isSelection);
  }
  @override
  Widget build(BuildContext context){
    return BlocConsumer<CustomersCubit, CustomersState>(
        listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
          if (state.state is OpenSortDialogListState){
            CustomersSetting? settings = await showDialog(
                context: context,
                builder: (_) => SortCustomerDialog(state.settings),
                barrierDismissible: true);
            if (settings != null){
              context.read<CustomersCubit>().setSettings(settings);
            }

          }
          else if (state.state is OpenSaveCustomerPageState){
            final currentState = state.state as OpenSaveCustomerPageState;
            final result = await Navigator.of(context).pushNamed(Pages.save_customer, arguments: {"item" : currentState.item});
            if (result != null){
              context.read<CustomersCubit>().loadItems();
            }
          }
          else if (state.state is OpenHelpPageState){
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": AppLocalizations.of(context)?.customers_title,
              "content": MDProviderFactory.get().getHelpText(HelpType.SUPPLIER_AND_CUSTOMER)
            });
          }

        },
        builder: (context, state) =>  Scaffold(
        drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 6, storeName: storage.getSelectedStoreName(),),
        appBar: _buildAppBar(state),
        body: _buildBody(state),
        floatingActionButton:  FloatingActionButton(
                onPressed: () => context.read<CustomersCubit>().onAddButtonClicked(),
                child: Icon(Icons.add),
              )
            ));
  }
  PreferredSize _buildAppBar(CustomersState data){
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight), child:  AppBar(
        title: new Text(widget.isSelection?AppLocalizations.of(context)!.customers_select_title:AppLocalizations.of(context)!.customers_title),
        actions: [_buildSearchMenu(data), _buildSortMenu(), _buildHelpMenu()]),
    );
  }



  Widget _buildBody(CustomersState data) {
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
  Widget _buildContent(CustomersState data){
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

  Widget _buildSearchBar(CustomersState data) => Card(
          child: ListTile(
            title: TextField(
              focusNode: searchTextFocusNode,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search_by_name, border: InputBorder.none),
              onChanged: context.read<CustomersCubit>().searchTextChanged,
              controller: searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                icon: Icon(UIConstants.cancelIconData),
                onPressed: (){
                  searchTextController.text = "";
                  context.read<CustomersCubit>().resetSearchText();
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
            Icon(UIConstants.supplierIconData, size: 60,color: AppColors.primaryColor),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.empty_customers,
                    textAlign: TextAlign.center,
                    style: AppStyle.getEmptyTextStyle()))
          ]);

  Widget _buildListView(CustomersState data) {
    return  ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Customer item = data.items[index];
            return CustomerItemRow(item, (item) {
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
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: data.items.length);
  }
  void onPressed(Customer item) async {
    if (widget.isSelection){
      Navigator.of(context).pop(item);
    }else{
      context.read<CustomersCubit>().onAddItem(item);
    }
  }
  void onLongPressed(Customer item){
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
  void showDeleteConfirmPopup(Customer item) async{
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
                  await context.read<CustomersCubit>().delete(item.id!);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.action_ok),
              )
            ],
          );
        });
  }

  Widget _buildSearchMenu(CustomersState state){
    return InkWell(
      child: Padding(padding: EdgeInsets.all(8.0), child: Icon(
        UIConstants.searchMenuIconData,
        size: 26,
        color: state.showSearchBar
            ? UIConstants.highlightMenuColor
            : UIConstants.normalMenuColor,
      ),),
      onTap: (){
        searchTextController.text = "";
        if (!state.showSearchBar){
          searchTextFocusNode.requestFocus();
        }
        context.read<CustomersCubit>().onShowSearchBarMenuClicked();
      },
    );
  }

  Widget _buildSortMenu(){
    return InkWell(child: Padding(padding: EdgeInsets.all(8.0), child: Icon(
      UIConstants.sortMenuIconData,
      size: 26,
      color: context.read<CustomersCubit>().hasSortOptions()
          ? UIConstants.highlightMenuColor
          : UIConstants.normalMenuColor,
    )),onTap: context.read<CustomersCubit>().onSortMenuClicked);
  }
  Widget _buildHelpMenu(){
    return InkWell(
      child: Padding(padding: EdgeInsets.all(8.0), child: Icon(
        UIConstants.helpMenuIconData,
        size: 26,
      )),
      onTap: context.read<CustomersCubit>().onHelpMenuClick,
    );
  }
  Future<void> _launchUrl(String value) async {
    Uri url = Uri.parse(value);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
