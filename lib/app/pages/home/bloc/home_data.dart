import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:good_manager/app/pages/base/base_data.dart';
import 'package:good_manager/domain/entities/general_infomation.dart';

import '../../base/base_state.dart';

part 'home_data.g.dart';

@CopyWith()
class HomeData extends BaseData{
  final GeneralInformation info;
  HomeData({BaseState? state, required this.info}) : super(state??InitialState());
}