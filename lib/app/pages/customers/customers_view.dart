import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base/base_page.dart';
import 'package:good_manager/app/pages/custom_navigation_drawer.dart';
import 'package:good_manager/app/pages/customers/bloc/customers_data.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/selected_store_view.dart';
import '../base/base_state.dart';
import 'bloc/customers_cubit.dart';

enum CustomerItemMenu { sendEmail, sendSMS, phoneCall }

class CustomersPage extends StatefulWidget {
  final bool isSelection;

  CustomersPage({Key? key, required this.isSelection});

  @override
  CustomersPageState createState() => CustomersPageState();
}

class CustomersPageState extends BasePageState<CustomersPage, CustomersCubit, CustomersData> {

  @override
  Widget buildPage(BuildContext context, CustomersData data) {
    return Scaffold(
        //key: globalKey,
        drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 6,),
        appBar: _buildAppBar(data),
        body: _buildBody(data),
        floatingActionButton:  FloatingActionButton(
          onPressed: () => {},
                child: Icon(Icons.add),
              ));
  }
  PreferredSize _buildAppBar(CustomersData data){
    return PreferredSize(
      preferredSize: Size.fromHeight(70), child:  AppBar(
        title: Text(widget.isSelection?AppLocalizations.of(context)!.customers_select_title:AppLocalizations.of(context)!.customers_title),
        actions: [_buildSearchMenu(data), sortMenu, helpMenu]),
    );
  }

  Widget _buildBody(CustomersData data) {
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

  Widget _buildContent(CustomersData data) {
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

  Widget _buildSearchBar(CustomersData data) => Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "by name", border: InputBorder.none),
              onChanged: cubit.searchTextChanged,
              //controller: controller.searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                icon: Icon(UIConstants.cancelIconData),
                onPressed: cubit.resetSearchText,
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
                  UIConstants.customerIconPath,
                )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.empty_customers,
                    textAlign: TextAlign.center))
          ]);

  Widget _buildListView(CustomersData data) =>
    ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Customer item = data.items[index];
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
                  item.numberDocument > 0
                      ? Text(item.numberDocument.toString() + "GD")
                      : Container()
                ],
              ),
              onTap: () => cubit.onItemPressed(item),
              onLongPress: () => cubit.onItemLongPressed(item),
              trailing: PopupMenuButton<CustomerItemMenu>(
                onSelected: (CustomerItemMenu result) {
                  switch (result) {
                    case CustomerItemMenu.sendEmail:
                      _launchUrl("mailto:${item.email}");
                      break;
                    case CustomerItemMenu.sendSMS:
                      _launchUrl("sms:${item.phone}");
                      break;
                    case CustomerItemMenu.phoneCall:
                      _launchUrl("tel:${item.phone}");
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext a) =>
                    <PopupMenuEntry<CustomerItemMenu>>[
                  PopupMenuItem<CustomerItemMenu>(
                      value: CustomerItemMenu.sendEmail,
                      child:
                          Text(AppLocalizations.of(context)!.action_send_email)),
                  PopupMenuItem<CustomerItemMenu>(
                      value: CustomerItemMenu.sendSMS,
                      child:
                          Text(AppLocalizations.of(context)!.action_send_sms)),
                  PopupMenuItem<CustomerItemMenu>(
                      value: CustomerItemMenu.phoneCall,
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

  Future<void> _launchUrl(String value) async {
    Uri url = Uri.parse(value);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSearchMenu(CustomersData data) => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: data.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: cubit.onShowSearchBarMenuClicked,
          ),
        );


  Widget get sortMenu =>  Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: cubit.hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: cubit.onSortMenuClicked,
          ),
        );


  Widget get helpMenu => Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: cubit.onHelpMenuClick,
          ),
        );
}
