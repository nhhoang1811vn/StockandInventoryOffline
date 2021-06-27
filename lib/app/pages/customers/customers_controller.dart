import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/base_list_controller.dart';
import 'package:good_manager/app/pages/pages.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/customers_settings.dart';

import 'customers_presenter.dart';

class CustomersController extends BaseListController<Customer,
    CustomersSettings, CustomersPresenter> {
  bool _isSelection;

  CustomersController(repository, this._isSelection)
      : super(CustomersPresenter(repository));

  @override
  Customer getEmptyItem() {
    return Customer();
  }

  @override
  String getSaveItemRouteName() {
    return Pages.save_customer;
  }

  @override
  void onItemPressed(Customer item) {
    if (_isSelection) {
      Navigator.of(getContext()).pop(item);
    } else {
      super.onItemPressed(item);
    }
  }

  void onItemLongPressed(Customer item) async {
    showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pop(getContext());
                  if (item.numberDocument > 0) {
                    showCanNotDeleteDialog();
                  } else {
                    showDeleteConfirmDialog(item.id);
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
                  .message_delete_customer_error_having_document),
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
                .message_confirm_delete_customer),
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
      "content":
          "Bạn có thể lưu trữ danh sách các nhà cung cấp. Điền dữ liệu của họ bằng tay hoăc import từ Danh Bạ"
    });
  }

  @override
  bool filterItem(Customer item, String textSearch) {
    return item.name.contains(textSearch);
  }
}
