import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/base/base_page.dart';
import 'package:good_manager/presentation/pages/custom_navigation_drawer.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:good_manager/app/widgets/selected_store_view.dart';
import '../base/base_state.dart';
import '../base/sort_item_dialog.dart';
import '../help_content.dart';
import '../pages.dart';
import 'bloc/bloc.dart';

enum SupplierItemMenu { sendEmail, sendSMS, phoneCall }

class SuppliersPage extends StatefulWidget {
  final bool isSelection;

  SuppliersPage({Key? key, required this.isSelection});

  @override
  SuppliersPageState createState() => SuppliersPageState();
}

class SuppliersPageState extends State<SuppliersPage> {
  @override
  void initState() {
    super.initState();
    context.read<SuppliersCubit>().initState(widget.isSelection);
  }
  @override
  Widget build(BuildContext context){
    return BlocConsumer<SuppliersCubit, SuppliersState>(
      listenWhen: (p1, p2) => p1.state != p2.state,
        listener: (context, state) async{
          if (state.state is OpenSortDialogListState){
            /*showDialog(
                context: context,
                builder: (_) => SortItemDialog(state.settings, () {
                  //context.read<SuppliersCubit>().setSettings(_se)
                  //_presenter.setSettings(_settings);
                }),
                barrierDismissible: true);*/
          }
          if (state.state is OpenSaveItemState){
            final result = await Navigator.of(context).pushNamed(Pages.save_supplier, arguments: {"item": Supplier()});
            /*if (result != null) {
              allItems.add(result);
              refreshItems();
            }*/
          }
          if (state.state is OpenHelpPageState){
            Navigator.of(context).pushNamed(Pages.help, arguments: {
              "title": "abc",
              "content": HelpUtils.getMarkdownData("vi", HelpType.SUPPLIER_AND_CUSTOMER)
            });
          }
        },
        builder: (context, state) =>  Scaffold(
        //key: globalKey,
        drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 5),
        appBar: _buildAppBar(state),
        body: _buildBody(state),
        floatingActionButton:  FloatingActionButton(
                onPressed: () => context.read<SuppliersCubit>().onAddItem(),
                child: Icon(Icons.add),
              )
            ));
  }
  PreferredSize _buildAppBar(SuppliersState data){
    return PreferredSize(
      preferredSize: Size.fromHeight(70), child:  AppBar(
        title: new Text(widget.isSelection?AppLocalizations.of(context)!.suppliers_select_title:AppLocalizations.of(context)!.suppliers_title),
        actions: [_buildSearchMenu(data), sortMenu, helpMenu]),
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

  Widget _buildSearchBar(SuppliersState data) => Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "by name", border: InputBorder.none),
              onChanged: context.read<SuppliersCubit>().searchTextChanged,

              //controller: controller.searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                icon: Icon(UIConstants.cancelIconData),
                onPressed: context.read<SuppliersCubit>().resetSearchText,
              ),
              visible: data.textSearch.isNotEmpty,
            ),
          ),
        );


  Widget get emptyView => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: Image.asset(
                  UIConstants.supplierIconPath,
                )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.empty_suppliers,
                    textAlign: TextAlign.center))
          ]);

  Widget _buildListView(SuppliersState data) {
    return  ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Supplier item = data.items[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text('${item.name[0].toUpperCase()}'),
              ),
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.description.isNotEmpty
                      ? Text(item.description)
                      : Container(),
                  //item.numberDocument > 0
                  //    ? Text(item.numberDocument.toString() + "GD")
                   //   : Container()
                ],
              ),
              onTap: () => context.read<SuppliersCubit>().onItemPressed(item),
              onLongPress: () => context.read<SuppliersCubit>().onItemLongPressed(item),
              trailing: PopupMenuButton<SupplierItemMenu>(
                onSelected: (SupplierItemMenu result) {
                  switch (result) {
                    case SupplierItemMenu.sendEmail:
                      _launchUrl("mailto:${item.email}");
                      break;
                    case SupplierItemMenu.sendSMS:
                      _launchUrl("sms:${item.phone}");
                      break;
                    case SupplierItemMenu.phoneCall:
                      _launchUrl("tel:${item.phone}");
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext a) =>
                <PopupMenuEntry<SupplierItemMenu>>[
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.sendEmail,
                      child:
                      Text(AppLocalizations.of(context)!.action_send_email)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.sendSMS,
                      child:
                      Text(AppLocalizations.of(context)!.action_send_sms)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.phoneCall,
                      child:
                          Text(AppLocalizations.of(context)!.action_phone_call)),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: data.items.length);
  }

  Widget _buildSearchMenu(SuppliersState data) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: data.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: context.read<SuppliersCubit>().onShowSearchBarMenuClicked,
          ),
        );


  Widget get sortMenu => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: context.read<SuppliersCubit>().hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: context.read<SuppliersCubit>().onSortMenuClicked,
          ),
        );


  Widget get helpMenu => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: context.read<SuppliersCubit>().onHelpMenuClick,
          ),
        );

  void onSearchClicked(){

  }
  Future<void> _launchUrl(String value) async {
    Uri url = Uri.parse(value);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
