import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_data.dart';

abstract class BaseCubit<D extends BaseData> extends Cubit<D>{
  BaseCubit(D initialData): super(initialData);

  void dispose();
}