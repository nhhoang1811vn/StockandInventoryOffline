import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:good_manager/app/pages/base/base_data.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/customers_settings.dart';

import '../../base/base_state.dart';

part 'customers_data.g.dart';

@CopyWith()
class CustomersData extends BaseData{

  final List<Customer> items;
  final String textSearch;
  final CustomersSettings settings;
  final bool showSearchBar;
  final bool isSelection;

  CustomersData({BaseState? state,required this.items, required this.textSearch, required this.settings, required this.showSearchBar, required this.isSelection}) : super(state??InitialState());

}