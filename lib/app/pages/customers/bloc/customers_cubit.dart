import 'package:good_manager/app/pages/base/base_cubit.dart';
import 'package:good_manager/app/pages/customers/bloc/customers_data.dart';
import 'package:good_manager/domain/entities/customer.dart';

import '../../../../domain/entities/sort_by_text.dart';
import '../../help_content.dart';

class CustomersCubit extends BaseCubit<CustomersData> {
  CustomersCubit(super.initialData);

  void initState(bool isSelection){
    //emit(state.copyWith());
  }
  void searchTextChanged(String value){
    emit(state.copyWith(textSearch: value));
  }
  void resetSearchText(){
    emit(state.copyWith(textSearch: ""));
  }
  void onShowSearchBarMenuClicked(){
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
  }
  bool hasSortOptions() {
    return (state.settings.sortByName != SortByText.no_sort);
  }
  void onSortMenuClicked(){

  }
  void onHelpMenuClick(){

  }
  @override
  Customer getEmptyItem() {
    return Customer();
  }

  @override
  String getSaveItemRouteName() {
    return "Pages.save_customer";
  }

  @override
  void onItemPressed(Customer item) {
    /*if (isSelection) {
      Navigator.of(getContext()).pop(item);
    } else {
      super.onItemPressed(item);
    }*/
  }

  void onItemLongPressed(Customer item) async {
    /*showDialog(
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
                    showDeleteConfirmDialog(item);
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
        barrierDismissible: true);*/
  }

  void showCanNotDeleteDialog() {
    /*showDialog(
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
            ));*/
  }

  void showDeleteConfirmDialog(Customer customer) {
    /*showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(getContext())
                    .message_confirm_delete_customer,
                [customer.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  presenter.delete(customer.id);
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });*/
  }

  @override
  bool filterItem(Customer item, String textSearch) {
    return item.name.contains(textSearch);
  }

  @override
  HelpType getHelpType() {
    return HelpType.SUPPLIER_AND_CUSTOMER;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
