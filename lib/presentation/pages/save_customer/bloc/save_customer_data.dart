import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:good_manager/presentation/pages/base/base_data.dart';

import '../../base/base_state.dart';

//part 'save_customer_data.g.dart';

@CopyWith()
class SaveCustomerData extends BaseData{
  SaveCustomerData({BaseState? state}) : super(state??InitialState());
}