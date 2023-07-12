
import 'package:good_manager/app/pages/base/base_cubit.dart';
import 'package:good_manager/app/pages/base/base_state.dart';
import 'package:good_manager/app/pages/save_good/bloc/save_good_data.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveGoodCubit extends BaseCubit<SaveGoodData>{

  SaveGoodCubit() : super(SaveGoodData(state: InitialState()));
  @override
  void dispose() {
    // TODO: implement dispose
  }
  //Future<bool> onWillPop() async{
  //
  //}
}