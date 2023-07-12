import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:good_manager/presentation/pages/base/base_data.dart';
import 'package:good_manager/domain/entities/document.dart';

import '../../../../domain/entities/good.dart';
import '../../../../domain/entities/goods_settings.dart';
import '../../../../domain/entities/group.dart';
import '../../base/base_state.dart';

//part 'goods_data.g.dart';

@CopyWith()
class GoodsData extends BaseData{
  final bool isSelection;
  final DocumentType? documentType = null;
  final bool showSearchBar;
  final String searchText;
  final List<Group> selectedGroups = [];

  final List<Good> goods;
  final List<Group> groups;
  final bool hasSortOptions;
  final GoodsSettings settings;
  GoodsData({BaseState? state, required this.settings, required this.isSelection ,required this.showSearchBar, required this.searchText, required this.goods, required this.groups, required this.hasSortOptions}) : super(state??InitialState());
}