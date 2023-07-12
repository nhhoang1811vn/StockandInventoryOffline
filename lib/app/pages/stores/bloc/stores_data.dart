import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:good_manager/app/pages/base/base_data.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/stores_settings.dart';

import '../../base/base_state.dart';

part 'stores_data.g.dart';
@CopyWith()
class StoresData extends BaseData{
  final List<Store> items;
  final String textSearch;
  final StoresSettings settings;
  final bool showSearchBar;
  final bool isSelection;

  StoresData({BaseState? state,required this.items, required this.textSearch, required this.settings, required this.showSearchBar, required this.isSelection}) : super(state??InitialState());

}