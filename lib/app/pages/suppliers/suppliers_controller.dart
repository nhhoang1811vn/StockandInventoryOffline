import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base_list_controller.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/app/pages/suppliers/suppliers_presenter.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';

import '../help_content.dart';

class SuppliersController
    extends BaseListController<Supplier, SupplierSettings, SuppliersPresenter> {
  bool _isSelection;

  SuppliersController(repository, this._isSelection)
      : super(SuppliersPresenter(repository));

  @override
  void onItemPressed(Supplier item) {
    if (_isSelection) {
      Navigator.of(getContext()).pop(item);
    } else {
      super.onItemPressed(item);
    }
  }

  void onItemLongPressed(Supplier supplier) async {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  if (supplier.numberDocument > 0) {
                    showCanNotDeleteDialog();
                  } else {
                    showDeleteConfirmDialog(supplier.id);
                  }
                },
                child: Text(AppLocalizations.of(getContext()).action_delete),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  //TODO
                },
                child: Text(
                    AppLocalizations.of(getContext()).action_view_transaction),
              )
            ],
          );
        },
        barrierDismissible: true);
  }

  void showCanNotDeleteDialog() {
    showDialog(
        context: getContext(),
        builder: (BuildContext builder) => AlertDialog(
              title: Text(
                  AppLocalizations.of(getContext()).notification_dialog_title),
              content: Text(AppLocalizations.of(getContext())
                  .message_delete_supplier_error_having_document),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: const Text('OK'),
                )
              ],
            ));
  }

  void showDeleteConfirmDialog(int id) {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(AppLocalizations.of(getContext())
                .message_confirm_delete_supplier),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  presenter.delete(id);
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });
  }

  void onOpenHelpPage() {
    Navigator.of(getContext()).pushNamed(Pages.help, arguments: {
      "title": "Nhà cung cấp",
      "content": HelpUtils.getMarkdownDataSupplierCustomer()
    });
  }

  @override
  bool filterItem(Supplier item, String textSearch) {
    return item.name.contains(textSearch);
  }

  @override
  Supplier getEmptyItem() {
    return Supplier();
  }

  @override
  String getSaveItemRouteName() {
    return Pages.save_supplier;
  }
}
