import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_supplier_repository.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

enum SupplierItemMenu { sendEmail, sendSMS, phoneCall }

class SuppliersPage extends View {
  final bool isSelection;

  SuppliersPage({Key key, @required this.isSelection});

  @override
  SuppliersPageView createState() => SuppliersPageView(isSelection);
}

class SuppliersPageView extends ViewState<SuppliersPage, SuppliersController> {
  SuppliersPageView(isSelection)
      : super(SuppliersController(DataSupplierRepository(), isSelection));

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        appBar: appBar,
        body: ControlledWidgetBuilder<SuppliersController>(
            builder: (context, controller) {
          return ModalProgressHUD(
              child: getBody(), inAsyncCall: controller.isLoading, opacity: 0);
        }),
        floatingActionButton: ControlledWidgetBuilder<SuppliersController>(
            builder: (context, controller) {
          return FloatingActionButton(
            onPressed: () => controller.onAddItem(),
            child: Icon(Icons.add),
          );
        }));
  }

  Widget get appBar => AppBar(
      title: new Text(widget.isSelection?AppLocalizations.of(context).suppliers_select_title:AppLocalizations.of(context).suppliers_title),
      actions: [searchMenu, sortMenu, helpMenu]);

  Widget getBody() {
    List<Widget> children = [
      ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
        return Visibility(child: searchBar, visible: controller.showSearchBar);
      }),
      ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
        return Expanded(
            child: Stack(children: [
          Visibility(
            child: emptyView,
            visible: controller.items.isEmpty && !controller.isLoading,
          ),
          Visibility(
            child: listView,
            visible: controller.items.isNotEmpty,
          )
        ]));
      })
    ];
    return Column(children: children);
  }

  Widget get searchBar => ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
        return Card(
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                  hintText: "by name", border: InputBorder.none),
              onChanged: controller.onSearchChanged,
              controller: controller.searchTextController,
            ),
            trailing: Visibility(
              child: IconButton(
                icon: Icon(UIConstants.cancelIconData),
                onPressed: controller.resetSearchText,
              ),
              visible: controller.textSearch.isNotEmpty,
            ),
          ),
        );
      });

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
                child: Text(AppLocalizations.of(context).empty_suppliers,
                    textAlign: TextAlign.center))
          ]);

  Widget get listView {
    return ControlledWidgetBuilder<SuppliersController>(
        builder: (context, controller) {
      return ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Supplier item = controller.items[index];
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
              onTap: () => controller.onItemPressed(item),
              onLongPress: () => controller.onItemLongPressed(item),
              trailing: PopupMenuButton<SupplierItemMenu>(
                onSelected: (SupplierItemMenu result) {
                  switch (result) {
                    case SupplierItemMenu.sendEmail:
                      _launchURL("mailto:${item.email}");
                      break;
                    case SupplierItemMenu.sendSMS:
                      _launchURL("sms:${item.phone}");
                      break;
                    case SupplierItemMenu.phoneCall:
                      _launchURL("tel:${item.phone}");
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext a) =>
                <PopupMenuEntry<SupplierItemMenu>>[
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.sendEmail,
                      child:
                      Text(AppLocalizations.of(context).action_send_email)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.sendSMS,
                      child:
                      Text(AppLocalizations.of(context).action_send_sms)),
                  PopupMenuItem<SupplierItemMenu>(
                      value: SupplierItemMenu.phoneCall,
                      child:
                          Text(AppLocalizations.of(context).action_phone_call)),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: controller.items.length);
    });
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  Widget get searchMenu => ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.searchMenuIconData,
              size: 26,
              color: controller.showSearchBar
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.toggleSearchBar,
          ),
        );
      });

  Widget get sortMenu => ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.sortMenuIconData,
              size: 26,
              color: controller.hasSortOptions()
                  ? UIConstants.highlightMenuColor
                  : UIConstants.normalMenuColor,
            ),
            onTap: controller.onShowSortDialog,
          ),
        );
      });

  Widget get helpMenu => ControlledWidgetBuilder<SuppliersController>(
          builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(
              UIConstants.helpMenuIconData,
              size: 26,
            ),
            onTap: controller.onOpenHelpPage,
          ),
        );
      });
}
