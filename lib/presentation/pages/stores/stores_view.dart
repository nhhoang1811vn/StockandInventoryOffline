import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/presentation/pages/base/base_page.dart';

import '../base/base_state.dart';
import '../custom_navigation_drawer.dart';
import 'bloc/bloc.dart';

class StoresPage extends StatefulWidget {
  final bool isSelection;

  StoresPage({
    Key? key,
    required this.isSelection,
  });

  @override
  _StoresPageState createState() => _StoresPageState();
}

class _StoresPageState extends BasePageState<StoresPage, StoresCubit, StoresData> {
  @override
  Widget buildPage(BuildContext context, StoresData data) {
    return Scaffold(
        //key: globalKey,
        appBar: _buildAppBar(data),
        drawer: widget.isSelection?null:CustomNavigationDrawer(selectedIndex: 7,),
        body: _buildBody(data),
        floatingActionButton:  FloatingActionButton(
          onPressed: () => {},
                child: Icon(Icons.add),
              )
            );
  }

  PreferredSize _buildAppBar(StoresData data){
    return PreferredSize(
      preferredSize: Size.fromHeight(70), child:  AppBar(
        title: Text(widget.isSelection?AppLocalizations.of(context)!.stores_select_title:AppLocalizations.of(context)!.stores_title),
        actions: [_buildSearchMenu(data), sortMenu, helpMenu]),
    );
  }

  Widget _buildBody(StoresData data) {
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

  Widget _buildContent(StoresData data) {
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

  Widget _buildSearchBar(StoresData data) =>
      Card(
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
                  UIConstants.storeIconPath,
                )),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(AppLocalizations.of(context)!.empty_stores,
                    textAlign: TextAlign.center))
          ]);

  Widget _buildListView(StoresData data) => ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                title: Text(data.items[index].name),
                subtitle: Text(data.items[index].description),
                onTap: () => cubit.onItemPressed(data.items[index]),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: data.items.length);

  Widget _buildSearchMenu(StoresData data) => Padding(
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

  Widget get sortMenu => Padding(
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
