import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../base/base_state.dart';

part 'report_cubit.freezed.dart';
part 'report_state.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportState.initial(state: InitialState()));
}
