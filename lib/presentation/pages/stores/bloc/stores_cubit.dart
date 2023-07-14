import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/presentation/pages/base/base_cubit.dart';
import 'package:good_manager/presentation/pages/stores/bloc/stores_data.dart';

import '../../../../domain/entities/sort_by_text.dart';
import '../../help_content.dart';

class StoresCubit extends BaseCubit<StoresData> {
  StoresCubit(super.initialData);

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
  bool filterItem(Store item, String textSearch) {
    return item.name.contains(textSearch);
  }

  @override
  Store getEmptyItem() {
    return Store();
  }

  @override
  String getSaveItemRouteName() {
    return "Pages.save_store";
  }

  @override
  HelpType getHelpType() {
    return HelpType.STORE;
  }
  @override
  void onItemPressed(Store item) {
    /*if (this.isSelection){
      Navigator.of(getContext()).pop(item);
    }else{
      super.onItemPressed(item);
    }*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}