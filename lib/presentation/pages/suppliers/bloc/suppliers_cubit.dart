
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/storage.dart';
import '../../../../domain/entities/sort_by_text.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'suppliers_cubit.freezed.dart';
part 'suppliers_state.dart';

@injectable
class SuppliersCubit extends Cubit<SuppliersState> {
  final SuppliersUseCase useCase;
  final Storage storage;
  SuppliersCubit({required this.storage,required this.useCase}) : super(SuppliersState.initial(state: InitialState()));

  void initState(bool isSelection) async{
    final storeId = storage.getSelectedStoreId();
    final settings = storage.getSupplierSettings();
    List<Supplier> allItems = await useCase.getAllByStoreId(storeId);
    emit(state.copyWith(allItems : allItems, items: allItems, isSelection: isSelection, settings: settings));
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
    return (state.settings?.sortByName != SortByText.no_sort);
  }
  void onSortMenuClicked(){
    emit(state.copyWith(state: OpenSortDialogListState()));
  }
  void onHelpMenuClick(){
    emit(state.copyWith(state: OpenHelpPageState()));
  }

  @override
  void onItemPressed(Supplier item) {
    if (state.isSelection){
      //emite(stat
    }else{
      //emit(state.copyWith(OpenSaveItemState()))
    }
    /*if (isSelection) {
      Navigator.of(getContext()).pop(item);
    } else {
      super.onItemPressed(item);
    }*/
  }

  void onItemLongPressed(Supplier supplier) async {
    /*showDialog(
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
                    showDeleteConfirmDialog(supplier);
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
              content: Text(AppLocalizations.of(getContext())
        context: getContext(),
        builder: (BuildContext builder) => AlertDialog(
              title: Text(
                  AppLocalizations.of(getContext()).notification_dialog_title),
                  .message_delete_supplier_error_having_document),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: const Text('OK'),
                )
              ],
            ));*/
  }

  void showDeleteConfirmDialog(Supplier supplier) {
    /*showDialog(
        context: getContext(),
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(getContext()).notification_dialog_title),
            content: Text(sprintf(
                AppLocalizations.of(getContext())
                    .message_confirm_delete_supplier,
                [supplier.name])),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(getContext()),
                  child: Text(AppLocalizations.of(getContext()).action_cancel)),
              TextButton(
                onPressed: () {
                  Navigator.pop(getContext());
                  presenter.delete(supplier.id);
                },
                child: Text(AppLocalizations.of(getContext()).action_ok),
              )
            ],
          );
        });*/
  }

  @override
  bool filterItem(Supplier item, String textSearch) {
    return item.name.contains(textSearch);
  }
  void onAddItem() {
    emit(state.copyWith(state: OpenSaveItemState()));
  }
}
