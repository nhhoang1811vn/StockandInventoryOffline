import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helpers/injection.container.dart';
import 'base_cubit.dart';
import 'base_data.dart';

abstract class BasePageState<W extends StatefulWidget, C extends BaseCubit<D>, D extends BaseData> extends State<W>{
  C cubit = getIt();
  @override
  Widget build(BuildContext context) {
    return BlocListener<C, D>(
      bloc: cubit,
      listener: onDataChange,
      child: BlocBuilder<C, D>(
        bloc: cubit,
        builder: buildPage,
      ),
    );
  }
  Widget buildPage(BuildContext context, D data);
  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }
  void onDataChange(BuildContext context, D data) {

  }
}